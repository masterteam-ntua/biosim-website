---
layout: page
title: Projects
permalink: /projects/
nav: true
nav_order: 3
---

<div class="grid">
  {% for project in site.data.projects %}
    <article class="card" data-aos="fade-up" data-aos-delay="{{ forloop.index0 | times: 70 }}">
      {% assign project_image = project.image %}
      {% if project_image %}{% unless project_image contains '://' %}{% assign project_image = project_image | relative_url %}{% endunless %}{% endif %}
      {% if project_image %}<img src="{{ project_image }}" alt="{% if site.lang == 'el' %}{{ project.title_el | escape }}{% else %}{{ project.title_en | escape }}{% endif %}">{% endif %}
      <h3>{% if site.lang == 'el' %}{{ project.title_el }}{% else %}{{ project.title_en }}{% endif %}</h3>
      <p>{% if site.lang == 'el' %}{{ project.summary_el }}{% else %}{{ project.summary_en }}{% endif %}</p>
      <div class="tags">{% for tag in project.tags %}<span class="tag">{{ tag }}</span>{% endfor %}</div>
    </article>
  {% endfor %}
</div>
