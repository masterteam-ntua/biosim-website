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
