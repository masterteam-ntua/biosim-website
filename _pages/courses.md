---
layout: page
permalink: /courses/
title: Courses
description: Undergraduate and graduate courses connected to BIOSIM teaching activity.
nav: true
nav_order: 7
---

<div class="two-grid">
  <article class="article-card" data-aos="fade-up">
    <h2>{% if site.lang == 'el' %}Προπτυχιακά{% else %}Undergraduate{% endif %}</h2>
    {% if site.lang == 'el' %}
      <p>ΗΜΜΥ: Εργαστήριο Βιοϊατρικής Τεχνολογίας, Μικροκύματα, Εισαγωγή στη Βιοϊατρική Μηχανική, Ιατρική Απεικόνιση και Ψηφιακή Επεξεργασία Ιατρικής Εικόνας, Τεχνολογίες Κινητής & Ηλεκτρονικής Υγείας, Προσομοίωση Φυσιολογικών Συστημάτων.</p>
      <p>ΕΜΦΕ: Αρχές Μετάδοσης Μικροκυματικών και Οπτικών Σημάτων, Εισαγωγή στην Ιατρική Απεικόνιση.</p>
    {% else %}
      <p>ECE: Microwaves, Introduction to Biomedical Engineering, Laboratories in Biomedical Engineering, e-Health and m-Health Technologies, Medical Imaging and Digital Image Processing, Simulation of Physiological Systems.</p>
      <p>AMPS: Microwaves and Optical Systems, Medical Imaging and Digital Image Processing.</p>
    {% endif %}
  </article>
  <article class="article-card" data-aos="fade-up" data-aos-delay="80">
    <h2>{% if site.lang == 'el' %}Μεταπτυχιακά{% else %}Graduate{% endif %}</h2>
    {% if site.lang == 'el' %}
      <p>ΗΜΜΥ: Βιοηλεκτρομαγνητισμός, Βασικές Αρχές και Τεχνολογίες Βιοπληροφορικής.</p>
      <p>Το εργαστήριο υποστηρίζει επίσης διπλωματικές εργασίες και διδακτορική έρευνα στη βιοϊατρική μηχανική, τα ευφυή συστήματα υγείας, την ιατρική απεικόνιση, την ανάλυση βιοσημάτων και την υπολογιστική φυσιολογία.</p>
    {% else %}
      <p>ECE: Bioelectromagnetics, Basic Principles and Technologies in Bioinformatics.</p>
      <p>The lab also supports diploma theses and PhD research in biomedical engineering, smart health systems, medical imaging, biosignal analysis, and computational physiology.</p>
    {% endif %}
  </article>
</div>
