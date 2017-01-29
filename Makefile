
## Install dependencies
deps:
	npm install

## Watch and build on code change
watch: server_start
	while sleep 1; do \
		find Makefile jst/ js/ css/ img/ \
		| entr -d make build; \
	done

## Builds website
build: build_css build_js build_images
	node compile_jst.js ./jst
	node render_html.js

## Build tmp css files to be loaded and included directly in the page
build_css: tmp
	@rm -rf tmp/css
	@mkdir -p tmp/css
	~/.gem/ruby/2.0.0/bin/sass \
			--style compressed \
			--sourcemap=none \
			css/inline.scss \
			tmp/css/inline.css

## Build JavaScript
build_js:
	@rm -rf tmp/js
	@mkdir -p tmp/js
	node compile_jst.js ./js/views
	./node_modules/.bin/webpack \
		--optimize-minimize

## Build Images
build_images:
	rm -rf out/img
	mkdir -p out/img
	mkdir -p out/img/menu
	find ./img -not -path "*/.src/*" -and \( -name "*.png" -or -name "*.jpg" \) | xargs -I{} cp {} out/{}

## Deploy to production server
deploy:
	scp -r out/* woledzki@s2.mydevil.net:~/domains/rollingsweets.pl/public_html/

## Deploy to staging server
deploy_stg:
	scp -r out/* woledzki@s2.mydevil.net:~/domains/stg.rollingsweets.pl/public_html/

## Start local server
server_start: server.pid

## Stop local server
server_stop: server.pid
	kill `cat $<` || echo "nothing to kill"
	rm $<

server.pid:
	cd out && { \
		php -S localhost:4000 & \
		echo $$! > ../$@; \
	}

tmp:
	mkdir tmp

## Clean up project folder
clean:
	rm -rf tmp

## Print this help
help:
	@awk -v skip=1 \
		'/^##/ { sub(/^[#[:blank:]]*/, "", $$0); doc_h=$$0; doc=""; skip=0; next } \
		 skip  { next } \
		 /^#/  { doc=doc "\n" substr($$0, 2); next } \
		 /:/   { sub(/:.*/, "", $$0); printf "\033[34m%-30s\033[0m\033[1m%s\033[0m %s\n\n", $$0, doc_h, doc; skip=1 }' \
		$(MAKEFILE_LIST)
