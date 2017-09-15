default: all

pug = $(shell find src -type f -name "*.pug")
html = $(pug:src/%.pug=lib/%.html)
pugc = pug

styl = $(shell find src -type f -name "*.styl")
css = $(styl:src/%.styl=lib/%.css)
stylus = node_modules/.bin/stylus

ls = $(shell find src -type f -name "*.ls")
js = $(ls:src/%.ls=lib/%.js)
lsc = node_modules/.bin/lsc

lib:
	mkdir -p lib

lib/%.html: src/%.pug lib
	$(pugc) -o lib src -s "$<"

lib/%.css: src/%.styl lib
	$(stylus) -o lib "$<"

lib/%.js: src/%.ls lib
	$(lsc) -o lib -b -c "$<"
	@echo "compiled $<"

.PHONY: all
all: $(html) $(css) $(js)

.PHONY: status
status:
	@echo $(html)
	@echo $(css)
	@echo $(js)

.PHONY: run
run: all
	xdg-open lib/index.html

.PHONY: watch
watch:
	while true; do make --silent; sleep 1; done
