---
layout: page
permalink: /contact/
title: Contact
nav: true
nav_order: 6
---

<div class="two-grid">
  <div class="article-card" data-aos="fade-up">
    <h2>BIOSIM Laboratory</h2>
    <p><strong>{{ site.lab.director }}</strong></p>
    <p>{% if site.lang == 'el' %}{{ site.lab.address_el }}{% else %}{{ site.lab.address_en }}{% endif %}</p>
    <p><strong>Tel:</strong> {{ site.lab.phone }}</p>
    <p><strong>Email:</strong> <a href="mailto:{{ site.lab.email }}">{{ site.lab.email }}</a></p>
    <div class="member-links">
      <a href="https://www.ntua.gr/">NTUA</a>
      <a href="https://www.ece.ntua.gr/">ECE NTUA</a>
      <a href="{{ site.lab.map_url }}">Google Maps</a>
      <a href="https://www.linkedin.com/">LinkedIn</a>
    </div>
  </div>
  <iframe class="map" loading="lazy" allowfullscreen referrerpolicy="no-referrer-when-downgrade" src="{{ site.lab.map_embed_url }}"></iframe>
</div>

<section class="section">
  <div class="two-grid">
    <article class="article-card" data-aos="fade-up">
      <h2>{% if site.lang == 'el' %}Γραφεία{% else %}Offices{% endif %}</h2>
      {% if site.lang == 'el' %}
        <p><strong>Παλιά Κτίρια Ηλεκτρολόγων Μηχανικών και Μηχανικών Υπολογιστών</strong></p>
        <p>Γραφείο Καθηγήτριας Κωνσταντίνας Νικήτα: Γραφείο 1.1.18<br>Γραφείο Υποψηφίων Διδακτόρων και Μεταδιδακτορικών ερευνητών: Γραφείο 1.1.2<br>Γραφείο Υποψηφίων Διδακτόρων και Μεταδιδακτορικών ερευνητών: Γραφείο 2.1.26</p>
        <p><strong>Κτίριο Ηλεκτρονικών Υπολογιστών</strong></p><p>Γραφείο 1.16<br>Γραφείο 1.17</p>
      {% else %}
        <p><strong>Old Buildings of Faculty of Electrical and Computer Engineering</strong></p>
        <p>Professor's Nikita Office: Room 1.1.18<br>PhD & Post Doc Office: Room 1.1.2<br>PhD & Post Doc Office: Room 2.1.26</p>
        <p><strong>Central Computer Building</strong></p><p>Room 1.16<br>Room 1.17</p>
      {% endif %}
    </article>
    <article class="article-card" data-aos="fade-up" data-aos-delay="80">
      <h2>{% if site.lang == 'el' %}Πώς να φτάσετε{% else %}How to get here{% endif %}</h2>
      {% if site.lang == 'el' %}
        <p>Με μετρό, αποβιβαστείτε στον σταθμό Κατεχάκη, διασχίστε τη λεωφόρο Κατεχάκη και χρησιμοποιήστε το λεωφορείο 242 ή 140 προς την Πολυτεχνειούπολη Ζωγράφου. Με ταξί, ζητήστε “Πολυτεχνειούπολη Ζωγράφου” κοντά στη λεωφόρο Κατεχάκη.</p>
      {% else %}
        <p>By metro, get off at Katechaki station, cross Katechaki Avenue, and take bus 242 or 140 towards the NTUA Zografou Campus. By taxi, ask for “Polytechnioupolis Zografou” near Katechaki Avenue.</p>
      {% endif %}
    </article>
  </div>
</section>
