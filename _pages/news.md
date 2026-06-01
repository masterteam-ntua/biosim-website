---
layout: page
permalink: /news/
title: News
nav: true
nav_order: 5
---

<div class="grid">
  {% assign news_items = site.news | sort: 'date' | reverse %}
  {% for item in news_items %}
    <article class="news-card" data-aos="fade-up">
      {% assign news_image = item.image %}
      {% assign preview_title = item.short_title | default: item.title %}
      {% if site.lang == 'el' %}{% assign preview_title = item.short_title_el | default: item.title_el | default: preview_title %}{% endif %}
      {% assign long_title = item.title %}
      {% if site.lang == 'el' and item.title_el %}{% assign long_title = item.title_el %}{% endif %}
      {% if news_image %}<img src="{{ news_image | relative_url }}" alt="{{ preview_title | escape }}">{% endif %}
      <p class="meta">{{ item.date | date: "%B %-d, %Y" }}</p>
      {% assign lang_prefix = '' %}{% if site.lang != site.default_lang %}{% assign lang_prefix = '/' | append: site.lang %}{% endif %}
      <h3><a href="{{ lang_prefix | append: item.url | relative_url }}">{{ long_title }}</a></h3>
      {% if long_title != preview_title %}<p>{{ preview_title }}</p>{% endif %}
    </article>
  {% endfor %}
</div>
