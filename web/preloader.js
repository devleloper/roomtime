// Dark preloader for index.html, kept out of the page so the edge CSP
// (script-src 'self', no 'unsafe-inline') allows it.
(function () {
  var el = document.getElementById('preloader');
  if (!el) return;
  // The page language is not known before Flutter starts: name the
  // spinner in the browser language (en and ru are shipped).
  var lang = (navigator.language || 'en').toLowerCase();
  if (lang.indexOf('ru') === 0) el.setAttribute('aria-label', 'Загрузка RoomTime');
  // Removed once Flutter has drawn its first frame.
  window.addEventListener('flutter-first-frame', function () {
    el.remove();
  });
})();
