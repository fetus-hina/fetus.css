CSS_SOURCES := scss/custom.scss \
	$(wildcard scss/vars/*.scss) \
	$(wildcard scss/custom/*.scss)

.PHONY: all
all: .gitignore dist/bootstrap.min.css

.PHONY: clean
clean:
	rm -rf dist/*

.PHONY: dist-clean
dist-clean: clean
	rm -rf node_modules

.gitignore:
	curl -fsSL -o $@ 'https://www.gitignore.io/api/node'
	echo '!dist/' >> $@

.PRECIOUS: dist/bootstrap.css
dist/bootstrap.css: $(CSS_SOURCES) node_modules
	npx sass --style=expanded --charset --no-source-map --no-unicode $< \
		| npx postcss --use autoprefixer --no-map \
		| npx cleancss -O0 --format beautify -o $@

dist/bootstrap.min.css: dist/bootstrap.css node_modules
	npx cleancss -o $@ -O2 --skip-rebase -f 'breaks:afterRuleEnds=on:afterBlockEnds=on:afterAtRule=on' $<

node_modules: package-lock.json
	npm ci
