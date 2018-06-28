import React, { Component } from 'react';
import PropTypes from 'prop-types'

export default class Toast extends Component {

  render () {
    const messages = (this.props.messages || []).map(
      (mess, i) => (
        <p key={i}>{mess}</p>
      )
    );

    return (
      <div className="toast toast--bottom">
        {messages}
      </div>
    );
  }

}

Toast.defaultProps = {
  messages: []
}

Toast.propTypes = {
  messages: PropTypes.array
}
