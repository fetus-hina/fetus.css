"use strict";
(() => {
  // js/back-to-top.ts
  var BackToTop = class {
    setUp() {
      const button = this._createButton();
      document.body.appendChild(button);
      button.addEventListener("click", (ev) => {
        window.scroll({
          top: 0,
          left: 0,
          behavior: "smooth"
        });
        ev.stopImmediatePropagation();
        ev.preventDefault();
      });
      Array.prototype.forEach.call(
        document.getElementsByTagName("footer"),
        (e) => e.classList.add("has-action-button")
      );
      this._updateButtonDisplay(button);
      this._setUpScrollListener(button);
    }
    _createButton() {
      const a = this._createElement("a", {
        "aria-hidden": "true",
        class: "back-to-top-action-button d-none",
        href: "#"
      });
      a.innerHTML = this._svg();
      return a;
    }
    _createElement(tag, options = {}) {
      const e = document.createElement(tag);
      for (const [key, value] of Object.entries(options)) {
        e.setAttribute(key, value);
      }
      return e;
    }
    _svg(size = 24) {
      return `<svg xmlns="http://www.w3.org/2000/svg" width="${size}" height="${size}" fill="currentColor" class="bi bi-chevron-up" viewBox="0 0 16 16"><path fill-rule="evenodd" d="M7.646 4.646a.5.5 0 0 1 .708 0l6 6a.5.5 0 0 1-.708.708L8 5.707l-5.646 5.647a.5.5 0 0 1-.708-.708l6-6z"/></svg>`;
    }
    _setUpScrollListener(button) {
      let timerId = null;
      window.addEventListener("scroll", () => {
        if (timerId !== null) {
          window.clearTimeout(timerId);
          timerId = null;
        }
        timerId = window.setTimeout(
          () => {
            this._updateButtonDisplay(button);
            timerId = null;
          },
          50
        );
      });
    }
    _updateButtonDisplay(button) {
      const beDisplay = window.scrollY > 100;
      const currentDisplay = !button.classList.contains("d-none");
      if (beDisplay !== currentDisplay) {
        if (beDisplay) {
          button.classList.remove("d-none");
        } else {
          button.classList.add("d-none");
        }
      }
    }
  };
  var back_to_top_default = BackToTop;

  // js/ready.ts
  function ready(callback) {
    if (document.readyState === "interactive" || document.readyState === "complete") {
      callback();
      return;
    }
    document.addEventListener("DOMContentLoaded", () => {
      callback();
    });
  }

  // js/index.ts
  /*! @license
   * Copyright (C) 2003, 2020-2026 AIZAWA Hina
   * MIT License
   **/
  window.bootstrap.BackToTop = back_to_top_default;
  ready(() => {
    if (document.body.classList.contains("back-to-top-auto")) {
      document.body.classList.remove("back-to-top-auto");
      new back_to_top_default().setUp();
    }
  });
})();
