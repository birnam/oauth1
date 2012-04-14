package com.davidwoods.oauth1.events
{
	import flash.events.Event;
	
	public class TwitterAPIResultEvent extends Event
	{
		public static const RECEIVE:String = "com.davidwoods.oauth1.events.TwitterAPIResultEvent.RECEIVE";
		
		public var result:String;
		
		public function TwitterAPIResultEvent(type:String, s:String='', bubbles:Boolean=false, cancelable:Boolean=false){
			result = s;
			super(type, bubbles, cancelable);
		}
	}
}