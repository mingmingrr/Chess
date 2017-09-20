require! webpack

export
	context: __dirname + '/lib'
	entry: './script.js'
	output:
		path: __dirname + '/lib'
		filename: 'bundle.js'
	plugins:
		if process.env.NODE_ENV == \production
			then (-> &) do
				new webpack.optimize.DedupePlugin!
				new webpack.optimize.OccurenceOrderPlugin!
				new webpack.optimize.UglifyJsPlugin do
					mangle    : false
					sourcemap : false
			else []

