import sortable from '../../../node_modules/html5sortable/dist/html5sortable.es.js'

export default function(selector) {
  const sortableList = document.querySelector(selector);
  if (!sortableList) { return; }

  const studyList = new sortable(sortableList, {
    handle: ".sortable__handle",
    animation: 150,
    dataIdAttr: 'data-id',
    forcePlaceholderSize: true,
    placeholderClass: 'sortable--placeholder',
  });

  studyList[0].addEventListener('sortupdate', function (e) {
    const listItems = document.querySelectorAll('.js-reorderable__item');
    const ids = [...listItems].map(x => x.dataset.id);
    const postLocation = sortableList.dataset.push;

    const data = new FormData();
    data.append('studyIds', JSON.stringify(ids));

    const token = document.querySelector("meta[name='csrf-token']").content;
    const reorderPost = fetch(postLocation, {
      credentials: 'include',
      headers: {
        'X-CSRF-Token': token
      },
      method: 'POST',
      body: data,
      cache: "no-store"
    });

    reorderPost
      .then(res => {
        return res.json();
      })
  });
}
