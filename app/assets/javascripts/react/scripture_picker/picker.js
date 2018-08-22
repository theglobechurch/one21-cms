import React, { Component } from "react";
import PropTypes from "prop-types";
import books from "./books.json";

const scriptureRefTemplate = {
  reference_book: "",
  reference_book_start_ch: "",
  reference_book_start_v: "",
  reference_book_end_ch: "",
  reference_book_end_v: ""
};

export default class Picker extends Component {
  constructor(props) {
    super(props);

    const ref = JSON.parse(JSON.stringify(scriptureRefTemplate));

    this.state = {
      selectedBookData: null,
      suggestedBooks: [],
      refJson: ref,
      lookup: false
    };
  }

  onLookupPassage(event) {
    event.preventDefault();

    const bkName = document.querySelector(".js-sp-book-name");
    const chStart = document.querySelector(".js-sp-start-ch");
    const vStart = document.querySelector(".js-sp-start-v");
    const chEnd = document.querySelector(".js-sp-end-ch");
    const vEnd = document.querySelector(".js-sp-end-v");

    if (!bkName.value) {
      return;
    }

    this.setState({ lookup: true });

    const refJson = {
      reference_book: bkName.value,
      reference_book_start_ch: chStart.value,
      reference_book_start_v: vStart.value,
      reference_book_end_ch: chEnd.value,
      reference_book_end_v: vEnd.value
    };

    // Empty the form– not needed any more
    bkName.value = null;
    chStart.value = null;
    vStart.value = null;
    chEnd.value = null;
    vEnd.value = null;

    const refText = `${refJson.reference_book} ${
      refJson.reference_book_start_ch
    }:${refJson.reference_book_start_v}-${refJson.reference_book_end_ch}:${
      refJson.reference_book_end_v
    }`;

    // Look up passage from API…
    const data = new FormData();
    const token = document.querySelector("meta[name='csrf-token']").content;

    data.append("passages[]", refText);

    const passageLookup = fetch("/bible", {
      credentials: "include",
      headers: {
        "X-CSRF-Token": token,
        TriggeredBy: "scripturePicker"
      },
      method: "POST",
      body: data,
      cache: "no-store"
    });

    passageLookup
      .then(res => {
        this.setState({ lookup: false });
        return res.json();
      })
      .then(json => {
        refJson.passage = {};
        refJson.passage.esv = json[0];

        this.props.onConfirm(refText, refJson);
      });
  }

  onBookLookup(event) {
    const bookEntry = event.target.value;
    const suggestedBooks = books.filter(book =>
      book.fullName.toLowerCase().includes(bookEntry.toLowerCase())
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
    const fieldBookName = document.querySelector(".js-sp-book-name");
    const fieldStartChapter = document.querySelector(".js-sp-start-ch");
    const fieldEndChapter = document.querySelector(".js-sp-end-ch");
    const selectedBookData = books.filter(book =>
      book.fullName.toLowerCase().includes(selectedBook.fullName.toLowerCase())
    )[0];

    fieldBookName.value = selectedBook.fullName;
    fieldStartChapter.max = selectedBook.chapters.length;
    fieldEndChapter.max = selectedBook.chapters.length;

    refJson.reference_book = selectedBook.fullName;

    this.setState({ suggestedBooks: [], refJson, selectedBookData });
  }

  onSelectStartChapter(event) {
    const selectedChapter = event.target.value;
    const refJson = this.state.refJson;
    const fieldStartVerse = document.querySelector(".js-sp-start-v");
    const fieldEndChapter = document.querySelector(".js-sp-end-ch");
    const fieldEndVerse = document.querySelector(".js-sp-end-v");

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

    fieldStartVerse.max = verseCount;
    if (fieldStartVerse.value > verseCount) {
      fieldStartVerse.value = verseCount;
    }

    fieldEndVerse.max = verseCount;
    if (fieldEndVerse.value > verseCount) {
      fieldEndVerse.value = verseCount;
    }

    refJson.reference_book_start_ch = selectedChapter;
    this.setState(refJson);
  }

  render() {
    return (
      <div>
        <h1 className="r_popup__title">Bible reference:</h1>
        <div className="scripturePicker__bookSelector">
          <input
            type="text"
            className="js-sp-book-name r_popup__input"
            autoFocus
            onKeyDown={this.onBookLookup.bind(this)}
            defaultValue={this.state.refJson.reference_book}
          />

          {this.state.suggestedBooks.length !== 0 && (
            <ul className="scripturePicker__autocomplete">
              {this.state.suggestedBooks.map((book, i) => (
                <li key={i} onClick={this.onSelectBook.bind(this, book)}>
                  {book.fullName}
                </li>
              ))}
            </ul>
          )}
        </div>
        <div className="scripturePicker__refSelector">
          <div className="scripturePicker__refSelector__chv">
            <input
              type="number"
              className="r_popup__input r_popup__input--number js-sp-start-ch"
              min="1"
              defaultValue={this.state.refJson.reference_book_start_ch}
              onChange={this.onSelectStartChapter.bind(this)}
            />
            v
            <input
              type="number"
              min="1"
              className="r_popup__input r_popup__input--number js-sp-start-v"
              defaultValue={this.state.refJson.reference_book_start_v}
            />
          </div>

          <div className="scripturePicker__refSelector__chv">
            <input
              type="number"
              min="1"
              className="r_popup__input r_popup__input--number js-sp-end-ch"
              defaultValue={this.state.refJson.reference_book_end_ch}
            />
            v
            <input
              type="number"
              min="1"
              className="r_popup__input r_popup__input--number js-sp-end-v"
              defaultValue={this.state.refJson.reference_book_end_v}
            />
          </div>
        </div>
        <button
          onClick={this.onLookupPassage.bind(this)}
          className="btn r_popup__actionBtn scripturePicker__refSelector__lookup"
        >
          Lookup
        </button>

        {this.state.lookup && <p>Looking up passage…</p>}
      </div>
    );
  }
}

Picker.propTypes = {
  onConfirm: PropTypes.func.isRequired
};
