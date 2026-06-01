---
layout: page
title: Diploma Theses
permalink: /research/thesis/
nav: false
---

{% assign lang_prefix = '' %}{% if site.lang != site.default_lang %}{% assign lang_prefix = '/' | append: site.lang %}{% endif %}

<nav class="section-tabs" aria-label="Research sections">
  <a href="{{ lang_prefix | append: '/research/' | relative_url }}">{% t research.areas %}</a>
  <a class="active" href="{{ lang_prefix | append: '/research/thesis/' | relative_url }}">{% t research.diploma_theses %}</a>
  <a href="{{ lang_prefix | append: '/research/phds/' | relative_url }}">{% t research.phd_theses %}</a>
</nav>

<div class="thesis-list">
  {% for group in site.data.diploma_theses %}
    <section class="thesis-year" data-aos="fade-up">
      <h2>{{ group.year }}</h2>
      <ul>
        {% for thesis in group.entries %}
          <li>
            <strong>{{ thesis.author }}</strong>,
            {% if thesis.url %}<a href="{{ thesis.url }}">{{ thesis.title }}</a>{% else %}{{ thesis.title }}{% endif %}
            {% if thesis.details %}<span class="meta">{{ thesis.details }}</span>{% endif %}
          </li>
        {% endfor %}
      </ul>
    </section>
  {% endfor %}
</div>
