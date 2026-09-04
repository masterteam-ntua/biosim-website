---
layout: default
title: BioSim Lab
permalink: /
---

<section class="hero">
  <div id="tsparticles" aria-hidden="true"></div>
  <div class="container hero-content" data-aos="fade-up">
    <div class="hero-main">
      <div class="hero-intro-panel">
        <h1 class="hero-logo-title">
          <img class="logo-rgb" src="{{ '/biosim_logo_files/svg/biosim_logo.svg' | relative_url }}" alt="BIOSIM Laboratory">
          <img class="logo-dark" src="{{ '/biosim_logo_files/svg/biosim_logo_grayscale.svg' | relative_url }}" alt="BIOSIM Laboratory">
        </h1>
        <p class="lead">
          <span class="lead-static">{% t home.intro %}</span>
          <span class="typed-wrap"><span class="typed"></span></span>
        </p>
      </div>
      <div class="hero-visual" aria-label="BIOSIM Laboratory highlights">
        <div class="swiper hero-swiper">
          <div class="swiper-wrapper">
            <div class="swiper-slide"><img src="{{ '/assets/img/news/ntua-digital-health-day-2023.webp' | relative_url }}" alt="NTUA Digital Health Day audience"></div>
            <div class="swiper-slide"><img src="{{ '/assets/img/news/the-2021-ntua-biotech-day-was-a-success.webp' | relative_url }}" alt="NTUA Biotech Day event"></div>
            <div class="swiper-slide"><img src="{{ '/assets/img/news/biosim-at-ece-ntua-lab-day-2018.webp' | relative_url }}" alt="BIOSIM at ECE NTUA Lab Day"></div>
            <div class="swiper-slide"><img src="{{ '/assets/img/news/professor-nantia-nikita-presents-research-activities-at-biosim-lab.webp' | relative_url }}" alt="BIOSIM research presentation"></div>
          </div>
          <div class="swiper-pagination"></div>
        </div>
      </div>
    </div>
    <div class="hero-meta-row">
      <div class="stats" data-aos="fade-up" data-aos-delay="100">
        <div class="stat-card"><span class="stat-number" data-count="{{ site.lab.stats.publications }}">0</span><span class="stat-label">{% t home.stats_publications %}</span></div>
        <div class="stat-card"><span class="stat-number" data-count="{{ site.lab.stats.members }}">0</span><span class="stat-label">{% t home.stats_members %}</span></div>
        <div class="stat-card"><span class="stat-number" data-count="{{ site.lab.stats.years }}">0</span><span class="stat-label">{% t home.stats_years %}</span></div>
      </div>
      <div class="hero-actions">
        {% assign lang_prefix = '' %}{% if site.lang != site.default_lang %}{% assign lang_prefix = '/' | append: site.lang %}{% endif %}
        <a class="button" href="{{ lang_prefix | append: '/research/' | relative_url }}">{% t home.cta_research %}</a>
        <a class="button secondary" href="{{ lang_prefix | append: '/contact/' | relative_url }}">{% t home.cta_contact %}</a>
      </div>
    </div>
  </div>
</section>

