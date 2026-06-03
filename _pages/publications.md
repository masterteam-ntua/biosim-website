---
layout: page
permalink: /publications/
title: Publications
nav: true
nav_order: 3
---

<div class="publication-tools" data-aos="fade-up" data-publication-filters>
  <label class="publication-search">
    <span>Search publications</span>
    <input type="search" data-publication-search placeholder="Title, author, venue...">
  </label>
  <label class="publication-year-filter">
    <span>Year</span>
    <select data-publication-year-select>
      <option value="">All years</option>
    </select>
  </label>
  <div class="publication-quick-years" aria-label="Quick year filters">
    <button class="filter-button active" type="button" data-publication-year="">All years</button>
    <button class="filter-button" type="button" data-publication-year="2026">2026</button>
    <button class="filter-button" type="button" data-publication-year="2025">2025</button>
    <button class="filter-button" type="button" data-publication-year="2024">2024</button>
  </div>
  <p class="publication-count" data-publication-count aria-live="polite"></p>
</div>

<div class="publications" data-aos="fade-up">
  {% bibliography %}
  <p class="publication-empty" data-publication-empty hidden>No publications match these filters.</p>
</div>
