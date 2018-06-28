import React, { Component } from 'react';
import PropTypes from 'prop-types';
import Toast from '../toast';

export default class ImagePreview extends Component {

  constructor() {
    super();

    this.state = {
      imgSrc: "",
      errors: []
    }
  }

  componentDidMount() {
    const reader = new FileReader();
    const url = reader.readAsDataURL(this.props.image);
    reader.onloadend = function (e) {
      this.setState({
        imgSrc: reader.result
      });
    }.bind(this);
  }


  confirmUpload(e) {
    e.preventDefault();

    const imageTitle = document.querySelector('#image_title').value;
    if (imageTitle.length <= 0) {
      this.setState({ errors: ['Image title is required'] });

    } else {
      this.setState({ errors: [] });
      this.props.onConfirm(imageTitle);      
    }

  }

  render() {

    return (
      <div className="imageUpload__preview">
        <div
          className="imageUpload__preview__image"
          style={{ backgroundImage: `url(${this.state.imgSrc})` }}
        >
        </div>

        { this.props.uploadProgress && (
          <div>
            {this.props.uploadProgress}
          </div>
        )}
        
        { !this.props.uploadProgress && (
          <div>
            <div className="form__field">
              <input
                className="form__input"
                type="text"
                id="image_title"
              />
              <label
                className="form__label"
                htmlFor="image_title"
              >
                Title
              </label>
            </div>

            <button
              className="btn"
              onClick={this.confirmUpload.bind(this)}
            >
              Upload
            </button>
          </div>
        )}

        {this.state.errors.length > 0 && (
          <Toast messages={this.state.errors} />
        )}
      </div>
    );
  }
}

ImagePreview.propTypes = {
  onConfirm: PropTypes.func.isRequired,
  image: PropTypes.object.isRequired,
  uploadProgress: PropTypes.string
}
