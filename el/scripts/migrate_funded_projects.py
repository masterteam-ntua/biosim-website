"""Import the 36 archived funded-project detail pages into _data/projects.yml.

Run from any directory with: python3 scripts/migrate_funded_projects.py
Install dependencies first with: python3 -m pip install requests beautifulsoup4 pyyaml
Use --check to verify against the old site without writing.
The script refuses to overwrite an already migrated record.
"""

import argparse
from concurrent.futures import ThreadPoolExecutor
import json
from pathlib import Path
import re
import unicodedata

from bs4 import BeautifulSoup, NavigableString
import requests
import yaml


DATA_FILE = Path(__file__).resolve().parent.parent / "_data/projects.yml"
SOURCE = "https://www.biosim.ntua.gr/en/project/"

# In the same order as the existing funded-project records in projects.yml.
PROJECTS = [
    ("ENDORSE", 35),
    ("smarty4covid", 36),
    ("Cockpit Crew Health Monitoring", 33),
    ("SMART-BLISTER", 34),
    ("EDUSAFE", 1),
    ("MOSAIC", 4),
    ("mBioRF", 5),
    ("DEM-II-MED", 6),
    ("SIFEM", 7),
    ("Carotid Atherosclerosis", 8),
    ("Non-ionizing radiation source registry study", 11),
    ("Emerging EMF Technologies and Health Risk Management", 9),
    ("NEUROMATH", 32),
    ("Neuronal network dynamics in motor disorders", 12),
    ("Computational tools for Parkinson's disease and resistant epilepsy", 28),
    ("Micro2DNA", 30),
    ("SMARTDIAB", 3),
    ("fastGATE", 10),
    ("Non ionizing radiation and public health", 27),
    ("Telemedicine network for Aegean and Cyprus remote areas", 13),
    ("EMedIT", 15),
    ("Small animal biological process simulation", 16),
    ("INTERMED", 29),
    ("EMC Related to Wireless Communications", 31),
    ("Protection from non-ionizing radiation of mobile communications", 14),
    ("AMICA", 17),
    ("Small animal PET", 18),
    ("Potential Health Implications from Mobile Communication Systems", 19),
    ("Inverse Scattering for Medical Diagnosis", 20),
    ("GALENOS", 21),
    ("Rational Assessment of Health Effects Related to Mobile Phones", 22),
    ("CT-Based Diagnostic Ability Improvement", 23),
    ("Biomedical Effects of Electromagnetic Fields", 24),
    ("VIRTUOSO", 2),
    ("Mobile Phone Antenna Optimization", 25),
    ("CEPHOS", 26),
]

# These source strings use commas within organization names, periods between
# organizations, or commas within a description of a single partner.
PARTNER_GROUPS = {
    1: ["Public and private organizations and leading institutions in France, Germany, Greece, Italy and Switzerland"],
    2: [
        "Nucletron BV", "Zentrum fur Graphische Datenverarbeitung e.V.",
        "Gesellschaft fur Medizintechnik GmbH", "ATM Group Europe AB",
        "Stadtische Kliniken Offenbach",
        "Universitasklinik fur Strahlentherapie-Radioonkologie, Innsbruck",
    ],
    10: [
        "School of Electrical and Computer Engineering - National Technical University of Athens",
        "Crump Institute for Molecular Imaging, David Geffen School of Medicine at UCLA.",
        "Hardware and Software Engineering Ltd",
    ],
    16: [
        "Institute of Communication and Computer Systems (ICCS)- National Technical University of Athens",
        "Computer Engineer, Head of Computer Engineering Section - Faculty of Electrical Engineering, Polytechnic University of Tirana",
    ],
    20: ["Faculty of Applied Mathematics and Physics, National Technical University of Athens"],
    21: [
        "Philips Hellas Medical Systems", "Medical School, University of Athens",
        '"Saint Savas" General District Anticancer Hospital of Athens',
        '"Metaxa" General District Anticancer Hospital of Piraeus',
        "Medical School, University of Patras",
    ],
    22: ['Department of Electronic Engineering, University of Rome "La Sapienza"'],
    23: ["Medical School, University of Athens"],
    26: [
        "Alcatel", "University of Bradford",
        "Centre National d' Etudes des Telecommunications, CNET",
        "Centro Studi e Laboratori Telecomunicazioni S.p.A., CSELT",
        "ENEA", "Finnish Institute of Occupational Health",
        "National Physics Laboratory", "University of Bristol",
        "University of Bordeaux", "University of Ancona",
    ],
    32: [
        "Selected laboratories from the following COST countries: Austria, Belgium, Denmark, Finland, France, Germany, Greece, Hungary, Italy, Netherlands, Poland, Switzerland, Turkey, and United Kingdom"
    ],
}

