export default function ready (callback) {
  if (
    document.readyState === 'interactive' ||
    document.readyState === 'complete'
  ) {
    callback();
    return;
  }

  document.addEventListener('DOMContentLoaded', () => {
    callback();
  });
}
