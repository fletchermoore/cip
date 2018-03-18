const path = require('path');
var CopyWebpackPlugin = require('copy-webpack-plugin');

module.exports = {
  entry: "./assets/js/entry.js",
  output: {
    path: path.resolve(__dirname, 'priv/static/js'),
    filename: "app.js"
  },
  module: {
    rules: [
      { test: /\.css$/, use: ['style-loader', 'css-loader'] },
      {
        test: /\.vue$/,
        loader: 'vue-loader',
        options: {
          loaders: {
            js: {
              loader: 'babel-loader',
              options: {
                presets: ['es2015']
              }
            }
          }
        }
      },
      {
        test: /\.js$/,
        exclude: /node_modules/,
        loader: 'babel-loader',
        options: {
          presets: ['es2015']
        }
      }
    ]
  },
  plugins: [
    new CopyWebpackPlugin([
      { from: './assets/css/uikit.min.css', to: '../css/uikit.min.css' },
      { from: './assets/js/uikit.min.js', to: 'uikit.min.js' }
    ])
  ]
};
