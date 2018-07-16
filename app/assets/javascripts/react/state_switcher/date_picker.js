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
      <div className="dateTimePicker">
        <div>
          <h1 className="r_popup__title">
            Date and Time
          </h1>

          <div className="dateTimePicker__date">
            <input
              type="number"
              className="r_popup__input r_popup__input--number tdateTimePicker__input js-tp-day"
              min="1"
              max="31"
              defaultValue={dtNow.format('D')}
            />

            <select
              className="dateTimePicker__select js-tp-month"
              defaultValue={parseInt(dtNow.format('M'))}
            >
              <option value="1">Jan</option>
              <option value="2">Feb</option>
              <option value="3">Mar</option>
              <option value="4">Apr</option>
              <option value="5">May</option>
              <option value="6">June</option>
              <option value="7">July</option>
              <option value="8">Aug</option>
              <option value="9">Sept</option>
              <option value="10">Oct</option>
              <option value="11">Nov</option>
              <option value="12">Dec</option>
            </select>

            <input
              type="number"
              className="r_popup__input r_popup__input--number dateTimePicker__input js-tp-year"
              min={dtNow.format('YYYY')}
              max={parseInt(dtNow.format('YYYY'))+5}
              defaultValue={dtNow.format('YYYY')}
            />
          </div>

          <div className="dateTimePicker__time">
            <input
              type="number"
              className="r_popup__input r_popup__input--number dateTimePicker__input js-tp-hour"
              min="0"
              max="23"
              defaultValue={dtNow.format('H')}
            />
            :
            <input
              type="number"
              className="r_popup__input r_popup__input--number dateTimePicker__input js-tp-minute"
              min="0"
              max="59"
              defaultValue={dtNow.format('m')}
            />
          </div>
        
        </div>

        <button
          onClick={this.confirm.bind(this)}
          className="btn btn--primary r_popup__actionBtn"
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
