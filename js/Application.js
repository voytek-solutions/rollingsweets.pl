'use strict';

var menuboardView = require('./views/menuboard');
var Hammer = require('hammerjs')
import createHistory from 'history/createBrowserHistory'

class Application {
	constructor() {
		this.overlayElement = document.getElementsByClassName('v').item(0);
		this.overlayHammer = new Hammer(this.overlayElement);
		this.history = createHistory();
		this.unlisten = this.history.listen(this.route.bind(this));
	}

	route(location, action) {
		ga('auto.send', 'pageview', location.pathname);

		if ('/' == location.pathname) {
			document.body.className = "";
		} else {
			this.displayMenu(location);
		}
	}

	start() {
		var app = this;

		this.overlayHammer.on("panright tap", function(ev) {
			app.hideMenu();
		});
		this.hijackLinks();
		this.route(this.history.location, 'INIT');
	}

	hijackLinks() {
		var app = this;
		var i, l;

		l = document.getElementsByClassName('clickable');
		for (i = 0; i < l.length; i++) {
			l.item(i).onclick = function() {
				app.history.push(this.dataset.href, { });
			}
		}
	}

	displayMenu(item) {
		this.overlayElement.innerHTML = menuboardView({
			src: 'img/menu' + item.pathname + '.jpg'
		});
		document.body.className = "overlay";
	}

	hideMenu() {
		this.history.push('/', { });
	}
}

function toggleClass(node, className) {
	// console.dir(node);
}

module.exports = Application;
