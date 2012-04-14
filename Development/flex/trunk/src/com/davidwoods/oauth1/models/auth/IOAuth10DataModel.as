package com.davidwoods.oauth1.models.auth
{
	public interface IOAuth10DataModel
	{
		function get oauth_token():String;
		function set oauth_token(value:String):void;
		function get oauth_token_secret():String;
		function set oauth_token_secret(value:String):void;
		function get oauth_verifier():String;
		function set oauth_verifier(value:String):void;
		
		function readVars(str:String):void;
		function toString():String;
		function toQueryString():String;
		function clear():void;
	}
}