---
layout: page
title: Projects
permalink: /projects/
nav: true
nav_order: 3
---

{% assign featured_project_titles = 'ENDORSE,SMART-BLISTER,smarty4covid' | split: ',' %}
{% assign featured_project_keys = '|ENDORSE|SMART-BLISTER|smarty4covid|' %}

<div class="grid featured-projects">
  {% for featured_title in featured_project_titles %}
    {% for project in site.data.projects %}
      {% if project.title_en == featured_title %}
        <article class="card" data-aos="fade-up" data-aos-delay="{{ forloop.index0 | times: 70 }}">
          {% assign project_image = project.image %}
          {% if project_image %}{% unless project_image contains '://' %}{% assign project_image = project_image | relative_url %}{% endunless %}{% endif %}
          {% if project_image %}<img src="{{ project_image }}" alt="{% if site.lang == 'el' %}{{ project.title_el | escape }}{% else %}{{ project.title_en | escape }}{% endif %}">{% endif %}
          <h3>{% if site.lang == 'el' %}{{ project.title_el }}{% else %}{{ project.title_en }}{% endif %}</h3>
          <p>{% if site.lang == 'el' %}{{ project.summary_el }}{% else %}{{ project.summary_en }}{% endif %}</p>
          <div class="tags">{% for tag in project.tags %}<span class="tag">{{ tag }}</span>{% endfor %}</div>
        </article>
      {% endif %}
    {% endfor %}
  {% endfor %}
</div>

<div class="project-list" data-aos="fade-up">
  {% for project in site.data.projects %}
    {% assign project_key = '|' | append: project.title_en | append: '|' %}
    {% unless featured_project_keys contains project_key %}
      <article class="project-list-item">
        <div>
          <h3>{% if site.lang == 'el' %}{{ project.title_el }}{% else %}{{ project.title_en }}{% endif %}</h3>
          <p>{% if site.lang == 'el' %}{{ project.summary_el }}{% else %}{{ project.summary_en }}{% endif %}</p>
        </div>
        <div class="tags">{% for tag in project.tags %}<span class="tag">{{ tag }}</span>{% endfor %}</div>
      </article>
    {% endunless %}
  {% endfor %}
</div>
