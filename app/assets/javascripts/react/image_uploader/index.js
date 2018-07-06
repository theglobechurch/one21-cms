import React, { Component } from 'react';
import ReactDOM from 'react-dom';
import ReactCSSTransitionGroup from 'react-addons-css-transition-group';
import PropTypes from 'prop-types'
import ImagePreview from './image_preview';
import Gallery from './gallery';
import Toast from '../toast';

class ImageUploader extends Component {

  constructor(props) {
    super(props);
    this.dragCounter = 0;
    this.uploadingImage = null;

    const p = props.previewURL || null;

    this.state = {
      errors: [],
      popup: null,
      uploadProgress: null,
      previewURL: p
    }
  }

  handleDragEnter(e) {
    if (this.dragCounter == 0) {
      e.target.classList.add('is-hovering');
      e.target.style.backgroundImage = null;
      this.setState({
        errors: [],
        status: undefined
      });
    }
    this.dragCounter++;
  }

  handleDragExit(e) {
    this.dragCounter--;
    if (this.dragCounter == 0) {
      e.target.classList.remove('is-hovering');
    }
  }

  handleDragOver(e) {
    e.preventDefault();
    e.stopPropagation();
  }

  handleDrop(e) {
    e.stopPropagation();
    e.preventDefault();

    const target = e.target;
    let f = undefined;

    this.dragCounter = 0;
    e.target.classList.remove('is-hovering');

    if (e.dataTransfer !== undefined) { f = e.dataTransfer.files[0]; }
    if (target.files !== undefined)   { f = target.files[0]; }
    if (f === undefined)              { return; }

    function validateType(f, validTypes) {
      return new Promise((resolve, reject) => {
        if (!f.type.match(`(?:${validTypes})`)) {
          reject(`File uploaded must be one of [${validTypes.replace('|', ', ')}] but was ${f.type}`)
        } else {
          resolve(true);
        }
      });
    }

    function validateImagePxSize(image) {
      return new Promise((resolve, reject) => {
        const preview = new FileReader();
        preview.readAsDataURL(image);

        preview.onload = function (pr) {
          const dimension_test = new Image();
          dimension_test.src = pr.target.result;

          dimension_test.onload = function () {
            if (this.width < 1024 || this.height < 768) {
              reject(`Image must be bigger than 1024x768px, but instead was ${this.width}x${this.height}px.`)
            } else {
              resolve(true);
            }
          };
        }
      });
    }

    validateType(f, this.props.validTypes)
      .then(res => {
        // If we're sending up an image, make sure it is a valid size
        if (this.props.validTypes.indexOf('image') !== -1) {
          return validateImagePxSize(f);
        }
      })
      .then(res => {
        this.uploadingImage = f;
        this.setState({ popup: 'upload' });
      })
      .catch(error => {
        this.setState({
          errors: this.state.errors.concat(error)
        });
      });


  }

  confirmUpload(title) {

    // Update state with upload progress
    this.setState({ uploadProgress: "Uploading and processing…" });

    const data = new FormData();
    const uid = ['fileupload', (new Date()).getTime(), 'raw'].join('-');

    data.append('upload_type', this.props.uploadType);
    data.append('attachment[file]', this.uploadingImage);
    data.append('attachment[name]', this.uploadingImage.name);
    data.append('attachment[uid]', uid);
    data.append('attachment[graphic_name]', title);

    const graphicUpload = fetch("/graphics", {
      credentials: 'include',
      method: 'POST',
      body: data,
      cache: "no-store"
    });

    graphicUpload
      .then(res => {
        if (res.status > 300) {
          return res.json()
            .then(json => {
              const err = new Error(json[0]);
              err.res = res;
              throw err;
            });
        }

        return res.json();
      })
      .then(json => {
        const file_id = json['id'];

        // Set field value to image
        this.props.onConfirm(file_id);

        // Clear any settings
        this.uploadingImage = null;
        this.setState({
          uploadProgress: 'Complete',
          errors: [],
          popup: null,
          previewURL: json['images']['960']
        });

      })
      .catch(err => {
        this.setState({
          errors: this.state.errors.concat(err.message),
          uploadProgress: 'Upload failed'
        });
      });
  }