# Shortened/reworded YAML titles; the hint still verifies the corresponding
# old-site heading instead of trusting only the numeric ID.
SOURCE_TITLE_HINTS = {
    11: "Preparation of auctioning documents",
    12: "neuronal networks dynamics in motor disorders",
    13: "telemedicine network for remote areas in the Aegean and Cyprus",
    14: "Protection from non ionizing radiation of mobile communications",
    16: "Simulation and modeling of complex biological processes in small animals",
    17: "Assembling Data and Knowledge at the Point of Care",
    20: "Solving the Inverse Scattering Problem",
    22: "Rational Assessment of Health Effects Related to the Use of Mobile Phones",
    23: "Improvement of CT-Based Diagnostic Ability",
    25: "Optimization of Mobile Phone Antenna",
    27: "Non ionizing radiation and pulbic health",
    28: "advanced computational algorithms and tools",
}


def slugify(title):
    ascii_title = unicodedata.normalize("NFKD", title).encode("ascii", "ignore").decode()
    return re.sub(r"-+", "-", re.sub(r"[^a-z0-9]+", "-", ascii_title.lower())).strip("-")


def metadata(article):
    result = {}
    for heading in article.select(".uk-panel.uk-panel-box h4 strong"):
        label = heading.get_text(strip=True)
        if label not in {"Partners", "Duration", "Framework"}:
            continue
        text = ""
        for sibling in heading.next_siblings:
            if isinstance(sibling, NavigableString):
                before_bullet, bullet, _ = str(sibling).partition("•")
                text += before_bullet
                if bullet:
                    break
            else:  # another label or the optional project-website link
                break
        text = re.sub(r"\s+", " ", text).strip().removeprefix(":").strip()
        if text:
            result[label] = text
    return result


def split_partners(source_text, project_id):
    if project_id in PARTNER_GROUPS:
        partners = PARTNER_GROUPS[project_id]
        cursor = 0
        for partner in partners:
            position = source_text.find(partner, cursor)
            if position < 0 or source_text[cursor:position].strip(" .,"):
                raise ValueError(f"Partner grouping no longer matches source page {project_id}")
            cursor = position + len(partner)
        if source_text[cursor:].strip(" .,"):
            raise ValueError(f"Unaccounted partner text on source page {project_id}")
        return partners

    # Split commas only outside parentheses; institutional departments often
    # contain commas inside parentheses and belong to one partner.
    partners, start, depth = [], 0, 0
    for position, char in enumerate(source_text):
        if char == "(":
            depth += 1
        elif char == ")":
            depth -= 1
        elif char == "," and depth == 0:
            partners.append(source_text[start:position].strip())
            start = position + 1
    partners.append(source_text[start:].strip())
    if depth or not all(partners):
        raise ValueError(f"Ambiguous partner list on source page {project_id}")
    return partners


