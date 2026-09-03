---
layout: page
permalink: /contact/
title: Contact
nav: true
nav_order: 6
---

<section class="section">
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
</section>

<section class="section">
  <div class="section-heading" data-aos="fade-up">
    <div><h2>{% if site.lang == 'el' %}Σχετικά με το BIOSIM{% else %}About BIOSIM{% endif %}</h2></div>
  </div>
  <div class="two-grid">
    <article class="article-card" data-aos="fade-up">
      {% if site.lang == 'el' %}
        <h2>Βιοϊατρικές Προσομοιώσεις και Απεικονιστική Τεχνολογία από το 1999</h2>
        <p>Το εργαστήριο BIOSIM υπάγεται στη Σχολή Ηλεκτρολόγων Μηχανικών και Μηχανικών Υπολογιστών και στο ΕΠΙΣΕΥ του Εθνικού Μετσόβιου Πολυτεχνείου.</p>
        <p>Συμμετέχει στη διδασκαλία προπτυχιακών και μεταπτυχιακών μαθημάτων σε μικροκύματα, ιατρική απεικόνιση, βιοϊατρική τεχνολογία, προσομοίωση φυσιολογικών συστημάτων, τεχνολογίες e-Health/m-Health, βιοηλεκτρομαγνητισμό και βιοπληροφορική.</p>
      {% else %}
        <h2>Biomedical Simulations and Imaging since 1999</h2>
        <p>The Biomedical Simulations and Imaging Laboratory is part of the Institute of Communication and Computer Systems and the Faculty of Electrical and Computer Engineering of the National Technical University of Athens.</p>
        <p>The laboratory contributes to undergraduate and postgraduate teaching in microwaves, medical imaging and digital image processing, biomedical engineering laboratory work, simulation of physiological systems, e-Health and m-Health technologies, bioelectromagnetics, and bioinformatics.</p>
      {% endif %}
    </article>
    <article class="article-card" data-aos="fade-up" data-aos-delay="80">
      {% if site.lang == 'el' %}
        <h2>Μέλη, διπλωματικές και ερευνητικά έργα</h2>
        <p>Το BIOSIM συνδυάζει ερευνητική δραστηριότητα, διδασκαλία και συμμετοχή σε χρηματοδοτούμενα έργα στους τομείς της βιοϊατρικής τεχνολογίας και της ψηφιακής υγείας.</p>
        <p>Στον ιστότοπο παρουσιάζονται μέλη, διπλωματικές εργασίες, δημοσιεύσεις και έργα του εργαστηρίου.</p>
      {% else %}
        <h2>People, theses, and funded projects</h2>
        <p>BIOSIM combines research, teaching, and funded project activity across biomedical engineering and digital health.</p>
        <p>The website presents laboratory members, theses, publications, and projects.</p>
      {% endif %}
    </article>
  </div>
</section>

<section class="section">
  <div class="two-grid">
    <article class="article-card" data-aos="fade-up">
      <h2>{% if site.lang == 'el' %}Γραφεία{% else %}Offices{% endif %}</h2>
      {% if site.lang == 'el' %}
        <p><strong>Παλιά Κτίρια Ηλεκτρολόγων Μηχανικών και Μηχανικών Υπολογιστών</strong></p>
        <p>Γραφείο Καθηγήτριας Κωνσταντίνας Νικήτα: Γραφείο 1.1.18<br>Γραφείο Υποψηφίων Διδακτόρων και Μεταδιδακτορικών ερευνητών: Γραφείο 1.1.2<br>Γραφείο Υποψηφίων Διδακτόρων και Μεταδιδακτορικών ερευνητών: Γραφείο 2.1.26</p>
      {% else %}
        <p><strong>Old Buildings of Faculty of Electrical and Computer Engineering</strong></p>
        <p>Professor's Nikita Office: Room 1.1.18<br>PhD & Post Doc Office: Room 1.1.2<br>PhD & Post Doc Office: Room 2.1.26</p>
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
