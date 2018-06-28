import React, { Component } from 'react';
import PropTypes from 'prop-types'
import Toast from '../toast';

export default class Gallery extends Component {

  constructor() {
    super();

    this.state = {
      errors: [],
      isLoaded: false,
      imgs: []
    }
  }

  componentDidMount() {
    fetch(this.props.apiEndpoint)
      .then(function (response) {
        if (response.status >= 200 && response.status < 300) {
          return response.json();
        } else {
          const error = new Error(response.statusText || response.status)
          error.response = response
          return Promise.reject(error)
        }
      })
      .then(json => {
        this.setState({
          imgs: json.map(x => ({
            id: x.id,
            name: x.name,
            thumb: x.images.thumbnail,
            preview: x.images['960']
          })),
          isLoaded: true
        });
      })
      .catch(err => {
        this.setState({
          errors: this.state.errors.concat(err.toString()),
          isLoaded: true
        });
      })
  }

  onSelectImg(i) {
    const selected = this.state.imgs[i];
    this.props.onConfirm(selected.id, selected.preview)
  }

  render() {
    const { errors, isLoaded, imgs } = this.state;
    if (!isLoaded) {
      return (<div>Loading…</div>);
    } else {
      return (
        <div className="imageUpload__gallery">

          { imgs.length > 0 && (
            imgs.map((img, i) => (
              <div
                className="imageUpload__gallery__item"
                key={i}
                onClick={this.onSelectImg.bind(this, i)}>
                <img alt={img.name} src={img.thumb} />
                <span>{img.name}</span>
              </div>
            ))
          )}
          

          { errors.length > 0 && (
            <Toast messages={errors} />
          )}
        </div>
      );
    }
  }

}

Gallery.propTypes = {
  onConfirm: PropTypes.func.isRequired,
  apiEndpoint: PropTypes.string.isRequired
}
