var webpack, ref$, out$ = typeof exports != 'undefined' && exports || this;
webpack = require('webpack');
ref$ = out$;
ref$.context = __dirname + '/lib';
ref$.entry = './script.js';
ref$.output = {
  path: __dirname + '/lib',
  filename: 'bundle.js'
};
ref$.plugins = process.env.NODE_ENV === 'production'
  ? function(){
    return arguments;
  }(new webpack.optimize.DedupePlugin(), new webpack.optimize.OccurenceOrderPlugin(), new webpack.optimize.UglifyJsPlugin({
    mangle: false,
    sourcemap: false
  }))
  : [];
