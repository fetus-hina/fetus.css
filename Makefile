FONT_CSS_USES := $(wildcard scss/fonts/mixin/*.scss) $(wildcard scss/fonts/vars/*.scss)

CSS_SOURCES := \
	$(FONT_CSS_USES) \
	$(wildcard scss/custom/*.scss) \
	$(wildcard scss/vars/*.scss) \
	scss/bizudpgothic.scss \
	scss/custom.scss \
	scss/lineseedjp.scss

JS_SOURCES := $(wildcard js/*.js)

FONT_CSS_SOURCES := $(wildcard scss/fonts/*.scss)
FONT_CSS_TARGETS := $(addprefix dist/fonts/,$(notdir $(FONT_CSS_SOURCES:.scss=.min.css)))

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

GZIP_TARGETS := \
	$(FONT_CSS_TARGETS:.min.css=.css.gz) \
	$(FONT_CSS_TARGETS:.min.css=.min.css.gz) \
	dist/bootstrap-bizudpgothic.css.gz \
	dist/bootstrap-bizudpgothic.min.css.gz \
	dist/bootstrap-lineseedjp.css.gz \
	dist/bootstrap-lineseedjp.min.css.gz \
	dist/bootstrap.css.gz \
	dist/bootstrap.min.css.gz \
	dist/favicon/favicon.svg.gz \
	dist/fetus-css.js \
	dist/fetus-css.js.gz \
	dist/fetus-css.min.js \
	dist/fetus-css.min.js.gz

BROTLI_TARGETS := $(GZIP_TARGETS:.gz=.br)

ALL_TARGETS := \
	.browserslistrc \
	.gitignore \
	dist/bootstrap-bizudpgothic.min.css \
	dist/bootstrap-lineseedjp.min.css \
	dist/bootstrap.min.css \
	dist/fetus-css.min.js \
	$(FONT_CSS_TARGETS) \
	$(FAVICON_TARGETS) \
	$(GZIP_TARGETS) \
	$(BROTLI_TARGETS)

.PHONY: all
all: $(ALL_TARGETS)

.PHONY: clean
clean:
	rm -rf \
		$(BROTLI_TARGETS) \
		$(FONT_CSS_TARGETS) \
		$(FONT_CSS_TARGETS:.min.css=.css) \
		$(GZIP_TARGETS) \
		dist/*.css \
		dist/*.js \
		dist/favicon

.PHONY: dist-clean
dist-clean: clean
	rm -rf node_modules

.PHONY: depends
depends:
	rm -rf node_modules package-lock.json
	npx updates -u
	npm install

.PHONY: check-style
check-style: check-style-css check-style-js

.PHONY: check-style-css
check-style-css: node_modules
	npx stylelint 'scss/fonts/**/*.scss'

.PHONY: check-style-js
check-style-js: node_modules
	npx semistandard 'js/**/*.js'

.gitignore:
	curl -fsSL -o $@ 'https://www.gitignore.io/api/node'
	echo '!dist/' >> $@
	echo '.browserslistrc' >> $@

.browserslistrc:
	curl -fsSL -o $@ 'https://raw.githubusercontent.com/twbs/bootstrap/main/.browserslistrc'

.PRECIOUS: dist/bootstrap.css
dist/bootstrap.css: scss/custom.scss $(CSS_SOURCES) node_modules .browserslistrc
	npx sass --style=expanded --charset --no-source-map --no-unicode $< | npx postcss --use autoprefixer --no-map -o $@
	@touch $@

.PRECIOUS: dist/bootstrap-bizudpgothic.css
dist/bootstrap-bizudpgothic.css: scss/bizudpgothic.scss $(CSS_SOURCES) node_modules .browserslistrc
	npx sass --style=expanded --charset --no-source-map --no-unicode $< | npx postcss --use autoprefixer --no-map -o $@
	@touch $@

.PRECIOUS: dist/bootstrap-lineseedjp.css
dist/bootstrap-lineseedjp.css: scss/lineseedjp.scss $(CSS_SOURCES) node_modules .browserslistrc
	npx sass --style=expanded --charset --no-source-map --no-unicode $< | npx postcss --use autoprefixer --no-map -o $@
	@touch $@

.PRECIOUS: dist/fonts/%.css
dist/fonts/%.css: scss/fonts/%.scss $(FONT_CSS_USES) node_modules .browserslistrc
	npx sass --style=expanded --charset --no-source-map --no-unicode $< | npx postcss --use autoprefixer --no-map -o $@
	@touch $@

%.min.css: %.css node_modules .browserslistrc
	npx postcss --use cssnano --no-map -o $@ $<
	@touch $@

.PRECIOUS: dist/fetus-css.js
dist/fetus-css.js: js/index.js $(JS_SOURCES) node_modules .browserslistrc
	npx browserify --transform babelify -o $@ $<
	@touch $@

%.min.js: %.js node_modules .browserslistrc
	npx terser -c -m -f ascii_only=true -o $@ $<
	@touch $@

%.gz: %
	gzip -9cknq $< > $@
	@touch $@

%.br: %
	brotli -fkZ $<
	@touch $@

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
