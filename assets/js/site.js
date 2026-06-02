document.addEventListener("DOMContentLoaded", () => {
  const savedTheme = localStorage.getItem("biosim-theme");
  document.documentElement.dataset.theme = savedTheme || "light";

  document.querySelector(".theme-toggle")?.addEventListener("click", () => {
    const next = document.documentElement.dataset.theme === "dark" ? "light" : "dark";
    document.documentElement.dataset.theme = next;
    localStorage.setItem("biosim-theme", next);
  });

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
          color: { value: ["#1a73e8", "#00b4d8", "#ffffff"] },
          links: { color: "#00b4d8", distance: 145, enable: true, opacity: 0.18, width: 1 },
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
});
