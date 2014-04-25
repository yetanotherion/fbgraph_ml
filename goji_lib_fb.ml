(* Published under the LGPL version 3
   Binding (c) 2014 Ion Alberdi *)

open Goji

let fb_package =
  register_package
    ~doc:"Bindings to the facebook javascript graph-api."
    ~version:"0.1"
    "fb"

let fb_component =
  register_component
    ~license:Goji_license.lgpl_v3
    ~doc:"Bindings to the facebook javascript graph-api."
    fb_package "fb"
    [ def_type
        ~doc:"init argument."
        "init_arg" (public (record [ row "appId"
                                       ~doc:"appId"
                                       (string @@ field root "appId");
                                     row "status"
                                       (bool @@ field root "status");
                                     row "xfbml"
                                       (bool @@ field root "xfbml")
                                   ]));
      def_type
        ~doc:"auth response."
        "auth_response" (public (record [ row "userId"
                                            ~doc:"userId"
                                            (string @@ field root "userID");
                                          row "accessToken"
                                            (string @@ field root "accessToken")]));
      def_type
        ~doc:"status and auth reponse"
        "status_and_auth_response" (public (record [ row "status" (string @@ field root "status");
                                                     row "auth_response" ((abbrv "auth_response") @@ field root "authResponse")]));
      def_type
        ~doc:"login res."
        "login_res" (public (variant ( [constr "Nok"
                                           Guard.(field root "status" = string "not_authorized")
                                           ~doc:"login error"
                                           [];
                                        constr "Ok"
                                          Guard.(field root "status" = string "connected")
                                          ~doc: "succesfull login"
                                          [(abbrv "status_and_auth_response")];
                                        constr "Void"
                                          Guard.tt
                                          ~doc: "unhandled"
                                          []])));
      def_type
        ~doc:"cursors."
        "cursors" (public (record [row "after"
                                     ~doc: "after"
                                     (string @@ field root "after");
                                  row "before"
                                    ~doc: "before"
                                    (string @@ field root "before")]));
      def_type
        ~doc: "api element."
        "api_element" (public (record [row "id"
                                          ~doc: "id"
                                          (string @@ field root "id");
                                       row "name"
                                         ~doc: "name"
                                         (string @@ field root "name")]));
      def_type
        ~doc: "paging."
        "paging_element" (public (record [row "cursors"
                                             ~doc: "cursors"
                                             ((abbrv "cursors" @@ field root "cursors"))]));
      def_type
        ~doc:"api res."
        "api_res" (public (record [row "data"
                                      ~doc: "data"
                                      ((array (abbrv "api_element")) @@ field root "data");
                                   row "paging"
                                     ~doc: "paging"
                                     ((abbrv "paging_element") @@ field root "paging")]));
      map_function "init"
        ~doc:"Init fb stuff"
        [ curry_arg "init_param" ((abbrv "init_arg") @@ arg 0)]
        "FB.init"
        void;
      map_function "login"
        ~doc:"login"
        [ curry_arg "f" ((callback [ curry_arg "response" ((abbrv "login_res") @@ arg 0)] void) @@ arg 0)]
        "FB.login"
        void;
      map_function "api"
        ~doc:"api"
        [ curry_arg "link" (string @@ arg 0);
          curry_arg "f" ((callback [ curry_arg "response" ((abbrv "api_res") @@ arg 0)] void) @@ arg 1)]
        "FB.api"
        void
    ]
