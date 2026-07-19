(() => {
  const page = document.body.dataset.page;
  if (page) {
    document.querySelectorAll(".nav a[data-page]").forEach((link) => {
      if (link.dataset.page === page) {
        link.setAttribute("aria-current", "page");
      }
    });
  }

  const toggle = document.querySelector(".mobile-nav-toggle");
  if (toggle) {
    toggle.addEventListener("click", () => {
      document.body.classList.toggle("nav-open");
    });
    document.addEventListener("click", (e) => {
      if (
        document.body.classList.contains("nav-open") &&
        !e.target.closest(".nav") &&
        !e.target.closest(".mobile-nav-toggle")
      ) {
        document.body.classList.remove("nav-open");
      }
    });
  }

  const filter = document.querySelector("[data-bind-filter]");
  const rows = document.querySelectorAll("[data-bind-row]");
  if (filter && rows.length) {
    filter.addEventListener("input", () => {
      const q = filter.value.trim().toLowerCase();
      rows.forEach((row) => {
        const hay = row.textContent.toLowerCase();
        row.hidden = q !== "" && !hay.includes(q);
      });
    });
  }
})();
