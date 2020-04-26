CSS_SOURCES := scss/custom.scss $(wildcard scss/vars/*.scss)

.PHONY: all
all: .gitignore dist/bootstrap.css

.PHONY: clean
clean:
	rm -rf dist/*

.PHONY: dist-clean
dist-clean: clean
	rm -rf node_modules

.gitignore:
	curl -fsSL -o $@ 'https://www.gitignore.io/api/node'
	echo '!dist/' >> $@
	echo 'dist/*.tmp' >> $@

dist/bootstrap.css: dist/bootstrap.css.tmp node_modules
	npx postcss --use autoprefixer --no-map -o $@ $<

dist/bootstrap.css.tmp: $(CSS_SOURCES) node_modules
	npx node-sass --output-style expanded $< $@


node_modules: package-lock.json
	npm ci
