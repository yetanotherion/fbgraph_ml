module Html = Dom_html


let alert s =
  Html.window##alert (Js.string s)


let f () =
  Fb.init { Fb.appId = "<set your app id here>";
	    Fb.cookie = true;
	    Fb.xfbml = false;
            Fb.version = "v2.0" };
  let process_answer answer =
    alert (Printf.sprintf "Hello %s" answer.Fb.username);
    let generate_error fb_res =
      match fb_res with
        | Fb.Nok error -> alert(Printf.sprintf "Got error message:%s error_type %s code %d" error.Fb.message error.Fb.error_type error.Fb.code)
        | Fb.Data _ -> alert("unexpected data");
        | Fb.Ok api_res -> alert(Printf.sprintf "no error");
      alert ("you fixed the bug !");
    in
    Fb.api_event "/v2.0/0" generate_error
  in
  let after_login res =
    match res with
      | Fb.Login_succ obj -> begin
	let auth_response = obj.Fb.auth_response in
	Firebug.console##log(Js.string ("userId: " ^ auth_response.Fb.userId));
	Firebug.console##log(Js.string ("acessToken: " ^ auth_response.Fb.accessToken));
	Fb.api_profile "/me" process_answer
      end
      | Fb.Login_failed | Fb.Login_unhandled_error -> begin
	Firebug.console##log(Js.string "login failed")
      end
  in
  Fb.login after_login

let _ =
  let jssdk = Js.string "facebook-jssdk" in
  let install_sdk () =
    let fjs = List.hd (Dom.list_of_nodeList Html.window##document##getElementsByTagName(Js.string "script")) in
    let js = Html.createScript Html.window##document in
    js##src <- Js.string "all.js";
    js##id <- jssdk;
    let parentFjs = Js.Opt.get (fjs##parentNode) (fun () -> assert false) in
    Dom.insertBefore parentFjs js (Js.some fjs);
    fjs
  in
  ignore(Js.Opt.get (Html.window##document##getElementById(jssdk))
	   install_sdk);
  ignore((Js.Unsafe.coerce Html.window)##fbAsyncInit <- f)
