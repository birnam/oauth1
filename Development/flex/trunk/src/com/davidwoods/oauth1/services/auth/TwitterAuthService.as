package com.davidwoods.oauth1.services.auth
{
	import com.davidwoods.oauth1.events.AuthorizationEvent;
	import com.davidwoods.oauth1.events.TwitterAPIEvent;
//	import com.davidwoods.oauth1.events.ui.TwhoopMainEvent;
	import com.davidwoods.oauth1.helpers.IOAuth10Helper;
	import com.davidwoods.oauth1.models.auth.ITwitterAuthDataModel;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.filesystem.File;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.navigateToURL;
	import flash.utils.ByteArray;
	
	import mx.states.AddChild;
	
	import org.robotlegs.mvcs.Actor;
	
	public class TwitterAuthService extends Actor implements ITwitterAuthService {
		
		[Inject] public var twhoopdata:ITwitterAuthDataModel;
		[Inject] public var helper:IOAuth10Helper;
		
		public function TwitterAuthService() {
			super();
		}
		
		public function getAuthorization():void {
			eventMap.mapListener(eventDispatcher, AuthorizationEvent.AUTHORIZATION_ENTER_PIN, onRequestPIN);
			eventMap.mapListener(eventDispatcher, AuthorizationEvent.DATA_COMPLETE, onAuthDataComplete);
			
			eventMap.mapListener(eventDispatcher, AuthorizationEvent.FILE_TOKEN_LOADED, onTokenLoaded);
			eventMap.mapListener(eventDispatcher, AuthorizationEvent.FILE_TOKEN_LOAD_FAILED, onTokenLoadFailed);
		
			dispatch(new AuthorizationEvent(AuthorizationEvent.FILE_LOAD_TOKEN));
		}
		
		protected function onTokenLoaded(event:AuthorizationEvent):void {
			dispatch(new AuthorizationEvent(AuthorizationEvent.AUTHORIZATION_REQUEST_ACCESS_TOKEN));
		}
		
		protected function onTokenLoadFailed(event:AuthorizationEvent):void {
			dispatch(new AuthorizationEvent(AuthorizationEvent.AUTHORIZATION_REQUEST_REQUEST_TOKEN));
		}
		
		protected function onRequestPIN(event:AuthorizationEvent):void {
			eventMap.mapListener(eventDispatcher, AuthorizationEvent.AUTHORIZATION_RECEIVED_PIN, onReceviedPIN, AuthorizationEvent);
//			dispatch(new TwhoopMainEvent(TwhoopMainEvent.CHANGE_VIEW, "pin"));
		}
		
		protected function onReceviedPIN(event:AuthorizationEvent):void {
			eventMap.unmapListener(eventDispatcher, AuthorizationEvent.AUTHORIZATION_RECEIVED_PIN, onReceviedPIN, AuthorizationEvent);
			dispatch(new AuthorizationEvent(AuthorizationEvent.AUTHORIZATION_REQUEST_ACCESS_TOKEN, event.pin));
		}
		
		protected function onAuthDataComplete(event:AuthorizationEvent):void {
			eventMap.unmapListener(eventDispatcher, AuthorizationEvent.AUTHORIZATION_ENTER_PIN, onRequestPIN);
			eventMap.unmapListener(eventDispatcher, AuthorizationEvent.DATA_COMPLETE, onAuthDataComplete);
			dispatch(new AuthorizationEvent(AuthorizationEvent.FILE_SAVE_TOKEN));
//			dispatch(new TwhoopMainEvent(TwhoopMainEvent.CHANGE_VIEW, "test"));
		}
	}
}