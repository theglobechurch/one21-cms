import React, { Component } from 'react'
import PropTypes from 'prop-types';
import SVGInline from 'react-svg-inline';
import TextareaExpander from '../../textarea_exander';
import svgRemove from '../../../svg/remove.svg';

export default class SubQuestion extends Component {

  constructor(props) {
    super(props);

    const { subquestion } = this.props;
    this.state = { subquestion }
  }

  componentDidMount() {
    TextareaExpander(document.querySelector('.js-autoexpandable'));
  }

  componentWillReceiveProps(nextProps) {
    if (nextProps.subquestion !== this.state.subquestion) {
      this.setState({ subquestion: nextProps.subquestion });
    }
  }

  subQuestionChange(ev) {
    TextareaExpander(ev.target);
    const subQ = ev.target.value;
    this.setState(
      { subquestion: subQ },
      () => {
        this.props.saveSubQuestion(this.props.id, this.state.subquestion);
      }
    );
  }

  subQuestionRemove(ev) {
    ev.preventDefault();
    this.props.removeSubQuestion(this.props.id);
  }

  render() {
    const {subquestion} = this.state;
    return (
      <div className="form__field">
        <div className="form__input">
          <textarea
            value={subquestion}
            onChange={this.subQuestionChange.bind(this)}
            className="expandableTextArea expandableTextArea--small js-autoexpandable"
          />
        </div>

        <SVGInline
          aria-label="Remove subquestion"
          accessibilityLabel="Remove subquestion"
          onClick={this.subQuestionRemove.bind(this)}
          svg={svgRemove}
          cleanup={true}
          className="questionCreator__removeBtn"
        />
      </div>
    );
  }
}

SubQuestion.propTypes = {
  subquestion: PropTypes.string,
  id: PropTypes.number.isRequired,
  removeSubQuestion: PropTypes.func.isRequired,
  saveSubQuestion: PropTypes.func.isRequired
}
