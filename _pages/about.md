---
layout: default
title: BioSim Lab
permalink: /
---

<section class="hero">
  <div id="tsparticles" aria-hidden="true"></div>
  <div class="container hero-content" data-aos="fade-up">
    <div class="hero-copy">
      <h1 class="hero-logo-title">
        <img class="logo-rgb" src="{{ '/biosim_logo_files/svg/biosim_logo.svg' | relative_url }}" alt="BIOSIM Laboratory">
        <img class="logo-dark" src="{{ '/biosim_logo_files/svg/biosim_logo_grayscale.svg' | relative_url }}" alt="BIOSIM Laboratory">
      </h1>
      <p class="lead">{% t home.intro %} <span class="typed"></span></p>
      <div class="hero-actions">
        {% assign lang_prefix = '' %}{% if site.lang != site.default_lang %}{% assign lang_prefix = '/' | append: site.lang %}{% endif %}
        <a class="button" href="{{ lang_prefix | append: '/research/' | relative_url }}">{% t home.cta_research %}</a>
        <a class="button secondary" href="{{ lang_prefix | append: '/contact/' | relative_url }}">{% t home.cta_contact %}</a>
      </div>
      <div class="stats" data-aos="fade-up" data-aos-delay="100">
        <div class="stat-card"><span class="stat-number" data-count="{{ site.lab.stats.publications }}">0</span><span class="stat-label">{% t home.stats_publications %}</span></div>
        <div class="stat-card"><span class="stat-number" data-count="{{ site.lab.stats.members }}">0</span><span class="stat-label">{% t home.stats_members %}</span></div>
        <div class="stat-card"><span class="stat-number" data-count="{{ site.lab.stats.projects }}">0</span><span class="stat-label">{% t home.stats_projects %}</span></div>
        <div class="stat-card"><span class="stat-number" data-count="{{ site.lab.stats.years }}">0</span><span class="stat-label">{% t home.stats_years %}</span></div>
      </div>
    </div>
    <div class="hero-visual" aria-label="BIOSIM Laboratory highlights">
      <div class="swiper hero-swiper">
        <div class="swiper-wrapper">
          <div class="swiper-slide"><img src="{{ '/assets/img/news/ntua-digital-health-day-2023.webp' | relative_url }}" alt="NTUA Digital Health Day audience"></div>
          <div class="swiper-slide"><img src="{{ '/assets/img/news/the-2021-ntua-biotech-day-was-a-success.png' | relative_url }}" alt="NTUA Biotech Day event"></div>
          <div class="swiper-slide"><img src="{{ '/assets/img/news/biosim-at-ece-ntua-lab-day-2018.jpg' | relative_url }}" alt="BIOSIM at ECE NTUA Lab Day"></div>
          <div class="swiper-slide"><img src="{{ '/assets/img/news/professor-nantia-nikita-presents-research-activities-at-biosim-lab.png' | relative_url }}" alt="BIOSIM research presentation"></div>
        </div>
        <div class="swiper-pagination"></div>
      </div>
    </div>
  </div>
</section>

