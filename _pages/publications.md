---
layout: page
permalink: /publications/
title: Publications
nav: true
nav_order: 3
---

<div class="publication-tools" data-aos="fade-up" data-publication-filters>
  <label class="publication-search">
    <input type="search" data-publication-search aria-label="{% t publications.search %}" placeholder="{% t publications.search_placeholder %}">
  </label>
  <div class="publication-year-range">
    <div class="publication-range-labels">
      <output data-publication-min-label></output>
      <output data-publication-max-label></output>
    </div>
    <div class="publication-range-inputs">
      <input type="range" data-publication-year-min aria-label="{% t publications.year_from %}">
      <input type="range" data-publication-year-max aria-label="{% t publications.year_to %}">
    </div>
  </div>
  <div class="publication-quick-years" aria-label="{% t publications.quick_years %}">
    <button class="filter-button active" type="button" data-publication-year="">{% t publications.all_years %}</button>
    <button class="filter-button" type="button" data-publication-year="2026">2026</button>
    <button class="filter-button" type="button" data-publication-year="2025">2025</button>
    <button class="filter-button" type="button" data-publication-year="2024">2024</button>
  </div>
  <p class="publication-count" data-publication-count data-singular="{% t publications.count_singular %}" data-plural="{% t publications.count_plural %}" aria-live="polite"></p>
</div>

<div class="publications" data-aos="fade-up">
  {% bibliography %}
  <p class="publication-empty" data-publication-empty hidden>{% t publications.no_matches %}</p>
</div>
