.PHONY: clean

all: hello_me.js

%.js: %.byte
	js_of_ocaml -pretty $< -o $@

libs.js:
	goji jslink fb -o $@

hello_me.byte: hello_me.ml
	ocamlfind ocamlc -g \
	-syntax camlp4o -package js_of_ocaml.syntax \
	-package fb,js_of_ocaml \
          $< -linkpkg -o $@

clean:
	rm -f *~ hello_me.js *.byte *.cm*
