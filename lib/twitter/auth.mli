module Consumer : sig
  type t = { key : string; secret : string } with conv(ocaml)
  val dummy : t (** a sample data *)
end

(** tokens sent+received between the server and clients *)
module Token : sig
  type t = { token : string; secret : string }
end

module VerifiedToken : sig
  type t = Token.t * string
end

val oauth : Consumer.t -> VerifiedToken.t -> Oauth.t

val fetch_request_token : 
  curl_handle_tweak:(Curl.handle -> unit) 
  -> Consumer.t 
  -> (string (* URL *) * Token.t, 
      [> `Http of int * string ]) Meta_conv.Result.t

val fetch_access_token  : 
  curl_handle_tweak:(Curl.handle -> unit)
  -> Consumer.t 
  -> VerifiedToken.t 
  -> (string (* username *) * Token.t, 
      [> `Http of int * string ]) Meta_conv.Result.t

val access : 
  curl_handle_tweak:(Curl.handle -> unit)
  -> [`HTTP | `HTTPS]
  -> Oauth.t 
  -> Http.meth 
  -> string (* host name *)
  -> string (* path *) 
  -> (string * string) list (* GET/POST parameters *)
  -> [> `Error of [> `Http of int * string ] 
     |  `Ok of string ]

