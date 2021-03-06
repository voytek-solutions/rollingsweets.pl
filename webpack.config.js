module.exports = {
	entry: './js/index.js',
	output: {
		path: './tmp/js/',
		filename: 'web.bundle.js'
	},
	module: {
		loaders: [ {
			test: /\.js$/,
			exclude: /node_modules/,
			loader: 'babel-loader'
		} ]
	}
};
