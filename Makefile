
## Install dependencies
deps:
	npm install

## Watch and build on code change
watch: server_start
	while sleep 1; do \
		find Makefile index.html img/ \
		| entr -d make build; \
	done

## Builds website
build:
	rm -rf out
	mkdir out
	cp -R img out/
	./node_modules/.bin/html-minifier \
		--collapse-whitespace \
		--keep-closing-slash \
		index.html > out/index.html

## Deploy from `/out`
deploy:
	scp -r out/* woledzki@s2.mydevil.net:~/domains/rollingsweets.pl/public_html/

## Start local server
server_start: server.pid

## Stop local server
server_stop: server.pid
	kill `cat $<` && rm $<

server.pid:
	cd out && { \
		php -S localhost:4000 & \
		echo $$! > ../$@; \
	}

## Print this help
help:
	@awk -v skip=1 \
		'/^##/ { sub(/^[#[:blank:]]*/, "", $$0); doc_h=$$0; doc=""; skip=0; next } \
		 skip  { next } \
		 /^#/  { doc=doc "\n" substr($$0, 2); next } \
		 /:/   { sub(/:.*/, "", $$0); printf "\033[34m%-30s\033[0m\033[1m%s\033[0m %s\n\n", $$0, doc_h, doc; skip=1 }' \
		$(MAKEFILE_LIST)
