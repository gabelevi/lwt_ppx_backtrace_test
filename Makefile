clean:
	ocamlbuild -clean

test.%: clean
	ocamlbuild -cflags -g -use-ocamlfind -package lwt -package lwt.unix -package lwt_ppx $@ && \
	OCAMLRUNPARAM=b ./$@

.PHONY: clean
