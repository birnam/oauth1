package com.davidwoods.oauth1.helpers
{
	import com.hurlant.crypto.Crypto;
	import com.hurlant.crypto.hash.HMAC;
	import com.hurlant.crypto.symmetric.ICipher;
	import com.hurlant.util.Base64;
	import com.hurlant.util.Hex;

	import flash.filesystem.File;
	import flash.utils.ByteArray;
	
	import org.robotlegs.mvcs.Actor;

	public class OAuth10Helper extends Actor implements IOAuth10Helper
	{
        [Inject] public var api:IOAuth10API;

        public function get ACCESS_TOKEN():String { return api.baseurl_https + "oauth/request_token"; }
        public function get REQUEST_TOKEN():String { return api.baseurl_https + "oauth/access_token"; }

		public function get identityStorage():File {
			var stordir:File = File.applicationStorageDirectory;
			
			if (stordir && stordir.exists) {
				return stordir.resolvePath(".datarc");
			} else {
				return null;
			}
		}

		public function OAuth10Helper() {
		}
		
		public function encrypt(bytes:ByteArray):void {
			var cipher:ICipher = Crypto.getCipher("des-ecb", Hex.toArray(api.consumer_key));
			cipher.encrypt(bytes);
		}
		
		public function decrypt(bytes:ByteArray):void {
			var cipher:ICipher = Crypto.getCipher("des-ecb", Hex.toArray(api.consumer_key));
			cipher.decrypt(bytes);
		}
		
		public function encodeVars(item:*, index:int, array:Array):* {
			if (item.value) {
				item.value = encodeURIComponent(item.value as String);
				
				// some characters aren't encoded with encodeURIComponent!
				item.value = (item.value as String).replace(/\!/g, '%21');
				item.value = (item.value as String).replace(/\*/g, '%2A');
				item.value = (item.value as String).replace(/\'/g, '%27');
				item.value = (item.value as String).replace(/\(/g, '%28');
				item.value = (item.value as String).replace(/\)/g, '%29');
				item.value = (item.value as String).replace(/;/g,  '%3B');
				item.value = (item.value as String).replace(/\[/g, '%5B');
				item.value = (item.value as String).replace(/\]/g, '%5D');
				
				// but commas *shouldn't* be
				item.value = (item.value as String).replace(/%2C/g, ',');
			}
			return item;
		}
		
		public function buildByteArray(str:String):ByteArray {
			return Hex.toArray( Hex.fromString( str ) );
		}
		
		public function buildSortedString(v:Array):String {
			var result:String = "";
			v.sortOn("name");
			for each (var o:Object in v) {
				if (result.length > 0) result += "&";
				result += o.name + "=" + o.value;
			}
			return result;
		}
		
		public function getSortedArray(v:Array):String {
			var a:Array = new Array();
			var result:String = "";
			for (var s:String in v) {
				a.push({name: s, value: v[s]});
			}
			a.sortOn("name");
			for each (var o:Object in a) {
				if (result.length > 0) result += "&";
				result += o.name + "=" + o.value;
			}
			return result;
		}
		
		public function getNonce():String {
			var t:String = getTimestamp();
			var s:String = "360FlexRocks!!" + t;
			return s;
		}
		
		public function getQueryVariables(str:String):Object {
			var queryVars:Object = new Object();
			var variablePairs:Array = str.split('&');
			for each (var s:String in variablePairs) {
				var pair:Array = s.split('=');
				if (pair.length == 2) {
					queryVars[decodeURIComponent(pair[0])] = decodeURIComponent(pair[1]);
				}
			}
			return queryVars;
		}
		
		public function getSignature(url:String, data:Array = null, key:ByteArray = null, method:String = "POST"):String {
			var tosign:String = method + "&" + encodeURIComponent(url) + "&" + encodeURIComponent(buildSortedString(data));
			var hmac:HMAC = Crypto.getHMAC("sha1");
			var msg:ByteArray = buildByteArray( tosign );
			return encodeURIComponent( Base64.encodeByteArray( hmac.compute( key, msg ) ) );
		}
		
		public function getTimestamp():String {
			var d:Date = new Date();
			var n:Number = Math.round(d.time / 1000);
			return n.toString();
		}
	}
}