<section class="section">
  <div class="container two-grid">
    <article class="article-card" data-aos="fade-up">
      {% if site.lang == 'el' %}
        <h2>Βιοϊατρικές Προσομοιώσεις και Απεικονιστική Τεχνολογία από το 1999</h2>
        <p>Το εργαστήριο BIOSIM υπάγεται στη Σχολή Ηλεκτρολόγων Μηχανικών και Μηχανικών Υπολογιστών και στο ΕΠΙΣΕΥ του Εθνικού Μετσόβιου Πολυτεχνείου.</p>
        <p>Συμμετέχει στη διδασκαλία προπτυχιακών και μεταπτυχιακών μαθημάτων σε μικροκύματα, ιατρική απεικόνιση, βιοϊατρική τεχνολογία, προσομοίωση φυσιολογικών συστημάτων, τεχνολογίες e-Health/m-Health, βιοηλεκτρομαγνητισμό και βιοπληροφορική.</p>
      {% else %}
        <h2>Biomedical Simulations and Imaging since 1999</h2>
        <p>The Biomedical Simulations and Imaging Laboratory is part of the Institute of Communication and Computer Systems and the Faculty of Electrical and Computer Engineering of the National Technical University of Athens.</p>
        <p>The laboratory contributes to undergraduate and postgraduate teaching in microwaves, medical imaging and digital image processing, biomedical engineering laboratory work, simulation of physiological systems, e-Health and m-Health technologies, bioelectromagnetics, and bioinformatics.</p>
      {% endif %}
    </article>
    <article class="article-card" data-aos="fade-up" data-aos-delay="80">
      {% if site.lang == 'el' %}
        <h2>Μέλη, διπλωματικές και ερευνητικά έργα</h2>
        <p>Το BIOSIM αποτελείται από 25 μέλη, 13 από τα οποία είναι κάτοχοι διδακτορικού διπλώματος και 12 υποψήφιοι διδάκτορες. Κάθε χρόνο εκπονούνται 10-12 διπλωματικές εργασίες υπό την επίβλεψη έμπειρου προσωπικού.</p>
        <p>Τα τελευταία χρόνια το εργαστήριο έχει συμμετάσχει σε περισσότερα από 30 ευρωπαϊκά και εθνικά χρηματοδοτούμενα έργα.</p>
      {% else %}
        <h2>People, theses, and funded projects</h2>
        <p>BIOSIM currently consists of 25 people, including researchers with PhD degrees and PhD candidates. Each year, 10-12 diploma theses are developed under the supervision of experienced staff.</p>
        <p>Over the last years, BIOSIM has participated in more than 30 European and national funded projects.</p>
      {% endif %}
    </article>
  </div>
</section>

<section class="section">
  <div class="container">
    <div class="section-heading" data-aos="fade-up">
      <div><h2>{% t home.latest_news %}</h2></div>
      <a class="button secondary" href="{{ lang_prefix | append: '/news/' | relative_url }}">{% t nav.news %}</a>
    </div>
    <div class="swiper news-swiper" data-aos="fade-up">
      <div class="swiper-wrapper">
        {% assign latest_news = site.news | sort: 'date' | reverse | slice: 0, 5 %}
        {% for item in latest_news %}
          <article class="swiper-slide news-card">
            {% assign news_image = item.image %}
            {% assign preview_title = item.short_title | default: item.title %}
            {% if site.lang == 'el' %}{% assign preview_title = item.short_title_el | default: item.title_el | default: preview_title %}{% endif %}
            {% assign long_title = item.title %}
            {% if site.lang == 'el' and item.title_el %}{% assign long_title = item.title_el %}{% endif %}
            {% assign preview_text = long_title %}
            {% if preview_title == preview_text %}{% assign preview_text = item.content | strip_html | truncate: 150 %}{% endif %}
            {% if site.lang == 'el' and item.summary_el %}{% assign preview_text = item.summary_el | truncate: 150 %}{% endif %}
            {% if news_image %}<img src="{{ news_image | relative_url }}" alt="{{ preview_title | escape }}">{% endif %}
            <p class="meta">{{ item.date | date: "%b %-d, %Y" }}</p>
            <h3><a href="{{ lang_prefix | append: item.url | relative_url }}">{{ preview_title }}</a></h3>
            {% if preview_text %}<p>{{ preview_text }}</p>{% endif %}
          </article>
        {% endfor %}
      </div>
      <div class="swiper-pagination"></div>
    </div>
  </div>
</section>

<section class="section">
  <div class="container">
    <div class="section-heading" data-aos="fade-up">
      <div><h2>{% t home.featured_projects %}</h2></div>
    </div>
    <div class="grid">
      {% assign featured_projects = site.data.projects | slice: 0, 3 %}
      {% for project in featured_projects %}
        <article class="card" data-aos="fade-up" data-aos-delay="{{ forloop.index0 | times: 80 }}">
          {% assign project_image = project.image %}{% if project_image %}{% unless project_image contains '://' %}{% assign project_image = project_image | relative_url %}{% endunless %}{% endif %}
          {% if project_image %}<img src="{{ project_image }}" alt="{% if site.lang == 'el' %}{{ project.title_el }}{% else %}{{ project.title_en }}{% endif %}">{% endif %}
          <h3>{% if site.lang == 'el' %}{{ project.title_el }}{% else %}{{ project.title_en }}{% endif %}</h3>
          <p>{% if site.lang == 'el' %}{{ project.summary_el }}{% else %}{{ project.summary_en }}{% endif %}</p>
          <div class="tags">{% for tag in project.tags %}<span class="tag">{{ tag }}</span>{% endfor %}</div>
        </article>
      {% endfor %}
    </div>
  </div>
</section>
