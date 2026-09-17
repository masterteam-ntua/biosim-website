---
layout: page
title: Research Areas
permalink: /research/
nav: true
nav_order: 2
---

{% assign lang_prefix = '' %}{% if site.lang != site.default_lang %}{% assign lang_prefix = '/' | append: site.lang %}{% endif %}

<nav class="section-tabs" aria-label="Research sections">
  <a class="active" href="{{ lang_prefix | append: '/research/' | relative_url }}">{% t research.areas %}</a>
  <a href="{{ lang_prefix | append: '/research/thesis/' | relative_url }}">{% t research.diploma_theses %}</a>
  <a href="{{ lang_prefix | append: '/research/phds/' | relative_url }}">{% t research.phd_theses %}</a>
</nav>

<h2>{% t research.areas %}</h2>

<div class="article-card research-intro" data-aos="fade-up">
  {% if site.lang == 'el' %}
    <p>Το εργαστήριο BioSim μελετά ολοκληρωμένες προσεγγίσεις που συνδυάζουν πολυτροπικά δεδομένα υγείας, τεχνητή νοημοσύνη και μηχανική μάθηση, φυσιολογική και υπολογιστική μοντελοποίηση, βιοϊατρική απεικόνιση, ψηφιακές τεχνολογίες υγείας και παθοφυσιολογικές γνώσεις. Στόχος είναι ο εντοπισμός εξατομικευμένων βιοδεικτών, ο χαρακτηρισμός της ετερογένειας των ασθενειών, η υποστήριξη της έγκαιρης διάγνωσης και της εκτίμησης κινδύνου, καθώς και η διευκόλυνση μιας πιο αποτελεσματικής και εξατομικευμένης διαχείρισης των ασθενειών.</p>
    <p>Σε όλες τις ερευνητικές δραστηριότητες, δίνεται ιδιαίτερη έμφαση στην ανάπτυξη αξιόπιστων και κλινικά ουσιωδών μεθοδολογιών τεχνητής νοημοσύνης, που αντιμετωπίζουν κρίσιμες προκλήσεις σχετικά με την ερμηνευσιμότητα, την αβεβαιότητα, τη γενικευσιμότητα, τη δικαιοσύνη, τον μετριασμό της μεροληψίας και την ανθεκτικότητα σε ετερογενείς πληθυσμούς.</p>
  {% else %}
    <p>BioSim develops integrative approaches that combine multimodal health data, artificial intelligence and machine learning, physiological and computational modelling, biomedical imaging, digital health technologies, and pathophysiological knowledge. The aim is to identify personalized biomarkers, characterize disease heterogeneity, support early diagnosis and risk assessment, and enable more effective and individualized disease management.</p>
    <p>Across its research activities, particular emphasis is placed on the development of reliable and clinically meaningful AI methodologies, addressing critical challenges related to interpretability, uncertainty, generalizability, fairness, bias mitigation, and robustness across heterogeneous populations, acquisition devices, data modalities, and clinical environments.</p>
  {% endif %}
</div>

{% assign research_areas = site.projects | sort: 'importance' %}

<div class="grid">
  {% for area in research_areas %}
    {% if area.importance <= 5 %}
      <a class="card research-card-link" href="{{ lang_prefix | append: area.url | relative_url }}" data-aos="fade-up" data-aos-delay="{{ forloop.index0 | times: 70 }}">
        {% assign area_image = area.image %}{% unless area_image contains '://' %}{% assign area_image = area.image | relative_url %}{% endunless %}
        {% assign area_title = area.title %}{% if site.lang == 'el' and area.title_el %}{% assign area_title = area.title_el %}{% endif %}
        <img src="{{ area_image }}" alt="{{ area_title | escape }}">
        <h3>{{ area_title }}</h3>
        <p>{% if site.lang == 'el' %}{{ area.summary_el }}{% else %}{{ area.summary_en }}{% endif %}</p>
        <div class="tags">{% for tag in area.tags %}<span class="tag">{{ tag }}</span>{% endfor %}</div>
      </a>
    {% endif %}
  {% endfor %}
</div>
