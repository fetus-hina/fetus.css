class BackToTop {
  setUp () {
    // ボタン要素の作成
    const button = this._createButton();
    document.body.appendChild(button);
    button.addEventListener('click', function (ev) {
      window.scroll({
        top: 0,
        left: 0,
        behavior: 'smooth'
      });
      ev.stopImmediatePropagation();
      ev.preventDefault();
    });

    // フッターの幅を広げる
    Array.prototype.forEach.call(
      document.getElementsByTagName('footer'),
      e => e.classList.add('has-action-button')
    );

    this._updateButtonDisplay(button); // 初期表示を正しくする
    this._setUpScrollListener(button); // スクロール時の挙動を設定
  }

  _createButton () {
    const a = this._createElement('a', {
      'aria-hidden': 'true',
      class: 'back-to-top-action-button d-none',
      href: '#'
    });
    a.innerHTML = this._svg();
    return a;
  }

  _createElement (tag, options = {}) {
    const e = document.createElement(tag);
    for (const [key, value] of Object.entries(options)) {
      e.setAttribute(key, value);
    }
    return e;
  }

  _svg (size = 24) {
    // Bootstrap-icons chevron-up
    return `<svg xmlns="http://www.w3.org/2000/svg" width="${size}" height="${size}" fill="currentColor" class="bi bi-chevron-up" viewBox="0 0 16 16"><path fill-rule="evenodd" d="M7.646 4.646a.5.5 0 0 1 .708 0l6 6a.5.5 0 0 1-.708.708L8 5.707l-5.646 5.647a.5.5 0 0 1-.708-.708l6-6z"/></svg>`;
  }

  _setUpScrollListener (button) {
    let timerId = null;
    window.addEventListener('scroll', () => {
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

  _updateButtonDisplay (button) {
    const beDisplay = window.scrollY > 100;
    const currentDisplay = !button.classList.contains('d-none');
    if (beDisplay !== currentDisplay) {
      if (beDisplay) {
        button.classList.remove('d-none');
      } else {
        button.classList.add('d-none');
      }
    }
  }
}

export default BackToTop;
