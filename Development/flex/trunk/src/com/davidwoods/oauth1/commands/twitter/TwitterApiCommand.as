package com.davidwoods.oauth1.commands.twitter
{
	import com.davidwoods.oauth1.helpers.*;
	import com.davidwoods.oauth1.paths.TwitterAPIPaths;
	
	import org.robotlegs.mvcs.Command;
	
	public class TwitterApiCommand extends Command {
		[Inject] public var api:IOAuth10API;
		[Inject] public var paths:TwitterAPIPaths;
		
		public function get api_id():String { return ""; }
		public function get url():String { return api.baseurl; }
		public function get method():String { return "POST"; }
		public function get result_type():String { return "." + api.resultType; }
		
		private var _vars:Array = new Array();
		public function get vars():Array { return _vars; }
		public function set vars(value:Array):void { _vars = value; }
	}
}