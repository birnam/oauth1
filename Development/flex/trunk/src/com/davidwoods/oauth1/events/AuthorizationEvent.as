package com.davidwoods.oauth1.events
{
	import com.davidwoods.oauth1.models.auth.TwitterAuthDataModel;
	
	import flash.events.Event;
	
	public class AuthorizationEvent extends Event
	{
		public static const AUTHORIZATION_REQUEST_REQUEST_TOKEN:String = "com.davidwoods.oauth1.events.AUTHORIZATION_REQUEST_REQUEST_TOKEN";
		public static const AUTHORIZATION_REQUEST_ACCESS_TOKEN:String = "com.davidwoods.oauth1.events.AUTHORIZATION_REQUEST_ACCESS_TOKEN";
		
		public static const FILE_LOAD_TOKEN:String = "com.davidwoods.oauth1.events.FILE_LOAD_TOKEN";
		public static const FILE_TOKEN_LOADED:String = "com.davidwoods.oauth1.events.FILE_TOKEN_LOADED";
		public static const FILE_TOKEN_LOAD_FAILED:String = "com.davidwoods.oauth1.events.FILE_TOKEN_LOAD_FAILED";
		public static const FILE_SAVE_TOKEN:String = "com.davidwoods.oauth1.events.FILE_SAVE_TOKEN";
		public static const FILE_CLEAR_TOKEN:String = "com.davidwoods.oauth1.events.FILE_CLEAR_TOKEN";
		public static const FILE_TOKEN_CLEARED:String = "com.davidwoods.oauth1.events.FILE_TOKEN_CLEARED";
		
		public static const AUTHORIZATION_ENTER_PIN:String = "com.davidwoods.oauth1.events.AUTHORIZATION_ENTER_PIN";
		public static const AUTHORIZATION_RECEIVED_PIN:String = "com.davidwoods.oauth1.events.AUTHORIZATION_RECEIVED_PIN";
		public static const DATA_COMPLETE:String = "com.davidwoods.oauth1.events.DATA_COMPLETE";
		
		public var pin:String;
		
		public function AuthorizationEvent(type:String, p:String="", bubbles:Boolean=false, cancelable:Boolean=false) {
			pin = p;
			super(type, bubbles, cancelable);
		}
	}
}