import React, { Component } from 'react'
import PropTypes from 'prop-types';

export default class SubQuestion extends Component {

  constructor(props) {
    super(props);

    const { subquestion } = this.props;
    this.state = { subquestion }
  }

  componentWillReceiveProps(nextProps) {
    if (nextProps.subquestion !== this.state.subquestion) {
      this.setState({ subquestion: nextProps.subquestion });
    }
  }

  subQuestionChange(ev) {
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
      <div>
        <input
          type="text"
          value={subquestion}
          onChange={this.subQuestionChange.bind(this)}
        />

        <button
          onClick={this.subQuestionRemove.bind(this)}
        >
          Remove subquestion
        </button>
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
