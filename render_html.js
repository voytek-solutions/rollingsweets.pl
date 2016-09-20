'use strict';

var fs = require('fs');
var view = require('./jst/index');
var data = {
	style: '',
	script: ''
};

data.style = fs.readFileSync('./tmp/css/inline.css');
data.script = fs.readFileSync('./tmp/js/web.bundle.js');

fs.writeFile("./out/index.html", view(data), function(err) {
	if (err) {
		return console.log(err);
	}
});
