module Html = Dom_html


let alert s =
  Html.window##alert (Js.string s)


let f () =
  Fb.init { Fb.appId = "<set your app id here>";
	    Fb.status = true;
	    Fb.xfbml = false };
  let process_answer answer =
    alert (Printf.sprintf "Hello %s" answer.Fb.username)
  in
  let after_login res =
    match res with
      | Fb.Ok obj -> begin
	let auth_response = obj.Fb.auth_response in
	Js.Unsafe.global##console##log(auth_response.Fb.userId);
	Js.Unsafe.global##console##log(auth_response.Fb.accessToken);
	Fb.api_profile "/me" process_answer
      end
      | Fb.Nok -> begin
	Js.Unsafe.global##console##log("login failed")
      end
      | Fb.Void -> begin
	Js.Unsafe.global##console##log("unexpected")
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
