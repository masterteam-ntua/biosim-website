---
layout: page
title: Projects
permalink: /projects/
nav: true
nav_order: 3
---

{% assign lang_prefix = '' %}{% if site.lang != site.default_lang %}{% assign lang_prefix = '/' | append: site.lang %}{% endif %}

<div class="grid featured-projects">
  {% for project in site.data.projects %}
    {% if project.featured %}{% include funded-project-card.html project=project %}{% endif %}
  {% endfor %}
</div>

<div class="project-list" data-aos="fade-up">
  {% for project in site.data.projects %}
    {% unless project.featured %}
      <article class="project-list-item">
        <div>
          {% include project-status.html project=project %}
          <h3><a href="{{ lang_prefix | append: '/projects/' | append: project.slug | append: '/' | relative_url }}">{% if site.lang == 'el' and project.title_el %}{{ project.title_el }}{% else %}{{ project.title_en }}{% endif %}</a></h3>
          <p>{% if site.lang == 'el' %}{{ project.summary_el }}{% else %}{{ project.summary_en }}{% endif %}</p>
          {% if project.duration or project.framework %}<dl class="project-card-meta">{% if project.duration %}<div><dt>{% t projects.duration %}</dt><dd>{{ project.duration }}</dd></div>{% endif %}{% if project.framework %}<div><dt>{% t projects.framework %}</dt><dd>{{ project.framework }}</dd></div>{% endif %}</dl>{% endif %}
        </div>
        <div class="tags">{% for tag in project.tags %}<span class="tag">{{ tag }}</span>{% endfor %}</div>
      </article>
    {% endunless %}
  {% endfor %}
</div>
