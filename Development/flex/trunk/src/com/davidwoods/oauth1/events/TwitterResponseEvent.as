package com.davidwoods.oauth1.events
{
	import flash.events.Event;
	
	public class TwitterResponseEvent extends Event
	{
		public static const GENERIC_RESPONSE:String = "com.davidwoods.oauth1.commands.GENERIC_RESPONSE";
		
		public var data:String;
		public var apirequest:String;
		public var redirect:String;
		
		public function TwitterResponseEvent(type:String, api:String='', returndata:String='', redirecturl:String = "", bubbles:Boolean=false, cancelable:Boolean=false)
		{
			apirequest = api;
			data = returndata;
			redirect = redirecturl;
			
			super(type, bubbles, cancelable);
		}
	}
}