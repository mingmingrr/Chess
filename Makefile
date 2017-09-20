default: all

pug = $(shell find src -type f -name "*.pug")
html = $(pug:src/%.pug=lib/%.html)
pugc = node_modules/.bin/pug

styl = $(shell find src -type f -name "*.styl")
css = $(styl:src/%.styl=lib/%.css)
stylus = node_modules/.bin/stylus

ls = $(shell find src -type f -name "*.ls")
js = $(ls:src/%.ls=lib/%.js)
lsc = node_modules/.bin/lsc

webpack = node_modules/.bin/webpack

lib/%.html: src/%.pug
	mkdir -p $(shell dirname "$@")
	$(pugc) -P < "$<" > "$@"
	@echo "--> compiled $<"

lib/%.css: src/%.styl
	mkdir -p $(shell dirname "$@")
	$(stylus) -p -o lib "$<" > "$@"
	@echo "--> compiled $<"

lib/%.js: src/%.ls
	mkdir -p $(shell dirname "$@")
	$(lsc) --no-header -p -b -c "$<" > "$@"
	@echo "--> compiled $<"

webpack.config.js:
	$(lsc) --no-header -p -b -c webpack.config.ls > webpack.config.js

.PHONY: all
all: compile pack

.PHONY: compile
compile: $(html) $(css) $(js)

.PHONY: pack
pack: webpack.config.js
	${webpack}

.PHONY: run
run: all
	xdg-open lib/index.html

.PHONY: watch
watch: webpack.config.js compile
	${webpack} --watch &
	while true; do make --silent compile || notify-send -a make "make failed"; sleep 1; done

.PHONY: clean
clean:
	@rm -vrf lib