<section class="section">
  <div class="container">
    <div class="article-card home-research-showcase" data-aos="fade-up">
      <div class="home-research-copy">
        {% if site.lang == 'el' %}
          <p class="eyebrow">Ερευνητική δραστηριότητα</p>
          <h2>Από τα βιοϊατρικά δεδομένα σε κλινικά χρήσιμη γνώση</h2>
          <p>Το BIOSIM αναπτύσσει υπολογιστικές μεθόδους, μοντέλα φυσιολογικών συστημάτων και τεχνολογίες Τεχνητής Νοημοσύνης για εφαρμογές στη βιοϊατρική τεχνολογία και την ψηφιακή υγεία.</p>
          <p>Οι ερευνητικές περιοχές του εργαστηρίου συνδυάζουν απεικονιστικά δεδομένα, βιοσήματα, προσομοιώσεις και συστήματα υποστήριξης αποφάσεων για αξιόπιστες και εξατομικευμένες λύσεις υγείας.</p>
        {% else %}
          <p class="eyebrow">Research activity</p>
          <h2>From biomedical data to clinically meaningful intelligence</h2>
          <p>BIOSIM develops computational methods, physiological system models, and AI technologies for biomedical engineering and digital health applications.</p>
          <p>The lab's research areas combine imaging data, biosignals, simulations, and decision-support systems to support reliable and personalized healthcare solutions.</p>
        {% endif %}
        <a class="button secondary" href="{{ lang_prefix | append: '/research/' | relative_url }}">{% t home.cta_research %}</a>
      </div>
      <div class="swiper research-area-swiper">
        <div class="swiper-wrapper">
          {% assign research_areas = site.projects | sort: 'importance' %}
          {% for area in research_areas %}
            {% if area.importance <= 5 %}
              {% assign area_title = area.title %}{% if site.lang == 'el' and area.title_el %}{% assign area_title = area.title_el %}{% endif %}
              {% assign area_image = area.image %}{% unless area_image contains '://' %}{% assign area_image = area.image | relative_url %}{% endunless %}
              <div class="swiper-slide">
                <a class="research-area-tile" href="{{ lang_prefix | append: area.url | relative_url }}">
                  <img src="{{ area_image }}" alt="{{ area_title | escape }}">
                  <h3>{{ area_title }}</h3>
                  <p>{% if site.lang == 'el' %}{{ area.summary_el }}{% else %}{{ area.summary_en }}{% endif %}</p>
                  <div class="tags">{% for tag in area.tags %}<span class="tag">{{ tag }}</span>{% endfor %}</div>
                </a>
              </div>
            {% endif %}
          {% endfor %}
        </div>
        <div class="swiper-pagination"></div>
      </div>
    </div>
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
        {% assign latest_news = site.news | sort: 'date' | reverse | slice: 0, 12 %}
        {% assign page1 = latest_news | slice: 0, 6 %}
        {% assign page2 = latest_news | slice: 6, 6 %}
        {% for page_items in (1..2) %}
          {% if page_items == 1 %}{% assign items = page1 %}{% else %}{% assign items = page2 %}{% endif %}
          <div class="swiper-slide">
            <div class="news-swiper-grid">
              {% for item in items %}
                <article class="news-card">
                {% assign news_image = item.image %}
                {% assign preview_title = item.short_title | default: item.title %}
                {% if site.lang == 'el' %}{% assign preview_title = item.short_title_el | default: item.title_el | default: preview_title %}{% endif %}
                {% assign long_title = item.title %}
                {% if site.lang == 'el' and item.title_el %}{% assign long_title = item.title_el %}{% endif %}
                {% assign preview_text = long_title %}
                {% if preview_title == preview_text %}{% assign preview_text = item.content | strip_html %}{% endif %}
                {% if site.lang == 'el' and item.summary_el %}{% assign preview_text = item.summary_el %}{% endif %}
                <div class="news-card-media">{% if news_image %}<img src="{{ news_image | relative_url }}" alt="{{ preview_title | escape }}">{% endif %}</div>
                <p class="meta news-card-meta">{{ item.date | date: "%b %-d, %Y" }}</p>
                <h3 class="news-card-title"><a href="{{ lang_prefix | append: item.url | relative_url }}">{{ preview_title }}</a></h3>
                  {% if preview_text %}<p class="news-card-preview">{{ preview_text }}</p>{% endif %}
                </article>
              {% endfor %}
            </div>
          </div>
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
      {% assign featured_project_titles = 'ENDORSE,SMART-BLISTER,smarty4covid' | split: ',' %}
      {% for featured_title in featured_project_titles %}
        {% for project in site.data.projects %}
          {% if project.title_en == featured_title %}
            <article class="card" data-aos="fade-up" data-aos-delay="{{ forloop.index0 | times: 80 }}">
              {% assign project_image = project.image %}{% if project_image %}{% unless project_image contains '://' %}{% assign project_image = project_image | relative_url %}{% endunless %}{% endif %}
              {% if project_image %}<img src="{{ project_image }}" alt="{% if site.lang == 'el' %}{{ project.title_el }}{% else %}{{ project.title_en }}{% endif %}">{% endif %}
              <h3>{% if site.lang == 'el' %}{{ project.title_el }}{% else %}{{ project.title_en }}{% endif %}</h3>
              <p>{% if site.lang == 'el' %}{{ project.summary_el }}{% else %}{{ project.summary_en }}{% endif %}</p>
              <div class="tags">{% for tag in project.tags %}<span class="tag">{{ tag }}</span>{% endfor %}</div>
            </article>
          {% endif %}
        {% endfor %}
      {% endfor %}
    </div>
  </div>
</section>
