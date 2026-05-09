export default function ready (callback: () => void): void {
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
