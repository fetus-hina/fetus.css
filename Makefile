CSS_SOURCES := scss/custom.scss \
	$(wildcard scss/vars/*.scss) \
	$(wildcard scss/custom/*.scss)

FAVICON_TARGETS := \
	dist/favicon/apple-touch-icon-114.png \
	dist/favicon/apple-touch-icon-120.png \
	dist/favicon/apple-touch-icon-144.png \
	dist/favicon/apple-touch-icon-152.png \
	dist/favicon/apple-touch-icon-180.png \
	dist/favicon/apple-touch-icon-57.png \
	dist/favicon/apple-touch-icon-60.png \
	dist/favicon/apple-touch-icon-72.png \
	dist/favicon/apple-touch-icon-76.png \
	dist/favicon/favicon.ico \
	dist/favicon/favicon.svg

.PHONY: all
all: .browserslistrc .gitignore dist/bootstrap.min.css $(FAVICON_TARGETS)

.PHONY: clean
clean:
	rm -rf dist/*

.PHONY: dist-clean
dist-clean: clean
	rm -rf node_modules

.PHONY: depends
depends:
	rm -rf node_modules package-lock.json
	npx updates -u
	npm install

.gitignore:
	curl -fsSL -o $@ 'https://www.gitignore.io/api/node'
	echo '!dist/' >> $@
	echo '.browserslistrc' >> $@

.browserslistrc:
	curl -fsSL -o $@ 'https://raw.githubusercontent.com/twbs/bootstrap/main/.browserslistrc'

.PRECIOUS: dist/bootstrap.css
dist/bootstrap.css: $(CSS_SOURCES) node_modules .browserslistrc
	npx sass --style=expanded --charset --no-source-map --no-unicode $< \
		| npx postcss --use autoprefixer --no-map -o $@

dist/bootstrap.min.css: dist/bootstrap.css node_modules .browserslistrc
	npx postcss --use cssnano --no-map -o $@ $<

dist/favicon/%.svg: favicon/%.svg node_modules .svgo.config.js
	@mkdir -p $(dir $@)
	npx svgo -p 3 --multipass --quiet --eol lf --final-newline --config .svgo.config.js -o $@ -i $<

dist/favicon/%.ico: dist/favicon/%.svg
	convert -background none $< -define icon:auto-resize=16,32,48,64 $@

define apple-touch-icon
    @mkdir -p $(dir $(1))
	convert -background none $(2) -resize $(3)x$(3) $(1)
	npx pngcrush -ow -new -rem allb -brute -q $(1) || true
endef

dist/favicon/apple-touch-icon-57.png: dist/favicon/favicon.svg node_modules
	$(call apple-touch-icon,$@,$<,57)

dist/favicon/apple-touch-icon-60.png: dist/favicon/favicon.svg node_modules
	$(call apple-touch-icon,$@,$<,60)

dist/favicon/apple-touch-icon-72.png: dist/favicon/favicon.svg node_modules
	$(call apple-touch-icon,$@,$<,72)

dist/favicon/apple-touch-icon-76.png: dist/favicon/favicon.svg node_modules
	$(call apple-touch-icon,$@,$<,76)

dist/favicon/apple-touch-icon-114.png: dist/favicon/favicon.svg node_modules
	$(call apple-touch-icon,$@,$<,114)

dist/favicon/apple-touch-icon-120.png: dist/favicon/favicon.svg node_modules
	$(call apple-touch-icon,$@,$<,120)

dist/favicon/apple-touch-icon-144.png: dist/favicon/favicon.svg node_modules
	$(call apple-touch-icon,$@,$<,144)

dist/favicon/apple-touch-icon-152.png: dist/favicon/favicon.svg node_modules
	$(call apple-touch-icon,$@,$<,152)

dist/favicon/apple-touch-icon-180.png: dist/favicon/favicon.svg node_modules
	$(call apple-touch-icon,$@,$<,180)

node_modules: package-lock.json
	npm ci
