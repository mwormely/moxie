OUT_DIR = build
SRC_DIR = src
BIN_DIR = bin
MP3_DIR = static

all: \
	${OUT_DIR} \
	${OUT_DIR}/index.html \
	${OUT_DIR}/moxie.css \
	${OUT_DIR}/inconsolata.woff2 \
	${OUT_DIR}/inconsolata.ttf \
	${OUT_DIR}/moxie.js \
	${OUT_DIR}/index.json

${OUT_DIR}:
	mkdir -p "${OUT_DIR}"

${OUT_DIR}/index.html: ${SRC_DIR}/index.html
	cp "$?" "$@"

${OUT_DIR}/moxie.css: ${SRC_DIR}/moxie.css
	cp "$?" "$@"

${OUT_DIR}/inconsolata.woff2: ${SRC_DIR}/inconsolata.woff2
	cp "$?" "$@"

${OUT_DIR}/inconsolata.ttf: ${SRC_DIR}/inconsolata.ttf
	cp "$?" "$@"

${OUT_DIR}/moxie.js: ${SRC_DIR}/Moxie.elm
	yarn run elm make "$?" --output="$@"

${OUT_DIR}/index.json: ${MP3_DIR}/manifest.json ${MP3_DIR}/*.mp3
	${BIN_DIR}/make-index-json --output="$@" --prefix=static ${MP3_DIR}

.PHONY: clean test devd watch

clean:
	rm -rf node_modules elm-stuff tests/elm-stuff
	rm -rf ${OUT_DIR}

test:
	yarn run elm-test

serve:
	devd --notimestamps --livereload --watch="${OUT_DIR}" \
		/="${OUT_DIR}" \
		/static/="${MP3_DIR}"

watch:
	watchexec -e elm,html,css,json -i "\*/${OUT_DIR}/\*" make
