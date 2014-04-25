SOURCES=goji_lib_fb.ml
PACKAGE=fb

.PHONY: clean install uninstall

all:  $(PACKAGE)
	cd $(PACKAGE) && make all doc

$(PACKAGE): $(patsubst %.ml, %.cmxs, $(SOURCES))
	goji generate $^

%.cmxs: %.ml
	ocamlfind ocamlopt -package goji_lib -shared $< -o $@

install: $(PACKAGE)
	cd $(PACKAGE) && make install

uninstall: $(PACKAGE)
	cd $(PACKAGE) && make uninstall

clean:
	$(RM) -rf $(PACKAGE)
	$(RM) -rf *~ *.cm* *.o
