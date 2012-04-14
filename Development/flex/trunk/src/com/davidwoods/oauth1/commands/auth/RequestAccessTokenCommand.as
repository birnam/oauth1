package com.davidwoods.oauth1.commands.auth
{
	import com.davidwoods.oauth1.commands.twitter.ITwitterApiCommand;
	import com.davidwoods.oauth1.events.AuthorizationEvent;
	import com.davidwoods.oauth1.helpers.*;
	import com.davidwoods.oauth1.models.auth.ITwitterAuthDataModel;
	import com.davidwoods.oauth1.paths.TwitterAPIPaths;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;
	
	import org.robotlegs.mvcs.Command;
	
	public class RequestAccessTokenCommand extends Command
	{
		[Inject] public var event:AuthorizationEvent;		
		[Inject] public var helper:IOAuth10Helper;
		[Inject] public var twhoopdata:ITwitterAuthDataModel;
		[Inject] public var api:IOAuth10API;
		[Inject] public var paths:TwitterAPIPaths;
		
		private var acquireAccessToken:URLRequest;
		private var acquireAccessTokenLoader:URLLoader;
		
		override public function execute():void {
			acquireAccessToken = new URLRequest(helper.ACCESS_TOKEN);
			acquireAccessToken.method = URLRequestMethod.POST;
			
			var nonce:String = helper.getNonce();
			
			var v:Array = [];
			v.push({name: "oauth_consumer_key", value: api.consumer_key});
			v.push({name: "oauth_nonce", value: nonce});
			v.push({name: "oauth_signature_method", value: "HMAC-SHA1"});
			v.push({name: "oauth_token", value: twhoopdata.oauth_token});
			v.push({name: "oauth_timestamp", value: helper.getTimestamp()});
			v.push({name: "oauth_verifier", value: event.pin});
			v.push({name: "oauth_version", value: "1.0"});
			
			var key:ByteArray = helper.buildByteArray( encodeURIComponent( api.consumer_secret ) + "&" + encodeURIComponent( twhoopdata.oauth_token_secret ) );
			var signer:String = helper.getSignature( helper.REQUEST_TOKEN, v, key );
			
			acquireAccessToken.data = helper.buildSortedString(v) + "&oauth_signature=" + signer;
			acquireAccessTokenLoader = new URLLoader();
			acquireAccessTokenLoader.addEventListener(Event.COMPLETE, onAcquireAccessTokenLoaded);
			acquireAccessTokenLoader.addEventListener(IOErrorEvent.IO_ERROR, onAcquireAccessTokenIOError);
			acquireAccessTokenLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onAcquireAccessTokenSecurityError);
			acquireAccessTokenLoader.load(acquireAccessToken);
		}
		
		private function onAcquireAccessTokenLoaded(event:Event):void {
			if (acquireAccessTokenLoader.data == null || typeof(acquireAccessTokenLoader) == 'undefined') return;
			
			var data:String = acquireAccessTokenLoader.data.toString();
			if (data == null || typeof(data) == 'undefined') {
				trace("return error when requesting accesstoken: data is undefined");
				return;
			}
			acquireAccessTokenLoader.removeEventListener(Event.COMPLETE, onAcquireAccessTokenLoaded);
			twhoopdata.readVars(data);
			
			if (twhoopdata.ready) {
				dispatch(new AuthorizationEvent(AuthorizationEvent.DATA_COMPLETE, ""));
			} else {
				// error!!
			}
		}
		
		private function onAcquireAccessTokenIOError(event:IOErrorEvent):void {
			trace("ioerror when requesting accesstoken: " + event.text);
		}
		
		private function onAcquireAccessTokenSecurityError(event:SecurityErrorEvent):void {
			trace("securityerror when requesting accesstoken: " + event.text);
		}
	}
}