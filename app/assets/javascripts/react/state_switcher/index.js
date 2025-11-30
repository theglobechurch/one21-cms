import React, {Component} from 'react';
import ReactDOM from 'react-dom';
import { TransitionGroup, CSSTransition } from 'react-transition-group';
import PropTypes from 'prop-types'
import DatePicker from './date_picker';


class StateSwitcher extends Component {

  constructor(props) {
    super(props);

    this.state = {
      status: props.currentState,
      popup: false,
      open: false
    }
  }

  componentDidMount() {
    document.addEventListener('mousedown', this.handleClick, false);
  }

  componentWillUnmount() {
    document.removeEventListener('mousedown', this.handleClick, false);
  }

  handleClick = (e) => {
    if (this.node.contains(e.target)) {
      return;
    }

    this.setState({open: false});
  }

  onClosePopup() {
    this.setState({ popup: false });
  }

  onSchedule() {
    this.setState({ popup: true });
  }

  confirmSchedule(dt) {
    this.onChangeState('published', dt);
    this.setState({ popup: false });
  }

  onToggleOptions(ev) {
    ev.preventDefault();
    this.setState({ open: !this.state.open })
  }

  onChangeState(status, dt=null, ev) {
    if (ev) { ev.preventDefault(); }

    const data = new FormData();
    const token = document.querySelector("meta[name='csrf-token']").content;

    data.append('_method', 'patch');
    data.append(`${this.props.model}[status]`, status);

    if (dt !== null) {
      data.append(`${this.props.model}[published_at]`, dt);
    }

    const reorderPost = fetch(this.props.postUrl, {
      credentials: 'include',
      headers: {
        'X-CSRF-Token': token,
        'TriggeredBy': 'stateSwitcher'
      },
      method: 'POST',
      body: data,
      cache: "no-store"
    });

    reorderPost
      .then(res => {
        return res.json();
      })
      .then(json => {
        this.setState({
          status: json.new_status,
          open: false
        })
      });
  }

  render() {
    return (
      <div className="stateSwitcher" ref={ node => this.node = node }>

        <div className="stateSwitcher__dropdown">
          <div
            className="stateSwitcher__dropdown__current"
            onClick={this.onToggleOptions.bind(this)}
          >
            { this.state.status }
          </div>

          { this.state.open === true && (

            <div className="stateSwitcher__dropdown__options">

              { this.state.status !== 'published' && (
                <button onClick={this.onChangeState.bind(this, 'published', null)}>
                  Publish
                </button>
              )}

              { this.state.status !== 'draft' && (
                <button onClick={this.onChangeState.bind(this, 'draft', null)}>
                  Unpublish
                </button>
              )}

              { this.props.schedulable && (
                <button onClick={this.onSchedule.bind(this)}>
                  Schedule
                </button>
              )}

              {this.state.status !== 'deleted' && (
                <button onClick={this.onChangeState.bind(this, 'deleted', null)}>
                  Delete
                </button>
              )}
            </div>
          )}

        </div>

        <TransitionGroup>
          { this.state.popup && (
            <CSSTransition
              classNames="r_popupFade"
              timeout={250}
            >
              <div className="r_popup">
                <DatePicker
                  action="Schedule"
                  callback={this.confirmSchedule.bind(this)}
                />

                <button
                  className="r_popup__btn--close"
                  onClick={this.onClosePopup.bind(this)}
                >
                  Cancel
                </button>
              </div>
            </CSSTransition>
          )}
        </TransitionGroup>
      </div>
    )
  }
}

StateSwitcher.propTypes = {
  postUrl: PropTypes.string.isRequired,
  currentState: PropTypes.string,
  schedulable: PropTypes.bool
}

StateSwitcher.defaultProps = {
  currentState: 'Draft',
  schedulable: false
}

export default function (selector) {
  const containers = document.querySelectorAll(selector);
  if (containers.length <= 0) { return; }

  for (let i = 0; i < containers.length; i++) {
    ReactDOM.render(
      <StateSwitcher
        {...containers[i].dataset}
        schedulable={(containers[i].dataset.schedulable == 'true')}
      />
    , containers[i]);
  }
}
