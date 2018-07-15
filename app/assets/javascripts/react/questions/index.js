import React, { Component } from 'react';
import ReactDOM from 'react-dom';
import PropTypes from 'prop-types';
import Question from './question';

const questionTemplate = {
  "type": "question",
  "lead": "",
  "followup": [""]
}

class One21Questions extends Component {

  constructor(props) {
    super(props);

    let q;
    const qClone = JSON.parse(JSON.stringify(questionTemplate));

    if (props.questionJSON.length === 0) { q = [qClone] }
    else                                 { q = props.questionJSON; }

    this.state = { questions: q }
  }

  createQuestion(ev) {
    ev.preventDefault();

    const questions = this.state.questions;
    const qClone = JSON.parse(JSON.stringify(questionTemplate));
    questions.push(qClone);
    this.setState({questions});
  }

  removeQuestion(key) {
    // Returned from <Question>
    const questions = this.state.questions;
    questions.splice(key, 1);
    this.setState(
      {questions},
      () => {
        this.store();
      }
    );
  }

  saveQuestion(key, q) {
    // Returned from <Question>
    const questions = this.state.questions;
    const updatedQuestions = Object.assign({}, questions[key], q);

    questions[key] = updatedQuestions;

    this.setState(
      {questions},
      () => {
        this.store();
      }
    );
  }

  store() {
    const { questions } = this.state;
    
    questions.forEach((q, i) => {
      q.followup.forEach((fu, i) => {
        if (!fu) { q.followup.splice(i, 1); }
      });

      if (!q.lead) {
        delete questions[i];
      }
    });

    this.props.onConfirm(questions);
  }

  render() {
    return (
      <div className="questionCreator">

        { this.state.questions.map((q, i) => (
          <Question
            key={i}
            id={i}
            question={q}
            removeQuestion={this.removeQuestion.bind(this)}
            saveQuestion={this.saveQuestion.bind(this)}
          />
        ))}
        

        <button
          className="btn questionCreator__btnQuestion"
          onClick={this.createQuestion.bind(this)}
        >
          Add question
        </button>
      </div>
    );
  }

}

One21Questions.propTypes = {
  questionJSON: PropTypes.array,
  onConfirm: PropTypes.func.isRequired
}

export default function(selector) {
  const container = document.querySelector(selector);
  if (!container) { return; }

  function callback(questionJSON) {
    const field = document.getElementById(container.dataset.inputid);
    field.value = JSON.stringify(questionJSON);
  }

  let questionJSON = container.dataset.questionsjson;
  try         { questionJSON = JSON.parse(questionJSON); }
  catch (err) { questionJSON = []; }

  ReactDOM.render(
    <One21Questions
      questionJSON={questionJSON}
      onConfirm={callback}
    />
  , container);


}
