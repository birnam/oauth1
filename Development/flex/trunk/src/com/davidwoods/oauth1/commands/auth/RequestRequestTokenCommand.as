package com.davidwoods.oauth1.commands.auth
{
	import com.davidwoods.oauth1.commands.twitter.ITwitterApiCommand;
	import com.davidwoods.oauth1.events.AuthorizationEvent;
	import com.davidwoods.oauth1.helpers.*;
	import com.davidwoods.oauth1.models.auth.ITwitterAuthDataModel;
	import com.davidwoods.oauth1.paths.TwitterAPIPaths;
	import com.davidwoods.oauth1.paths.TwitterAPIPaths_OAuth;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.navigateToURL;
	import flash.utils.ByteArray;
	
	import org.robotlegs.mvcs.Command;
	
	public class RequestRequestTokenCommand extends Command
	{	
		private var acquireRequestToken:URLRequest;
		private var acquireRequestTokenLoader:URLLoader;
		
		[Inject] public var helper:IOAuth10Helper;
		[Inject] public var twhoopdata:ITwitterAuthDataModel;
		[Inject] public var api:IOAuth10API;
		[Inject] public var paths:TwitterAPIPaths;
		
		override public function execute():void {
			acquireRequestToken = new URLRequest(helper.REQUEST_TOKEN);
			acquireRequestToken.method = URLRequestMethod.POST;
			
			var nonce:String = helper.getNonce();
			
			var v:Array = [];
			v.push({name: "oauth_callback", value: "oob"});
			v.push({name: "oauth_consumer_key", value: api.consumer_key});
			v.push({name: "oauth_nonce", value: nonce});
			v.push({name: "oauth_signature_method", value: "HMAC-SHA1"});
			v.push({name: "oauth_timestamp", value: helper.getTimestamp()});
			v.push({name: "oauth_version", value: "1.0"});
			
			var key:ByteArray = helper.buildByteArray( encodeURIComponent( api.consumer_secret ) + "&" );
			var signer:String = helper.getSignature( helper.REQUEST_TOKEN, v, key );
			
			acquireRequestToken.data = helper.buildSortedString(v) + "&oauth_signature=" + signer;
			acquireRequestTokenLoader = new URLLoader();
			acquireRequestTokenLoader.addEventListener(Event.COMPLETE, onAcquireRequestTokenLoaded);
			acquireRequestTokenLoader.addEventListener(IOErrorEvent.IO_ERROR, onAcquireRequestTokenIOError);
			acquireRequestTokenLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onAcquireRequestTokenSecurityError);
			acquireRequestTokenLoader.load(acquireRequestToken);
		}
		
		private function onAcquireRequestTokenLoaded(event:Event):void {
			if (acquireRequestTokenLoader.data == null || typeof(acquireRequestTokenLoader) == 'undefined') return;
			
			var data:String = acquireRequestTokenLoader.data.toString();
			if (data == null || typeof(data) == 'undefined') {
				trace("return error when requesting requesttoken: data is undefined");
				return;
			}
			acquireRequestTokenLoader.removeEventListener(Event.COMPLETE, onAcquireRequestTokenLoaded);
			twhoopdata.readVars(acquireRequestTokenLoader.data);
			
			initUserAuthentication();
		}
		
		private function onAcquireRequestTokenIOError(event:IOErrorEvent):void {
			trace("ioerror when requesting requesttoken: " + event.text);
		}
		
		private function onAcquireRequestTokenSecurityError(event:SecurityErrorEvent):void {
			trace("securityerror when requesting requesttoken: " + event.text);
		}
		
		private function initUserAuthentication():void {
			dispatch(new AuthorizationEvent(AuthorizationEvent.AUTHORIZATION_ENTER_PIN));
			if (twhoopdata && twhoopdata.oauth_token != "") {
				navigateToURL(new URLRequest(api.baseurl_https + paths.OAuth.Authorize + "?oauth_token=" + encodeURIComponent(twhoopdata.oauth_token)));
			}
		}
	}
}