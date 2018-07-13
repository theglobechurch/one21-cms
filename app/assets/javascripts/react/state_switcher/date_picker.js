import React, { Component } from 'react';
import PropTypes from 'prop-types';
import moment from 'moment-es6';
import Toast from '../toast';

export default class DatePicker extends Component {

  constructor() {
    super();

    this.state = {
      msg: []
    }
  }

  confirm(e) {
    e.preventDefault();
    this.setState({ msg: [] });

    // Get all the values from inputs
    const dtIn = {
      ye: document.querySelector('.js-tp-year').value,
      mo: document.querySelector('.js-tp-month').value,
      da: document.querySelector('.js-tp-day').value,
      ho: document.querySelector('.js-tp-hour').value,
      mi: document.querySelector('.js-tp-minute').value
    };

    // Turn into a date
    const dtParsed = moment(`${dtIn.ye}-${dtIn.mo}-${dtIn.da} ${dtIn.ho}:${dtIn.mi}`, "YYYY-MM-DD H:m")
    
    // Validate it
    if (dtParsed.isValid()) {
      // Send it
      this.props.callback(dtParsed.toISOString());
    } else {
      this.setState({ msg: ['Input date invalid'] });
    }
  }

  render () {
    const dtNow = moment();
    return (
      <div className="">
        <input
          type="number"
          className="timePicker__input js-tp-day"
          min="1"
          max="31"
          defaultValue={dtNow.format('D')}
        />

        <select
          className="timePicker__select js-tp-month"
          defaultValue={parseInt(dtNow.format('M'))}
        >
          <option value="1">January</option>
          <option value="2">February</option>
          <option value="3">March</option>
          <option value="4">April</option>
          <option value="5">May</option>
          <option value="6">June</option>
          <option value="7">July</option>
          <option value="8">August</option>
          <option value="9">September</option>
          <option value="10">October</option>
          <option value="11">November</option>
          <option value="12">December</option>
        </select>

        <input
          type="number"
          className="timePicker__input js-tp-year"
          min={dtNow.format('YYYY')}
          max={parseInt(dtNow.format('YYYY'))+5}
          defaultValue={dtNow.format('YYYY')}
        />

        <input
          type="number"
          className="timePicker__input js-tp-hour"
          min="0"
          max="23"
          defaultValue={dtNow.format('H')}
        />

        <input
          type="number"
          className="timePicker__input js-tp-minute"
          min="0"
          max="59"
          defaultValue={dtNow.format('m')}
        />

        <button
          onClick={this.confirm.bind(this)}
          className="btn btn--primary"
        >
          {this.props.action}
        </button>

        {this.state.msg.length > 0 && (
          <Toast messages={this.state.msg} />
        )}
      </div>
    );
  }
}

DatePicker.propTypes = {
  callback: PropTypes.func.isRequired,
  action: PropTypes.string
}

DatePicker.defaultProps = {
  action: "Confirm"
}
