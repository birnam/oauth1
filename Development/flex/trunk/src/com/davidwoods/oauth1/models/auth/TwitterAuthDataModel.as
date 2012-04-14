package com.davidwoods.oauth1.models.auth
{	
	import org.robotlegs.mvcs.Actor;
	
	public class TwitterAuthDataModel extends Actor implements ITwitterAuthDataModel
	{	
		private var _oauth_token:String = "";
		public function get oauth_token():String { return _oauth_token; }
		public function set oauth_token(value:String):void { _oauth_token = value; }
		
		private var _oauth_token_secret:String = "";
		public function get oauth_token_secret():String { return _oauth_token_secret; }
		public function set oauth_token_secret(value:String):void { _oauth_token_secret = value; }
		
		private var _oauth_verifier:String = "";
		public function get oauth_verifier():String { return _oauth_verifier; }
		public function set oauth_verifier(value:String):void { _oauth_verifier = value; }
		
		private var _user_id:String = "";
		public function get user_id():String { return _user_id; }
		public function set user_id(value:String):void { _user_id = value; }
		
		private var _screen_name:String = "";
		public function get screen_name():String { return _screen_name; }
		public function set screen_name(value:String):void { _screen_name = value; }
		
		public function get ready():Boolean {
			if (toQueryString() != "") {
				return true;
			} else {
				return false;
			}
		}
		
		public function TwitterAuthDataModel() {
			super();
		}
		
		public function readVars(str:String):void {
			var pairs:Array = str.split('&');
			for each (var s:String in pairs) {
				var pair:Array = s.split('=');
				if (pair.length == 2) {
					switch (decodeURIComponent(pair[0])) {
						case "oauth_token":
							oauth_token = decodeURIComponent(pair[1]);
							break;
						case "oauth_token_secret":
							oauth_token_secret = decodeURIComponent(pair[1]);
							break;
						case "oauth_verifier":
							oauth_verifier = decodeURIComponent(pair[1]);
							break;
						case "user_id":
							user_id = decodeURIComponent(pair[1]);
							break;
						case "screen_name":
							screen_name = decodeURIComponent(pair[1]);
							break;
					}
				}
			}
		}
		
		public function toString():String {
			var sar:Array = new Array();
			if (oauth_token != "") {
				sar.push("oauth_token: " + oauth_token);
			}
			if (oauth_token_secret != "") {
				sar.push("oauth_token_secret: " + oauth_token_secret);
			}
			if (oauth_verifier != "") {
				sar.push("oauth_verifier: " + oauth_verifier);
			}
			if (user_id != "") {
				sar.push("user_id: " + user_id);
			}
			if (screen_name != "") {
				sar.push("screen_name: " + screen_name);
			}
			return sar.join("\n");
		}
		
		public function toQueryString():String {
			var sar:Array = new Array();
			if (oauth_token != "") {
				sar.push("oauth_token=" + encodeURIComponent(oauth_token));
			}
			if (oauth_token_secret != "") {
				sar.push("oauth_token_secret=" + encodeURIComponent(oauth_token_secret));
			}
			if (oauth_verifier != "") {
				sar.push("oauth_verifier=" + encodeURIComponent(oauth_verifier));
			}
			if (user_id != "") {
				sar.push("user_id=" + encodeURIComponent(user_id));
			}
			if (screen_name != "") {
				sar.push("screen_name=" + encodeURIComponent(screen_name));
			}
			return sar.join("&");
		}
		
		public function clear():void {
			oauth_token = "";
			oauth_token_secret = "";
			oauth_verifier = "";
			user_id = "";
			screen_name = "";
		}
	}
}