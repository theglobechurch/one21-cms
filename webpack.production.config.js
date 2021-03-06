var webpack = require('webpack');

module.exports = {
  devtool: 'eval-source-map',
  entry: __dirname + "/app/assets/javascripts/application.js",
  output: {
    path: __dirname + "/public/assets/js",
    filename: "bundle.js"
  },

  module: {
    rules: [
      {
        test: /\.json$/,
        loader: "json"
      },
      {
        test: /\.js$/,
        exclude: /node_modules/,
        loader: 'babel-loader'
      }
    ]
  }
}
