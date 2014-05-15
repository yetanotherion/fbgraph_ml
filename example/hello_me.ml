module Html = Dom_html


let alert s =
  Html.window##alert (Js.string s)

let lwtInstallSdkAlreadyCalled = ref false
let jssdk = Js.string "facebook-jssdk"

let install_sdk () =
  let fjs = List.hd (Dom.list_of_nodeList Html.window##document##getElementsByTagName(Js.string "script")) in
  let js = Html.createScript Html.window##document in
  js##src <- Js.string "all.js";
  js##id <- jssdk;
  let parentFjs = Js.Opt.get (fjs##parentNode) (fun () -> assert false) in
  Dom.insertBefore parentFjs js (Js.some fjs);
  fjs

let lwt_install_sdk init =
  ignore(Js.Opt.get (Html.window##document##getElementById(jssdk))
	   install_sdk);
  let window = (Js.Unsafe.coerce Html.window) in
  if !lwtInstallSdkAlreadyCalled then Lwt.return ()
  else begin
    lwtInstallSdkAlreadyCalled := true;
    let fbasyncInitWaiter, fbasyncInitWakener = Lwt.wait () in
    window##fbAsyncInit <- (fun () -> init (); Lwt.wakeup fbasyncInitWakener ());
    fbasyncInitWaiter
  end

let lwt_login () =
  let flogin, fwakener = Lwt.wait () in
  Fb.login (fun r -> Lwt.wakeup fwakener r);
    flogin

let make_lwt fb_api_call url =
  let call_res, fwakener = Lwt.wait () in
  fb_api_call url (fun r -> Lwt.wakeup fwakener r);
  call_res

let lwt_api_profile = make_lwt Fb.api_profile
let lwt_api_event = make_lwt Fb.api_event

let _ =
  lwt () = lwt_install_sdk
  (fun () -> Fb.init {
    Fb.appId = "<set your app id here>";
    Fb.cookie = true;
    Fb.xfbml = false;
    Fb.version = "v2.0" }) in
  match_lwt (lwt_login ()) with
    | Fb.Login_failed | Fb.Login_unhandled_error -> begin
      Firebug.console##log(Js.string "login failed");
      Lwt.return_unit
    end
    | Fb.Login_succ obj -> begin
      let auth_response = obj.Fb.auth_response in
      Firebug.console##log(Js.string ("userId: " ^ auth_response.Fb.userId));
      Firebug.console##log(Js.string ("acessToken: " ^ auth_response.Fb.accessToken));
      lwt profile_res = lwt_api_profile "/me" in
      alert (Printf.sprintf "Hello %s" profile_res.Fb.username);
      match_lwt (lwt_api_event "/v2.0/0") with
        | Fb.Nok error -> (alert(Printf.sprintf
                                   "Got error message:%s error_type %s code %d"
                                   error.Fb.message error.Fb.error_type error.Fb.code);
                           Lwt.return_unit)
        | Fb.Data _ -> (alert("unexpected data"); Lwt.return_unit)
        | Fb.Ok api_res -> (alert(Printf.sprintf "no error"); Lwt.return_unit)
    end
