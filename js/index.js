/*! @license
 * Copyright (C) 2003, 2020-2024 AIZAWA Hina
 * MIT License
 **/

import 'core-js/stable';
import 'regenerator-runtime/runtime';

import BackToTop from './back-to-top';
import onReady from './ready';

window.bootstrap.BackToTop = BackToTop;
onReady(function () {
  if (document.body.classList.contains('back-to-top-auto')) {
    document.body.classList.remove('back-to-top-auto');
    (new BackToTop()).setUp();
  }
});
