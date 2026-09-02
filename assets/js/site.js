document.addEventListener("DOMContentLoaded", () => {
  const savedTheme = localStorage.getItem("biosim-theme");
  document.documentElement.dataset.theme = savedTheme || "light";

  document.querySelector(".theme-toggle")?.addEventListener("click", () => {
    const next = document.documentElement.dataset.theme === "dark" ? "light" : "dark";
    document.documentElement.dataset.theme = next;
    localStorage.setItem("biosim-theme", next);
  });

  const mobileNavToggle = document.querySelector(".mobile-nav-toggle");
  const mobileNavBackdrop = document.querySelector(".mobile-nav-backdrop");
  const mobileNav = document.querySelector(".site-nav");

  const setMobileNavOpen = (open) => {
    document.body.classList.toggle("nav-open", open);
    mobileNavToggle?.setAttribute("aria-expanded", String(open));
    mobileNavToggle?.setAttribute("aria-label", open ? "Close navigation" : "Open navigation");
  };

  mobileNavToggle?.addEventListener("click", () => setMobileNavOpen(!document.body.classList.contains("nav-open")));
  mobileNavBackdrop?.addEventListener("click", () => setMobileNavOpen(false));
  mobileNav?.querySelectorAll("a").forEach((link) => link.addEventListener("click", () => setMobileNavOpen(false)));
  document.addEventListener("keydown", (event) => {
    if (event.key === "Escape") setMobileNavOpen(false);
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
        pagination: { el: el.querySelector(".swiper-pagination"), clickable: true },
        slidesPerView: 1,
        spaceBetween: 18,
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

  const fitNewsPreviews = () => {
    document.querySelectorAll(".news-card").forEach((card) => {
      const preview = card.querySelector(".news-card-preview");
      if (!preview) return;

      const cardStyle = window.getComputedStyle(card);
      const previewStyle = window.getComputedStyle(preview);
      const fontSize = Number.parseFloat(previewStyle.fontSize) || 16;
      const lineHeight = Number.parseFloat(previewStyle.lineHeight) || fontSize * 1.45;
      const cardInnerHeight = card.clientHeight - Number.parseFloat(cardStyle.paddingTop || 0) - Number.parseFloat(cardStyle.paddingBottom || 0);
      const usedHeight = [...card.children]
        .filter((child) => child !== preview)
        .reduce((total, child) => {
          const style = window.getComputedStyle(child);
          return total + child.offsetHeight + Number.parseFloat(style.marginTop || 0) + Number.parseFloat(style.marginBottom || 0);
        }, 0);
      const availableHeight = Math.max(0, cardInnerHeight - usedHeight - 2);
      const lines = Math.max(1, Math.floor(availableHeight / lineHeight));

      preview.style.setProperty("--preview-lines", lines);
      preview.style.setProperty("--preview-max-height", `${lines * lineHeight}px`);
    });
  };

  fitNewsPreviews();
  window.setTimeout(fitNewsPreviews, 120);
  document.fonts?.ready.then(fitNewsPreviews);

  let newsPreviewResizeTimer = null;
  window.addEventListener("resize", () => {
    window.clearTimeout(newsPreviewResizeTimer);
    newsPreviewResizeTimer = window.setTimeout(fitNewsPreviews, 120);
  });

  if (window.ResizeObserver) {
    const newsPreviewObserver = new ResizeObserver(fitNewsPreviews);
    document.querySelectorAll(".news-card").forEach((card) => newsPreviewObserver.observe(card));
  }

  const publicationFilters = document.querySelector("[data-publication-filters]");
  const publications = document.querySelector(".publications");
  if (publicationFilters && publications) {
    const searchInput = publicationFilters.querySelector("[data-publication-search]");
    const minRange = publicationFilters.querySelector("[data-publication-year-min]");
    const maxRange = publicationFilters.querySelector("[data-publication-year-max]");
    const rangeTrack = publicationFilters.querySelector(".publication-range-inputs");
    const minLabel = publicationFilters.querySelector("[data-publication-min-label]");
    const maxLabel = publicationFilters.querySelector("[data-publication-max-label]");
    const yearButtons = [...publicationFilters.querySelectorAll("[data-publication-year]")];
    const typeButtons = [...publicationFilters.querySelectorAll("[data-publication-type]")];
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
    const years = groups.map((group) => Number(group.year)).filter(Number.isFinite);
    const minYear = Math.min(...years);
    const maxYear = Math.max(...years);

    [minRange, maxRange].forEach((range) => {
      if (!range || !Number.isFinite(minYear) || !Number.isFinite(maxYear)) return;
      range.min = minYear;
      range.max = maxYear;
      range.step = 1;
    });

    if (minRange) minRange.value = minYear;
    if (maxRange) maxRange.value = maxYear;

    const applyPublicationFilters = () => {
      let selectedMin = Number(minRange?.value || minYear);
      let selectedMax = Number(maxRange?.value || maxYear);
      const query = searchInput?.value.trim().toLowerCase() || "";
      const selectedType = publicationFilters.querySelector("[data-publication-type].active")?.dataset.publicationType || "";
      let visibleCount = 0;

      if (selectedMin > selectedMax) {
        [selectedMin, selectedMax] = [selectedMax, selectedMin];
      }

      if (minLabel) minLabel.textContent = selectedMin;
      if (maxLabel) maxLabel.textContent = selectedMax;
      if (rangeTrack) {
        const span = maxYear - minYear || 1;
        rangeTrack.style.setProperty("--range-start", `${((selectedMin - minYear) / span) * 100}%`);
        rangeTrack.style.setProperty("--range-end", `${((selectedMax - minYear) / span) * 100}%`);
      }

      groups.forEach(({ heading, list, entries, year }) => {
        let groupVisible = 0;
        const numericYear = Number(year);

        entries.forEach((entry) => {
          const matchesYear = numericYear >= selectedMin && numericYear <= selectedMax;
          const matchesQuery = !query || entry.dataset.publicationText.includes(query);
          const matchesType = !selectedType || entry.querySelector("[data-publication-type]")?.dataset.publicationType === selectedType;
          const visible = matchesYear && matchesQuery && matchesType;
          entry.hidden = !visible;
          if (visible) groupVisible += 1;
        });

        heading.hidden = groupVisible === 0;
        list.hidden = groupVisible === 0;
        visibleCount += groupVisible;
      });

      yearButtons.forEach((button) => {
        const year = button.dataset.publicationYear;
        const active = year ? selectedMin === Number(year) && selectedMax === Number(year) : selectedMin === minYear && selectedMax === maxYear;
        button.classList.toggle("active", active);
      });

      typeButtons.forEach((button) => {
        const t = button.dataset.publicationType;
        button.classList.toggle("active", selectedType === t);
      });

      if (count) {
        const label = visibleCount === 1 ? count.dataset.singular : count.dataset.plural;
        count.textContent = `${visibleCount} ${label}`;
      }
      if (empty) empty.hidden = visibleCount > 0;
    };

    searchInput?.addEventListener("input", applyPublicationFilters);
    minRange?.addEventListener("input", applyPublicationFilters);
    maxRange?.addEventListener("input", applyPublicationFilters);
    yearButtons.forEach((button) => {
      button.addEventListener("click", () => {
        const year = button.dataset.publicationYear;
        if (minRange) minRange.value = year || minYear;
        if (maxRange) maxRange.value = year || maxYear;
        applyPublicationFilters();
      });
    });

    typeButtons.forEach((button) => {
      button.addEventListener("click", () => {
        typeButtons.forEach((btn) => btn.classList.remove("active"));
        button.classList.add("active");
        applyPublicationFilters();
      });
    });

    applyPublicationFilters();
  }
});
