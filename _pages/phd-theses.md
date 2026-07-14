---
layout: page
title: PhD Theses
permalink: /research/phds/
nav: false
---

{% assign lang_prefix = '' %}{% if site.lang != site.default_lang %}{% assign lang_prefix = '/' | append: site.lang %}{% endif %}

<nav class="section-tabs" aria-label="Research sections">
  <a href="{{ lang_prefix | append: '/research/' | relative_url }}">{% t research.areas %}</a>
  <a href="{{ lang_prefix | append: '/research/thesis/' | relative_url }}">{% t research.diploma_theses %}</a>
  <a class="active" href="{{ lang_prefix | append: '/research/phds/' | relative_url }}">{% t research.phd_theses %}</a>
</nav>

<div class="thesis-list">
  <section class="thesis-year" data-aos="fade-up">
    <ul>
      {% assign phd_theses = site.data.phd_theses.entries | default: site.data.phd_theses %}
      {% for thesis in phd_theses %}
        <li>
          {% if site.lang == 'el' %}
            <strong>{{ thesis.author_el }}</strong>,
            {% if thesis.url %}<a href="{{ thesis.url }}">{{ thesis.title_el }}</a>{% else %}{{ thesis.title_el }}{% endif %}
            {% if thesis.details_el %}<span class="meta">{{ thesis.details_el }}</span>{% endif %}
          {% else %}
            <strong>{{ thesis.author_en }}</strong>,
            {% if thesis.url %}<a href="{{ thesis.url }}">{{ thesis.title_en }}</a>{% else %}{{ thesis.title_en }}{% endif %}
            {% if thesis.details_en %}<span class="meta">{{ thesis.details_en }}</span>{% endif %}
          {% endif %}
        </li>
      {% endfor %}
    </ul>
  </section>
</div>
