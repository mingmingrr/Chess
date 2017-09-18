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

lib/%.html: src/%.pug
	mkdir -p $(shell dirname "$@")
	$(pugc) < "$<" > "$@"

lib/%.css: src/%.styl
	mkdir -p $(shell dirname "$@")
	$(stylus) -p -o lib "$<" > "$@"

lib/%.js: src/%.ls
	mkdir -p $(shell dirname "$@")
	$(lsc) --no-header -p -b -c "$<" > "$@"

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

.PHONY: clean
clean:
	@rm -vrf lib
