---
layout: page
permalink: /people/
title: People
nav: true
nav_order: 4
---

<div markdown="0">
{% assign categories = "faculty|researchers|phd_candidates|collaborators|visitors|alumni" | split: "|" %}
{% assign label_en = "Faculty|Researchers|PhD Candidates|Collaborators|Visitors|Alumni" | split: "|" %}
{% assign label_el = "Μέλη ΔΕΠ|Ερευνητές|Υποψήφιοι Διδάκτορες|Συνεργάτες|Επισκέπτες|Απόφοιτοι" | split: "|" %}

{% for i in (0..5) %}
{% assign cat = categories[i] %}
{% assign group = site.data.members | where: "category", cat %}
{% if group.size > 0 %}

<h2 class="people-category-heading">{% if site.lang == 'el' %}{{ label_el[i] }}{% else %}{{ label_en[i] }}{% endif %}</h2>

<div class="people-grid">
{% for member in group %}
<article class="member-card" data-aos="fade-up" data-aos-delay="{{ forloop.index0 | times: 70 }}" onclick="window.location.href='{{ member.profile | relative_url }}'" style="cursor: pointer;">
{% if member.image %}
{% assign member_image = member.image %}
{% unless member_image contains '://' %}
{% assign member_image = member.image | relative_url %}
{% endunless %}
<img src="{{ member_image }}" alt="{% if site.lang == 'el' %}{{ member.name_el }}{% else %}{{ member.name_en }}{% endif %}">
{% endif %}
<h3>{% if site.lang == 'el' %}{{ member.name_el }}{% else %}{{ member.name_en }}{% endif %}</h3>
<p class="member-role">{% if site.lang == 'el' %}{{ member.role_el }}{% else %}{{ member.role_en }}{% endif %}</p>
{% if member.email %}<div class="member-links"><a href="mailto:{{ member.email }}" onclick="event.stopPropagation()">Email</a></div>{% endif %}
</article>
{% endfor %}
</div>
{% endif %}
{% endfor %}

</div>
