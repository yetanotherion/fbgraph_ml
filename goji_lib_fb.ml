(* Published under the LGPL version 3
   Binding (c) 2014 Ion Alberdi *)

open Goji
open Goji_syntax
open Goji_ast

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
                                     row "cookie"
                                       (bool @@ field root "status");
                                     row "xfbml"
                                       (bool @@ field root "xfbml");
                                     row "version"
                                       (string @@ field root "version")
                                   ]));
      def_type
        ~doc:"scope."
        "scope" (public (record [ row "scope"
                                       ~doc:"scope"
                                       (string @@ field root "scope")]));
      def_type
        ~doc: "status response"
        "status_res" (public (variant ( [constr "LoggedInFbAndApp"
                                            Guard.(field root "status" = string "connected")
                                         ~doc:"logged in fb and app"
                                            [];
                                         constr "LoggedInFbOnly"
                                           Guard.(field root "status" = string "not_authorized")
                                           ~doc: "need to log to the app"
                                           [];
                                         constr "NotLoggedInFb"
                                           Guard.tt
                                           ~doc: "not logged in Fb"
                                           []])));
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
        "login_res" (public (variant ( [constr "Login_failed"
                                           Guard.(field root "status" = string "not_authorized")
                                           ~doc:"login error"
                                           [];
                                        constr "Login_succ"
                                          Guard.(field root "status" = string "connected")
                                          ~doc: "succesfull login"
                                          [(abbrv "status_and_auth_response")];
                                        constr "Login_unhandled_error"
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
        "api_element" (public (record [row "user_id"
                                          ~doc: "id"
                                          (string @@ field root "id");
                                       row "name"
                                         ~doc: "name"
                                         (string @@ field root "name")]));
      def_type
        ~doc: "paging."
        "paging_element" (public (record [row "cursors"
                                             ~doc: "cursors"
                                             ((abbrv "cursors" @@ field root "cursors"));
                                          row "previous"
                                            ~doc: "link to previous"
                                            ((option_undefined string) @@ field root "previous");
                                          row "next"
                                            ~doc: "link to next"
                                            ((option_undefined string) @@ field root "next")]));
      def_type
        ~doc: "owner."
        "owner" (public (record [row "name"
                                        ~doc: "name"
                                        (string @@ field root "name");
                                     row "owner_id"
                                       ~doc: "name"
                                       (string @@ field root "id")]));
      def_type
        ~doc: "venue."
        "venue" (public (record [row "venue_id"
                                    ~doc: "id"
                                    (string @@ field root "id");
                                 row "city"
                                   ~doc: "city"
                                   (string @@ field root "city");
                                 row "country"
                                   ~doc: "country"
                                   (string @@ field root "country");
                                ]));
      def_type
        ~doc:"correct event res."
        "correct_event_res" (public (record [row "description"
                                                ~doc: "description"
                                                (string  @@ field root "description");
                                             row "is_date_only"
                                               ~doc: "is_date_only"
                                               (string @@ field root "is_date_only");
                                             row "name"
                                               ~doc: "name"
                                               (string @@ field root "name");
                                             row "owner"
                                               ~doc: "owner"
                                               ((abbrv "owner") @@ field root "owner");
                                             row "start_time"
                                               ~doc: "start_time"
                                               (string @@ field root "start_time");
                                             row "venue"
                                               ~doc: "venue"
                                               (option_undefined (abbrv "venue") @@ field root "venue");
                                             row "privacy"
                                               ~doc: "privacy"
                                               (string @@ field root "privacy")]));

      def_type
        ~doc: "error"
        "error" (public (record [row "message"
                                    ~doc: "message"
                                    (string @@ field root "message");
                                 row "error_type"
                                   ~doc: "type"
                                   (string @@ field root "type");
                                 row "code"
                                   ~doc: "code"

                                   (int @@ field root "code")]));
      def_type
        ~doc:"profile res."
        "profile_res" (public (record [row "profile_id"
                                          ~doc: "id"
                                          (string @@ field root "id");
                                       row "link"
                                         ~doc: "link"
                                         (string @@ field root "link");
                                       row "gender"
                                         ~doc: "gender"
                                         (string @@ field root "gender");
                                       row "profile_name"
                                         ~doc: "name"
                                         (string @@ field root "name")]));
      def_type
        ~doc: "api_res"
        "api_res" (public (variant ([constr "Nok"
                                          Guard.(field root "error" <> undefined)
                                          ~doc:"event does not exist"
                                        [ (abbrv "error") @@ field root "error"];
                                     constr "ProfileOk"
                                          Guard.(field root "first_name" <> undefined)
                                          ~doc:"answer is a profile"
                                        [ (abbrv "profile_res" @@ root)];
                                     constr "EvData"
                                          Guard.(field root "data" <> undefined)
                                          ~doc: "data from the event"
                                        [ (array (abbrv "api_element")) @@ field root "data";
                                          (abbrv "paging_element") @@ field root "paging" ];
                                     constr "EvOk"
                                          Guard.tt
                                          ~doc: "event successfully obtained"
                                        [(abbrv "correct_event_res")]])));

      map_function "init"
        ~doc:"Init fb stuff"
        [ curry_arg "init_param" ((abbrv "init_arg") @@ arg 0)]
        "FB.init"
        void;

      map_function "login"
        ~doc:"login"
        [ curry_arg "f" ((callback [ curry_arg "response" ((abbrv "login_res") @@ arg 0)] void) @@ arg 0);
          curry_arg "scope" ((abbrv "scope" @@ arg 1))]
        "FB.login"
        void;

      map_function "getLoginStatus"
        ~doc:"get login status"
        [ curry_arg "f" ((callback [ curry_arg "response" ((abbrv "status_res") @@ arg 0)] void) @@ arg 0)]
        "FB.getLoginStatus"
        void;

      map_function "api"
        ~doc:"call facebook api"
        [ curry_arg "link" (string @@ arg 0);
          curry_arg "f" ((callback [ curry_arg "response" ((abbrv "api_res") @@ arg 0)] void) @@ arg 1)]
        "FB.api"
        void;
    ]
