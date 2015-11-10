var path = require('path');

module.exports = {
  entry: {
    app: ['./src/index.js']
  },
  devtool: "source-map", // or "inline-source-map"
  output: {
    path: path.resolve(__dirname, 'dist'),
    publicPath: '/javascripts',
    filename: 'webpack_bundle.js',
    library: 'SomervilleTeacherToolUi',
    libraryTarget: 'umd'
  },
  resolve: {
    extensions: ['', '.js']
  },
  module: {
    loaders: [
      { test: /\.css$/, loader: "style!css" },
      { test: /\.scss$/, loaders: ["style", "css", "sass"] }
    ]
  },
  watchOptions: {
    poll: true
  }
};