  confirmGallerySelection(id, preview) {
    this.setState({
      uploadProgress: 'Complete',
      errors: [],
      popup: null,
      previewURL: preview
    });

    this.props.onConfirm(id);
  }

  clearSelectedImage() {
    this.setState({
      errors: ["Image cleared"],
      popup: null,
      previewURL: null
    });
    this.props.onConfirm(null);
  }

  selectExisting(e) {
    e.preventDefault();
    this.setState({ popup: 'gallery' });
  }

  onClosePopup(e) {
    if (e) { e.preventDefault(); }
    this.setState({ popup: null });
  }

  render() {

    return (
      <div className="imageUpload">

        <ReactCSSTransitionGroup
          transitionName="r_popupFade"
          transitionEnterTimeout={250}
          transitionLeaveTimeout={250}>
          { this.state.popup && (
            <div className="r_popup">

              { this.state.popup === 'upload' && (

                <ImagePreview
                  onConfirm={this.confirmUpload.bind(this)}
                  image={this.uploadingImage}
                  uploadProgress={this.state.uploadProgress}
                />

              )}

              { this.state.popup === 'gallery' && (
                <Gallery
                  onConfirm={this.confirmGallerySelection.bind(this)}
                  apiEndpoint={this.props.churchGraphicEndpoint}
                />
              )}

              <button
                className="r_popup__btn--close"
                onClick={this.onClosePopup.bind(this)}
                >
                Cancel
              </button>

            </div>
          )}
        </ReactCSSTransitionGroup>

        <div className="form__field">

          <div
            className="imageUpload__dropzone form__input"
            onDragEnter={this.handleDragEnter.bind(this)}
            onDragLeave={this.handleDragExit.bind(this)}
            onDragOver={this.handleDragOver.bind(this)}
            onDrop={this.handleDrop.bind(this)}
          >

            { this.state.previewURL && (
              <img
                alt=""
                className="imageUpload__imagePreview"
                src={this.state.previewURL} 
              />
            )}

            <input
              className="imageUpload__uploadField"
              id='dropzone-file-field'
              onChange={this.handleDrop.bind(this)}
              type="file"
            />

            { this.props.churchGraphicEndpoint && (
              <span>
                <button
                  className="btn"
                  onClick={this.selectExisting.bind(this)}
                >
                  Select existing lead image
                </button>
                <span className="imageUpload__btn_pad">or</span>
              </span>
            )}

            <label
              htmlFor="dropzone-file-field"
              className="btn"
            >
              Upload
            </label>

            <label
              className="btn"
              onClick={this.clearSelectedImage.bind(this)}
            >
              Clear selected
            </label>

          </div>

          <label className="form__label">
            { this.props.fieldLabel }
          </label>

        </div>

        {this.state.errors.length > 0 && (
          <Toast messages={this.state.errors} />
        )}
      </div>
    );
  }
}

ImageUploader.defaultProps = {
  validTypes: 'image.jpg|image.jpeg|image.png',
  fieldLabel: 'Lead image'
}

ImageUploader.propTypes = {
  previewURL: PropTypes.string,
  onConfirm: PropTypes.func.isRequired,
  validTypes: PropTypes.string,
  fieldLabel: PropTypes.string,
  churchGraphicEndpoint: PropTypes.string
}

export default function(selector) {
  const container = document.querySelector(selector);
  if (!container) { return; }
  
  function callback(imageRef) {
    const field = document.getElementById(container.dataset.inputid);
    field.value = imageRef;
  }

  ReactDOM.render(
    <ImageUploader
      previewURL={container.dataset.previewurl}
      fieldLabel={container.dataset.fieldlabel}
      churchGraphicEndpoint={container.dataset.churchgraphicendpoint}
      onConfirm={callback}
    />
  , container);
}