def fetch_project(project):
    title, project_id = project
    url = SOURCE + str(project_id)
    response = requests.get(url, timeout=30)
    response.raise_for_status()
    article = BeautifulSoup(response.text, "html.parser").select_one("article.uk-article")
    if article is None or article.select_one("h1") is None:
        raise ValueError(f"Missing detail-page article: {url}")
    source_title = article.select_one("h1").get_text(" ", strip=True)
    title_hint = SOURCE_TITLE_HINTS.get(project_id, title)
    if title_hint.casefold() not in source_title.casefold():
        raise ValueError(f"Unexpected title for {url}: {source_title}")

    fields = metadata(article)
    if "Duration" not in fields:
        raise ValueError(f"Missing expected duration: {url}")
    details = {
        "slug": slugify(title), "source_url": url, "duration": fields["Duration"],
    }
    if fields.get("Partners"):
        details["partners"] = split_partners(fields["Partners"], project_id)
    if fields.get("Framework"):
        details["framework"] = fields["Framework"]

    # Preserve every body paragraph and its ordering, including the three
    # separate paragraphs of smarty4covid. Do not substitute listing teasers.
    paragraphs = []
    for paragraph in article.find_all("p", recursive=False):
        for link in paragraph.find_all("a", href=True):
            link.replace_with(f"[{link.get_text()}]({link['href']})")
        paragraphs.append(re.sub(r"\s+", " ", paragraph.get_text()).strip())
    paragraphs = [p for p in paragraphs if p]
    if paragraphs:
        details["description_en"] = "\n\n".join(paragraphs)
    return details


def render(fields):
    lines = []
    for key, value in fields.items():
        if key == "description_en":
            lines.append("  description_en: |")
            lines.extend("    " + line if line else "" for line in value.split("\n"))
        elif isinstance(value, list):
            lines.append(f"  {key}:")
            lines.extend("    - " + json.dumps(partner, ensure_ascii=False) for partner in value)
        else:
            lines.append(f"  {key}: " + json.dumps(value, ensure_ascii=False))
    return "\n".join(lines) + "\n"


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--check", action="store_true", help="scrape and validate without writing")
    args = parser.parse_args()
    original = DATA_FILE.read_text(encoding="utf-8")
    current = yaml.safe_load(original)
    if len(current) != 38 or [(record["title_en"], number) for record, (_, number)
                              in zip(current[2:], PROJECTS)] != PROJECTS:
        raise ValueError("The existing project inventory does not match the 36 mapped pages")
    already_migrated = any("source_url" in record for record in current[2:])
    if already_migrated and not args.check:
        raise ValueError("Already migrated: refusing to overwrite existing source data")

    with ThreadPoolExecutor(max_workers=5) as pool:
        details = list(pool.map(fetch_project, PROJECTS))

    if already_migrated:
        for record, fields in zip(current[2:], details):
            for key in ("slug", "source_url", "duration", "partners", "framework", "description_en"):
                actual = record.get(key)
                if key == "description_en" and actual is not None:
                    actual = actual.rstrip("\n")  # YAML literal block's final newline
                if actual != fields.get(key):
                    raise ValueError(f"Source mismatch for {record['title_en']}: {key}")
        for key in ("description_en", "partners", "duration", "framework"):
            print(f"{key}: {sum(bool(record.get(key)) for record in current[2:])}/36")
        print("All migrated fields match the live source pages")
        return

    chunks = re.split(r"(?=^- title_en:)", original, flags=re.MULTILINE)
    if len(chunks) != 39:
        raise ValueError("Unexpected YAML record boundaries")
    migrated = chunks[:3] + [chunk.rstrip("\n") + "\n" + render(fields)
                             for chunk, fields in zip(chunks[3:], details)]
    output = "".join(migrated)
    parsed = yaml.safe_load(output)
    for before, after in zip(current, parsed):
        if any(after.get(key) != value for key, value in before.items()):
            raise ValueError(f"Existing fields changed in {before['title_en']}")
    slugs = [record.get("slug") for record in parsed]
    if len(slugs) != len(set(slugs)) or not all(slugs):
        raise ValueError("Missing or duplicate project slugs")
    for key in ("description_en", "partners", "duration", "framework"):
        print(f"{key}: {sum(bool(record.get(key)) for record in parsed[2:])}/36")
    if not args.check:
        DATA_FILE.write_text(output, encoding="utf-8")
        print(f"Wrote {DATA_FILE}")


if __name__ == "__main__":
    main()
