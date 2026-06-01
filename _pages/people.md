---
layout: page
permalink: /people/
title: People
nav: true
nav_order: 4
---

<div class="people-grid">
  {% for member in site.data.members %}
    <article class="member-card" data-aos="fade-up" data-aos-delay="{{ forloop.index0 | times: 70 }}">
      {% assign member_image = member.image %}{% unless member_image contains '://' %}{% assign member_image = member.image | relative_url %}{% endunless %}
      <img src="{{ member_image }}" alt="{% if site.lang == 'el' %}{{ member.name_el }}{% else %}{{ member.name_en }}{% endif %}">
      <h3>{% if site.lang == 'el' %}{{ member.name_el }}{% else %}{{ member.name_en }}{% endif %}</h3>
      <p class="member-role">{% if site.lang == 'el' %}{{ member.role_el }}{% else %}{{ member.role_en }}{% endif %}</p>
      <p>{% if site.lang == 'el' %}{{ member.group_el }}{% else %}{{ member.group_en }}{% endif %}</p>
      {% if member.email %}<div class="member-links"><a href="mailto:{{ member.email }}">Email</a></div>{% endif %}
    </article>
  {% endfor %}
</div>
