package com.palebluedotstudio.social.twhoop.events.ui
{
	import flash.events.Event;
	
	public class TwhoopMainEvent extends Event
	{
		static public const CHANGE_VIEW:String = "com.palebluedotstudio.social.twhoop.events.ui.CHANGE_VIEW";
		static public const READY_TO_AUTHORIZE:String = "com.palebluedotstudio.social.twhoop.events.ui.READY_TO_AUTHORIZE";
		
		public var viewname:String;
		
		public function TwhoopMainEvent(type:String, view:String="", bubbles:Boolean=false, cancelable:Boolean=false) {
			viewname = view;
			super(type, bubbles, cancelable);
		}
	}
}