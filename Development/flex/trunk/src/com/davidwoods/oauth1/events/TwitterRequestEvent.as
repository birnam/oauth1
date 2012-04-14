package com.davidwoods.oauth1.events
{
	import flash.events.Event;
	
	public class TwitterRequestEvent extends Event
	{
		public static const GENERIC_REQUEST:String = "com.davidwoods.oauth1.commands.GENERIC_REQUEST";
		
		public var url:String;
		public var redirect:String;
		
		public var method:String;
		public var vars:Array;
		public var apirequest:String;
		
		public function TwitterRequestEvent(type:String, api:String='', request_url:String = "", request_vars:Array = null, request_method:String = "POST", bubbles:Boolean=false, cancelable:Boolean=false)
		{
			apirequest = api;
			url = request_url;
			method = request_method;
			vars = request_vars;
			
			super(type, bubbles, cancelable);
		}
	}
}