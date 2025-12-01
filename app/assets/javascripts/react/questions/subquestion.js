import { useState, useEffect, useRef } from 'react';
import PropTypes from 'prop-types';
import { ReactSVG } from 'react-svg';
import TextareaExpander from '../../textarea_exander';
import svgRemove from '../../../svg/remove.svg';

export default function SubQuestion({
  subquestion: initialSubquestion,
  id,
  removeSubQuestion,
  saveSubQuestion
}) {
  const [subquestion, setSubquestion] = useState(initialSubquestion);
  const textareaRef = useRef(null);

  useEffect(() => {
    if (textareaRef.current) {
      TextareaExpander(textareaRef.current);
    }
  }, []);

  useEffect(() => {
    if (initialSubquestion !== subquestion) {
      setSubquestion(initialSubquestion);
    }
  }, [initialSubquestion]);

  const subQuestionChange = (ev) => {
    TextareaExpander(ev.target);
    const subQ = ev.target.value;
    setSubquestion(subQ);
    saveSubQuestion(id, subQ);
  };

  const subQuestionRemove = (ev) => {
    ev.preventDefault();
    removeSubQuestion(id);
  };

  return (
    <div className="form__field">
      <div className="form__input">
        <textarea
          ref={textareaRef}
          value={subquestion}
          onChange={subQuestionChange}
          className="expandableTextArea expandableTextArea--small js-autoexpandable"
        />
      </div>

      <ReactSVG
        aria-label="Remove subquestion"
        onClick={subQuestionRemove}
        src={svgRemove}
        className="questionCreator__removeBtn"
      />
    </div>
  );
}

SubQuestion.propTypes = {
  subquestion: PropTypes.string,
  id: PropTypes.number.isRequired,
  removeSubQuestion: PropTypes.func.isRequired,
  saveSubQuestion: PropTypes.func.isRequired
}
