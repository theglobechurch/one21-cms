import PropTypes from 'prop-types'

export default function Toast({
  messages = []
}) {
  return (
    <div className="toast toast--bottom">
      {messages.map((mess, i) => (
        <p key={i}>{mess}</p>
      ))}
    </div>
  );
}

Toast.propTypes = {
  messages: PropTypes.arrayOf(PropTypes.string)
}
