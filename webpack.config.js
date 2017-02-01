module.exports = {
    entry: './src/static/index.js',
    output: {
        path: './dist',
        filename: 'bundle.js'
    },
    module: {
        loaders: [
            {
                test:    /\.elm$/,
                exclude: [/elm-stuff/, /node_modules/],
                loader:  'elm-webpack?verbose=true&warn=true',
            }
        ]
    },
    externals: [
    (function () {
      var IGNORES = [
        'electron'
      ];
      return function (context, request, callback) {
        if (IGNORES.indexOf(request) >= 0) {
          return callback(null, "require('" + request + "')");
        }
        return callback();
      };
    })()
    ],
    resolve: {
        extensions: ['', '.js', '.elm']
    }
};
