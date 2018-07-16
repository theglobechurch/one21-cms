import renderScripturePicker from './react/scripture_picker';
import renderOne21QuestionForm from './react/questions';
import renderImageUploader from './react/image_uploader';
import renderSortable from './sorter';
import renderStateSwitcher from './react/state_switcher';
import textareaExpander from './textarea_exander';

renderScripturePicker('.js-scripturePicker');
renderOne21QuestionForm('.js-one21QuestionForm');
renderImageUploader('.js-imageUploader');
renderSortable('.js-sortable');
renderStateSwitcher('.js-stateSwitcher');

const expandableTA = document.querySelectorAll('.js-expandableTextArea');
if (expandableTA.length >= 1) {
  for (let i = 0; i < expandableTA.length; i++) {
    if (expandableTA[i].tagName.toLowerCase() !== 'textarea') { continue; }
    
    textareaExpander(expandableTA[i]);

    expandableTA[i].addEventListener(
      'keydown',
      () => { textareaExpander(expandableTA[i]) },
      false
    );
  }
}
