function closestRoot(node) {
  return node.closest('.js-stateSwitcher');
}

export default function stateSelect() {
  const switcher = document.querySelectorAll('.stateSwitcher__current');

  if (switcher.length === 0) { return; }

  switcher.forEach(el => {
    el.addEventListener('click', e => {
      e.preventDefault();
      const { target } = e;
      const closest = closestRoot(target);
      closest.classList.toggle('is-open');
    });
  });

}
