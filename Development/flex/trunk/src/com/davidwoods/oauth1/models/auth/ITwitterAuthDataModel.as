package com.davidwoods.oauth1.models.auth
{
	public interface ITwitterAuthDataModel extends IOAuth10DataModel
	{
		function get user_id():String;
		function set user_id(value:String):void;
		function get screen_name():String;		
		function set screen_name(value:String):void;		
		function get ready():Boolean;
	}
}