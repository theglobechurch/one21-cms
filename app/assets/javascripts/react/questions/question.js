import React, { Component } from 'react'
import PropTypes from 'prop-types';
import SubQuestion from './subquestion';

export default class Question extends Component {

  constructor(props) {
    super(props);

    const { lead, followup } = this.props.question;
    this.state = { lead, followup };
  }

  componentWillReceiveProps(nextProps) {
    const { lead, followup } = nextProps.question;
    if (lead !== this.state.lead || followup !== this.state.followup) {
      this.setState({ lead, followup });
    }
  }

  questionChange(ev) {
    const q = ev.target.value;
    this.setState(
      { lead: q },
      () => {
        this.store();
      }
    );
  }

  questionRemove(ev) {
    ev.preventDefault();
    this.props.removeQuestion(this.props.id);
  }

  subQuestionCreate(ev) {
    ev.preventDefault();
    
    const followup = this.state.followup;
    followup.push("");
    this.setState({followup});
  }

  subQuestionChange(key, subQ) {
    // Returned from <SubQuestion>
   
    const followup = this.state.followup;
    followup[key] = subQ;
    this.setState(
      { followup },
      () => this.store()
    );
  }

  subQuestionRemove(key) {
    // Returned from <SubQuestion>
    
    const followup = this.state.followup;
    followup.splice(key, 1);
    this.setState(
      { followup },
      () => this.store()
    );
  }

  store () {
    const question = {
      lead: this.state.lead,
      followup: this.state.followup
    }
    this.props.saveQuestion(this.props.id, question);
  }

  render() {
    const {lead, followup} = this.state;
    return (
      <div>
        
        <input
          type="text"
          value={lead}
          onChange={this.questionChange.bind(this)}
        />

        <button
          onClick={this.questionRemove.bind(this)}
        >
          Remove question
        </button>

        { followup.map((subq, i) => (
          <SubQuestion
            key={i}
            id={i}
            subquestion={subq}
            removeSubQuestion={this.subQuestionRemove.bind(this)}
            saveSubQuestion={this.subQuestionChange.bind(this)}
          />
        )) }

        <button
          onClick={this.subQuestionCreate.bind(this)}
        >
          Add new subquestion
        </button>
      </div>
    );
  }
}

Question.propTypes = {
  question: PropTypes.object.isRequired,
  id: PropTypes.number.isRequired,
  removeQuestion: PropTypes.func.isRequired,
  saveQuestion: PropTypes.func.isRequired
}
