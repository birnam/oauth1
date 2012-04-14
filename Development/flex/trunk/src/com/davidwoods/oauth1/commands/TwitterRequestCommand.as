package com.davidwoods.oauth1.commands
{
//	import com.davidwoods.oauth1.commands.twitter.users.UsersSearchCommand;
//	import com.davidwoods.oauth1.commands.twitter.users.UsersSearchResultCommand;
	import com.davidwoods.oauth1.events.TwitterAPIEvent;
	import com.davidwoods.oauth1.events.TwitterAPIResultEvent;
	import com.davidwoods.oauth1.events.TwitterRequestEvent;
	import com.davidwoods.oauth1.events.TwitterResponseEvent;
//	import com.davidwoods.oauth1.events.twitter.users.UsersSearchEvent;
//	import com.davidwoods.oauth1.events.ui.TwhoopErrorMessageEvent;
	import com.davidwoods.oauth1.helpers.IOAuth10API;
	import com.davidwoods.oauth1.helpers.IOAuth10Helper;
	import com.davidwoods.oauth1.models.auth.ITwitterAuthDataModel;
//	import com.davidwoods.oauth1.paths.TwitterAPIPaths;
	
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;
	
	import org.robotlegs.mvcs.Command;
	
	public class TwitterRequestCommand extends Command
	{
		[Inject] public var event:TwitterRequestEvent;
		[Inject] public var helper:IOAuth10Helper;
		[Inject] public var twhoopdata:ITwitterAuthDataModel;
		[Inject] public var api:IOAuth10API;
//		[Inject] public var paths:TwitterAPIPaths;
		
		private var twitterRequest:URLRequest;
		private var twitterRequestLoader:URLLoader;
		
		override public function execute():void {
			twitterRequest = new URLRequest(event.url);
			switch (event.method.toUpperCase()) {
				case "GET":
					twitterRequest.method = URLRequestMethod.GET;
					break;
				case "POST":
				default:
					twitterRequest.method = URLRequestMethod.POST;
					break;
			}
			
			var nonce:String = helper.getNonce();
			
			var v:Array = [];
			v = v.concat(event.vars.map(helper.encodeVars));
			v.push({name: "oauth_consumer_key", value: api.consumer_key});
			v.push({name: "oauth_nonce", value: nonce});
			v.push({name: "oauth_signature_method", value: "HMAC-SHA1"});
			v.push({name: "oauth_token", value: twhoopdata.oauth_token});
			v.push({name: "oauth_timestamp", value: helper.getTimestamp()});
			v.push({name: "oauth_version", value: "1.0"});
			
			var key:ByteArray = helper.buildByteArray( encodeURIComponent( api.consumer_secret ) + "&" + encodeURIComponent( twhoopdata.oauth_token_secret ) );
			var signer:String = helper.getSignature( event.url, v, key, event.method );
			
			twitterRequest.data = helper.buildSortedString(v) + "&oauth_signature=" + signer;
			twitterRequestLoader = new URLLoader();
			twitterRequestLoader.addEventListener(Event.COMPLETE, onTwitterRequestLoaded);
//			twitterRequestLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHttpStatus);
			twitterRequestLoader.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, onHttpStatus);
			twitterRequestLoader.addEventListener(IOErrorEvent.IO_ERROR, onTwitterRequestIOError);
			twitterRequestLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onTwitterRequestSecurityError);
			twitterRequestLoader.load(twitterRequest);
		}
		
		private function onTwitterRequestLoaded(e:Event):void {
			if (twitterRequestLoader.data == null || typeof(twitterRequestLoader) == 'undefined') return;
			
			var data:String = twitterRequestLoader.data.toString();
			if (data == null || typeof(data) == 'undefined') {
				trace("return error when requesting accesstoken: data is undefined");
				return;
			}
			
			dispatch(new TwitterResponseEvent(TwitterResponseEvent.GENERIC_RESPONSE, event.apirequest, data, event.redirect));
		}
		
		private function onTwitterRequestIOError(e:IOErrorEvent):void {
			var errorcontents:XML = new XML(twitterRequestLoader.data);
			dispatch(new TwitterAPIEvent(TwitterAPIEvent.IO_ERROR, errorcontents));
		}
		
		private function onTwitterRequestSecurityError(e:SecurityErrorEvent):void {
			var errorcontents:XML = new XML(twitterRequestLoader.data);
			dispatch(new TwitterAPIEvent(TwitterAPIEvent.SECURITY_ERROR, errorcontents));
		}
		
		private function onHttpStatus(e:HTTPStatusEvent):void {
			switch(e.status.toString()) {
				case TwitterAPIEvent.STATUS_SUCCESS:
					event.redirect = e.responseURL;
					break;
				case TwitterAPIEvent.STATUS_REDIRECT_PERMANENT:
				case TwitterAPIEvent.STATUS_REDIRECT:
//					var ra:Array = [];
//					for (var s:String in e.responseHeaders) {
//						ra.push(s + ': ' + e.responseHeaders[s]);
//					}
//					dispatch(new TwitterResponseEvent(TwitterResponseEvent.GENERIC_RESPONSE, event.apirequest, ra.join("\n")));
//					dispatch(new TwitterRequestEvent(TwitterRequestEvent.GENERIC_REQUEST, event.apirequest, e.lo, null, "GET");
					break;
				case TwitterAPIEvent.STATUS_NOT_MODIFIED:
					break;
//				case TwitterAPIEvent.STATUS_BAD_REQUEST:
//					dispatch(new TwhoopErrorMessageEvent(TwhoopErrorMessageEvent.SHOW_ERROR_MESSAGE, e.status.toString(), "Twitter service is reporting a Bad Request. Please try again."));
//					break;
//				case TwitterAPIEvent.STATUS_UNAUTHORIZED:
//					dispatch(new TwhoopErrorMessageEvent(TwhoopErrorMessageEvent.SHOW_ERROR_MESSAGE, e.status.toString(), "You have not authorized Twhoop or authorization has been revoked. Please re-authorize."));
//					break;
//				case TwitterAPIEvent.STATUS_FORBIDDEN:
//					dispatch(new TwhoopErrorMessageEvent(TwhoopErrorMessageEvent.SHOW_ERROR_MESSAGE, e.status.toString(), "Twitter service has forbidden that request. Please try again later."));
//					break;
//				case TwitterAPIEvent.STATUS_NOT_FOUND:
//					dispatch(new TwhoopErrorMessageEvent(TwhoopErrorMessageEvent.SHOW_ERROR_MESSAGE, e.status.toString(), "Twitter service not found! Please try again later."));
//					break;
//				case TwitterAPIEvent.STATUS_NOT_ACCEPTABLE:
//					dispatch(new TwhoopErrorMessageEvent(TwhoopErrorMessageEvent.SHOW_ERROR_MESSAGE, e.status.toString(), "Twitter service found the request unacceptable."));
//					break;
//				case TwitterAPIEvent.STATUS_ENHANCE_YOUR_CALM:
//					dispatch(new TwhoopErrorMessageEvent(TwhoopErrorMessageEvent.SHOW_ERROR_MESSAGE, e.status.toString(), "Take a deep breath and relax. You're overusing the service."));
//					break;
//				case TwitterAPIEvent.STATUS_INTERNAL_SERVER_ERROR:
//					dispatch(new TwhoopErrorMessageEvent(TwhoopErrorMessageEvent.SHOW_ERROR_MESSAGE, e.status.toString(), "Internal Twitter Error. Please try again later."));
//					break;
//				case TwitterAPIEvent.STATUS_BAD_GATEWAY:
//					dispatch(new TwhoopErrorMessageEvent(TwhoopErrorMessageEvent.SHOW_ERROR_MESSAGE, e.status.toString(), "Twitter service is reporting a Bad Gateway. Please try again later."));
//					break;
//				case TwitterAPIEvent.STATUS_SERVICE_UNAVAILABLE:
//					dispatch(new TwhoopErrorMessageEvent(TwhoopErrorMessageEvent.SHOW_ERROR_MESSAGE, e.status.toString(), "Twitter service is unavailable. Please try again later."));
//					break;
//				case TwitterAPIEvent.STATUS_UNKNOWN_RESULT:
//				default:
//					dispatch(new TwhoopErrorMessageEvent(TwhoopErrorMessageEvent.SHOW_ERROR_MESSAGE, e.status.toString(), "An unknown error has occurred. Please try again."));
//					break;
			}
		}
	}
}