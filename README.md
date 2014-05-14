fbgraph_ml
==========

Bindings of the facebook javascript graph-api in ocaml.
It depends on the Goji, 'Ocaml-Javascript interoperability multi-tool.'

Build and install library
-------------------------
- Install Goji, with the instructions depicted in
https://github.com/klakplok/goji

- Build and install <br/>
  % make <br/>
  % make install <br/>


Try example/hello_me.ml
-----------------------

1. Install Js_of_ocaml, through opam (http://opam.ocaml.org/).

2. Get an application id from facebook, by going to
   https://developers.facebook.com/, <br/>
   tab Applications> Create an application.

3. Set it in example/hello_me.ml#47.

4. Generate hello_me.js <br/>
   % cd example <br/>
   % make

5. Download the Facebook javascript library
   wget http://connect.facebook.net/en_us/all.js
   and set it in the same location as the index.html.

6. Deploy your [index.html, hello_me.js, all.js] in a web server directory,
   configured as allowed by your facebook application (2). Then
   open a browser at a link pointing to that index.html.
