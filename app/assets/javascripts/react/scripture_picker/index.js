import React, { Component } from "react";
import ReactDOM from "react-dom";
import ReactCSSTransitionGroup from "react-addons-css-transition-group";
import PropTypes from "prop-types";
import Picker from "./picker";

class ScripturePicker extends Component {
  constructor(props) {
    super(props);

    let t = [];
    if (props.refText !== "") {
      t = props.refText.split(",");
    }

    this.state = {
      popupOpen: false,
      refJson: props.refJson,
      refText: t
    };
  }

  onTogglePopup(event) {
    if (event) {
      event.preventDefault();
    }
    this.setState({ popupOpen: !this.state.popupOpen });
  }

  onPassageSelect(newRefText, newRefJson) {
    const { refText, refJson } = this.state;
    refText.push(newRefText);
    refJson.push(newRefJson);

    this.setState({
      refText,
      refJson
    });
  }

  onConfirm(event) {
    event.preventDefault();
    const { refJson } = this.state;
    this.props.onConfirm(refJson);
    this.onTogglePopup();
  }

  render() {
    return (
      <div className="scripturePicker">
        <div
          className="scripturePicker__preview"
          onClick={this.onTogglePopup.bind(this)}
        >
          {this.state.refText.join(", ")}
        </div>

        <ReactCSSTransitionGroup
          transitionName="r_popupFade"
          transitionEnterTimeout={250}
          transitionLeaveTimeout={250}
        >
          {this.state.popupOpen && (
            <div className="r_popup">
              <Picker onConfirm={this.onPassageSelect.bind(this)} />

              {this.state.refText.length > 0 && (
                <ul>
                  {this.state.refText.map((ref, i) => <li key={i}>{ref}</li>)}
                </ul>
              )}

              {this.state.refText.length > 0 && (
                <button
                  onClick={this.onConfirm.bind(this)}
                  className="btn btn--primary r_popup__actionBtn"
                >
                  Confirm
                </button>
              )}

              <button
                className="r_popup__btn--close"
                onClick={this.onTogglePopup.bind(this)}
              >
                Cancel
              </button>
            </div>
          )}
        </ReactCSSTransitionGroup>
      </div>
    );
  }
}

ScripturePicker.propTypes = {
  refJson: PropTypes.array,
  refText: PropTypes.string,
  onConfirm: PropTypes.func.isRequired
};

export default function(selector) {
  const container = document.querySelector(selector);

  if (!container) {
    return;
  }

  function callback(refJSON) {
    // Temp hack… go back to edit to allow multiple passages
    const field = document.getElementById(container.dataset.inputid);
    field.value = JSON.stringify(refJSON);
  }

  let refJson = container.dataset.refjson;
  try {
    refJson = JSON.parse(refJson);
  } catch (err) {
    refJson = [];
  }

  ReactDOM.render(
    <ScripturePicker
      refJson={refJson}
      refText={container.dataset.reftext}
      onConfirm={callback}
    />,
    container
  );
}
