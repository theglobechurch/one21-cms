import React, { Component } from 'react'
import ReactDOM from 'react-dom';
import ReactCSSTransitionGroup from 'react-addons-css-transition-group';
import PropTypes from 'prop-types';
import books from './books.json';

class ScripturePicker extends Component {

  constructor(props) {
    super(props);
    this.state = {
      popupOpen: false,
      refJson: props.refJson[0],
      refText: props.refText,
      selectedBookData: null,
      suggestBooks: []
    }
  }

  onTogglePopup(event) {
    if (event) { event.preventDefault(); }
    this.setState({ popupOpen: !this.state.popupOpen });
  }

  onSaveReference(event) {
    event.preventDefault();

    // produce JSON and Text
    const refJson = {
      "reference_book": document.querySelector('.js-sp-book-name').value,
      "reference_book_start_ch": document.querySelector('.js-sp-start-ch').value,
      "reference_book_start_v": document.querySelector('.js-sp-start-v').value,
      "reference_book_end_ch": document.querySelector('.js-sp-end-ch').value,
      "reference_book_end_v": document.querySelector('.js-sp-end-v').value
    }

    const refText = refJson.reference_book
      + " "
      + refJson.reference_book_start_ch
      + ":"
      + refJson.reference_book_start_v
      + "–"
      + refJson.reference_book_end_ch
      + ":"
      + refJson.reference_book_end_v;

    this.setState({ refJson, refText });
    
    // Send it back and close the popup
    this.props.onConfirm(refJson, refText);
    this.onTogglePopup();
  }

  onBookLookup(event) {
    const bookEntry = event.target.value;
    const refJson = this.state.refJson;
    const suggestedBooks = books.filter(
      book => book.fullName.toLowerCase().includes(
        bookEntry.toLowerCase()
      )
    );

    if (suggestedBooks.length === 0) {
      event.target.value = event.target.value.slice(0, -1);
    }

    if (suggestedBooks.length > 5) {
      suggestedBooks.length = 5;
    }

    this.setState({ suggestedBooks });
  }

  onSelectBook(selectedBook) {
    const refJson = this.state.refJson;
    const fieldBookName = document.querySelector('.js-sp-book-name');
    const fieldStartChapter = document.querySelector('.js-sp-start-ch');
    const fieldEndChapter = document.querySelector('.js-sp-end-ch');
    const selectedBookData = books.filter(
      book => book.fullName.toLowerCase().includes(
        selectedBook.fullName.toLowerCase()
      )
    )[0];

    fieldBookName.value = selectedBook.fullName;
    fieldStartChapter.max = selectedBook.chapters.length
    fieldEndChapter.max = selectedBook.chapters.length

    refJson.reference_book = selectedBook.fullName;

    this.setState({ suggestedBooks: [], refJson, selectedBookData });
  }

  onSelectStartChapter(event) {
    const selectedChapter = event.target.value;
    const refJson = this.state.refJson;
    const fieldStartVerse = document.querySelector('.js-sp-start-v');
    const fieldEndChapter = document.querySelector('.js-sp-end-ch');
    const fieldEndVerse = document.querySelector('.js-sp-end-v');

    // Don't allow text entry above the max…
    if (selectedChapter > this.state.selectedBookData.chapters.length) {
      event.target.value = event.target.value.slice(0, -1);
      return;
    }

    fieldEndChapter.min = selectedChapter;
    if (fieldEndChapter.value < selectedChapter) {
      fieldEndChapter.value = selectedChapter;
    }

    // Arrays are 0 indexed
    const chapterArrRef = selectedChapter - 1;
    const verseCount = this.state.selectedBookData.chapters[chapterArrRef];

    fieldStartVerse.max = verseCount
    if (fieldStartVerse.value > verseCount) {
      fieldStartVerse.value = verseCount
    }

    fieldEndVerse.max = verseCount;
    if (fieldEndVerse.value > verseCount) {
      fieldEndVerse.value = verseCount
    }

    refJson.reference_book_start_ch = selectedChapter;
    this.setState(refJson);
  }

  render() {
    return (
      <div className="scripturePicker">
        <div
          className="scripturePicker__preview"
          onClick={this.onTogglePopup.bind(this)}
        >
          {this.state.refText}
        </div>

        <ReactCSSTransitionGroup
          transitionName="scripturePickerFade"
          transitionEnterTimeout={250}
          transitionLeaveTimeout={250}>
          { this.state.popupOpen &&
            <div className="scripturePicker__popup">

              Bible reference:

              <div>
                <input
                  type="text"
                  className="js-sp-book-name"
                  autoFocus
                  onKeyDown={this.onBookLookup.bind(this)}
                  defaultValue={this.state.refJson.reference_book}
                />
              </div>

              { this.state.suggestedBooks &&
                <div>
                  <ul>
                    { this.state.suggestedBooks.map((book, i) => (
                      <li
                        key={i}
                        onClick={this.onSelectBook.bind(this, book)}
                      >
                        { book.fullName }
                      </li>
                    ))}
                  </ul>
                </div>
              }

              <div>
                <input
                  type="number"
                  className="scripturePicker__numberInput js-sp-start-ch"
                  min="1"
                  defaultValue={this.state.refJson.reference_book_start_ch}
                  onChange={this.onSelectStartChapter.bind(this)}
                />
                v
                <input
                  type="number"
                  min="1"
                  className="scripturePicker__numberInput js-sp-start-v"
                  defaultValue={this.state.refJson.reference_book_start_v}
                />
              </div>

              <div>
                <input
                  type="number"
                  min="1"
                  className="scripturePicker__numberInput js-sp-end-ch"
                  defaultValue={this.state.refJson.reference_book_end_ch}
                />
                v
                <input
                  type="number"
                  min="1"
                  className="scripturePicker__numberInput js-sp-end-v"
                  defaultValue={this.state.refJson.reference_book_end_v}
                />
              </div>

              <button
                onClick={this.onSaveReference.bind(this)}
                className="btn btn--primary"
              >
                Select
              </button>

              <button
                onClick={this.onTogglePopup.bind(this)}
              >
                Cancel
              </button>
            </div>
          }
        </ReactCSSTransitionGroup>
      </div>
    );
  }
}

ScripturePicker.propTypes = {
  refJson: PropTypes.array,
  refText: PropTypes.string,
  onConfirm: PropTypes.func.isRequired
}

export default function(selector) {
  const container = document.querySelector(selector);

  if (!container) { return; }

  function callback(refJSON) {
    // Temp hack… go back to edit to allow multiple passages
    const references = [];
    references.push(refJSON);
    document.getElementById(container.dataset.inputid).value = JSON.stringify(references);
  }

  let refJson = container.dataset.refjson;
  try { refJson = JSON.parse(refJson); }
  catch(error) {
    refJson = [];
  }

  ReactDOM.render(
    <ScripturePicker
      refJson={refJson} 
      refText={container.dataset.reftext} 
      onConfirm={callback}
    />
  , container);
}
