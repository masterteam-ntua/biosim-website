document.addEventListener("DOMContentLoaded", () => {
  const savedTheme = localStorage.getItem("biosim-theme");
  document.documentElement.dataset.theme = savedTheme || "light";

  document.querySelector(".theme-toggle")?.addEventListener("click", () => {
    const next = document.documentElement.dataset.theme === "dark" ? "light" : "dark";
    document.documentElement.dataset.theme = next;
    localStorage.setItem("biosim-theme", next);
  });

  if (window.matchMedia("(pointer: fine)").matches && !window.matchMedia("(prefers-reduced-motion: reduce)").matches) {
    const root = document.documentElement;
    let rafId = null;

    window.addEventListener("pointermove", (event) => {
      if (rafId) return;
      rafId = window.requestAnimationFrame(() => {
        root.style.setProperty("--mouse-x", `${event.clientX}px`);
        root.style.setProperty("--mouse-y", `${event.clientY}px`);
        root.classList.add("has-pointer-glow");
        rafId = null;
      });
    });
  }

  if (window.AOS) AOS.init({ duration: 650, easing: "ease-out-cubic", once: true, offset: 80 });

  if (window.Typed && document.querySelector(".typed")) {
    new Typed(".typed", {
      strings: ["biosignal intelligence", "computational physiology", "medical device innovation", "digital biomarkers"],
      typeSpeed: 48,
      backSpeed: 24,
      backDelay: 1300,
      loop: true,
    });
  }

  if (window.tsParticles && document.getElementById("tsparticles")) {
    tsParticles.load({
      id: "tsparticles",
      options: {
        background: { color: { value: "transparent" } },
        fpsLimit: 60,
        particles: {
          color: { value: ["#00c8e8", "#28f0f8", "#ffffff"] },
          links: { color: "#00c8e8", distance: 145, enable: true, opacity: 0.18, width: 1 },
          move: { enable: true, speed: 0.65 },
          number: { value: 58, density: { enable: true, area: 900 } },
          opacity: { value: 0.3 },
          size: { value: { min: 1, max: 3 } },
        },
      },
    });
  }

  if (window.Swiper) {
    document.querySelectorAll(".hero-swiper").forEach((el) => {
      new Swiper(el, {
        autoplay: { delay: 4200, disableOnInteraction: false },
        effect: "fade",
        loop: true,
        pagination: { el: el.querySelector(".swiper-pagination"), clickable: true },
        slidesPerView: 1,
        speed: 900,
      });
    });

    document.querySelectorAll(".news-swiper").forEach((el) => {
      new Swiper(el, {
        grid: { rows: 2, fill: "row" },
        pagination: { el: el.querySelector(".swiper-pagination"), clickable: true },
        slidesPerGroup: 2,
        slidesPerView: 1,
        spaceBetween: 18,
        breakpoints: {
          760: { slidesPerGroup: 4, slidesPerView: 2 },
          1080: { slidesPerGroup: 6, slidesPerView: 3 },
        },
      });
    });

    document.querySelectorAll(".swiper:not(.hero-swiper):not(.news-swiper)").forEach((el) => {
      new Swiper(el, {
        slidesPerView: 1,
        spaceBetween: 18,
        pagination: { el: el.querySelector(".swiper-pagination"), clickable: true },
        breakpoints: { 760: { slidesPerView: 2 }, 1080: { slidesPerView: 3 } },
      });
    });
  }

  if (window.countUp && window.countUp.CountUp) {
    document.querySelectorAll("[data-count]").forEach((el) => {
      const counter = new countUp.CountUp(el, Number(el.dataset.count), { duration: 2.1 });
      if (!counter.error) counter.start();
    });
  }

  if (window.GLightbox) GLightbox({ selector: ".glightbox" });

  const publicationFilters = document.querySelector("[data-publication-filters]");
  const publications = document.querySelector(".publications");
  if (publicationFilters && publications) {
    const searchInput = publicationFilters.querySelector("[data-publication-search]");
    const yearSelect = publicationFilters.querySelector("[data-publication-year-select]");
    const yearButtons = [...publicationFilters.querySelectorAll("[data-publication-year]")];
    const count = publicationFilters.querySelector("[data-publication-count]");
    const empty = publications.querySelector("[data-publication-empty]");
    const groups = [...publications.querySelectorAll("h2.bibliography")]
      .map((heading) => {
        const list = heading.nextElementSibling?.matches("ol.bibliography") ? heading.nextElementSibling : null;
        const entries = list ? [...list.querySelectorAll("li")] : [];
        const year = heading.textContent.trim();

        entries.forEach((entry) => {
          entry.dataset.publicationYear = year;
          entry.dataset.publicationText = entry.textContent.toLowerCase();
        });

        return { heading, list, entries, year };
      })
      .filter((group) => group.list);

    groups.forEach(({ year }) => {
      if (!yearSelect || yearSelect.querySelector(`option[value="${year}"]`)) return;
      const option = document.createElement("option");
      option.value = year;
      option.textContent = year;
      yearSelect.append(option);
    });

    const applyPublicationFilters = () => {
      const selectedYear = yearSelect?.value || "";
      const query = searchInput?.value.trim().toLowerCase() || "";
      let visibleCount = 0;

      groups.forEach(({ heading, list, entries, year }) => {
        let groupVisible = 0;

        entries.forEach((entry) => {
          const matchesYear = !selectedYear || year === selectedYear;
          const matchesQuery = !query || entry.dataset.publicationText.includes(query);
          const visible = matchesYear && matchesQuery;
          entry.hidden = !visible;
          if (visible) groupVisible += 1;
        });

        heading.hidden = groupVisible === 0;
        list.hidden = groupVisible === 0;
        visibleCount += groupVisible;
      });

      yearButtons.forEach((button) => button.classList.toggle("active", button.dataset.publicationYear === selectedYear));
      if (count) count.textContent = `${visibleCount} publication${visibleCount === 1 ? "" : "s"}`;
      if (empty) empty.hidden = visibleCount > 0;
    };

    searchInput?.addEventListener("input", applyPublicationFilters);
    yearSelect?.addEventListener("change", applyPublicationFilters);
    yearButtons.forEach((button) => {
      button.addEventListener("click", () => {
        if (yearSelect) yearSelect.value = button.dataset.publicationYear;
        applyPublicationFilters();
      });
    });

    applyPublicationFilters();
  }
});
