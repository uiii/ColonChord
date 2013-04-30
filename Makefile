### VARIABLES ###
version=$(shell cat VERSION)

build_dir=build
debug_dir=build/debug
release_dir=build/release

config_dir=config
src_dir=src

peg=./${build_dir}/node_modules/.bin/pegjs
uglify=./${build_dir}/node_modules/.bin/uglifyjs

debug_src_files= \
	${debug_dir}/Exception.js \
	${debug_dir}/grammar.js \
	${debug_dir}/parse.js

debug_files= \
	${debug_src_files} \
	${debug_dir}/ColonChord.js

release_files= \
	${release_dir}/ColonChord.js

### TARGETS ###
.PHONY: all build debug release test clean clean-all

all: release

build: debug

debug: node-dependencies debug-dir ${debug_files}
release: debug release-dir ${release_files}

test: build run-tests

clean:
	rm -rf ${debug_dir}
	rm -rf ${release_dir}

clean-all:
	rm -rf ${build_dir}

### NODE DEPENDENCIES RULES ###
build-dir:
	mkdir -p ${build_dir}

${build_dir}/package.json: package.json
	cp $^ $@

${build_dir}/node_modules/.installed: ${build_dir}/package.json
	cd ${build_dir} && npm install
	@touch ${build_dir}/node_modules/.installed

node-dependencies: build-dir ${build_dir}/node_modules/.installed

### DEBUG RULES ###
debug-dir:
	mkdir -p ${debug_dir}

${debug_dir}/%.js: ${src_dir}/%.js
	cp $^ $@

${debug_dir}/grammar.js: ${src_dir}/grammar.pegjs
	${peg} -e 'var grammar' $^ $@
	
${debug_dir}/ColonChord.js: ${debug_src_files}
	@echo "(function(exports) {" > $@

	@for file in $^; do \
		echo -en "\n" >> $@; \
		sed -e 's/^/    /' $$file >> $@; \
	done

	@echo -e "\n})(typeof exports === 'undefined' ? this.ColonChord = {} : exports);" >> $@

### RELEASE RULES ###
release-dir:
	mkdir -p ${release_dir}

${release_dir}/%.js: ${debug_dir}/%.js
	cp $^ $(@:.js=-${version}.js)
	${uglify} $^ -o $(@:.js=-${version}.min.js)

### TEST RULES ###
run-tests:
	karma start ${config_dir}/karma.conf.js --single-run
