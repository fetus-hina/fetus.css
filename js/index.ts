/*! @license
 * Copyright (C) 2003, 2020-2026 AIZAWA Hina
 * MIT License
 **/

import BackToTop from './back-to-top';
import onReady from './ready';

declare global {
  interface Window {
    bootstrap: Record<string, unknown> & {
      BackToTop?: typeof BackToTop;
    };
  }
}

window.bootstrap.BackToTop = BackToTop;
onReady(() => {
  if (document.body.classList.contains('back-to-top-auto')) {
    document.body.classList.remove('back-to-top-auto');
    (new BackToTop()).setUp();
  }
});
