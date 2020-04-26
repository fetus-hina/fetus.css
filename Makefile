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

dist/bootstrap.css: scss/custom.scss node_modules
	npx node-sass --output-style expanded $<\
		| npx postcss --use autoprefixer --no-map \
		> $@

node_modules: package-lock.json
	npm ci
