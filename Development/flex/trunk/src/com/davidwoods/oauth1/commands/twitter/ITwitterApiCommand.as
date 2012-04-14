package com.davidwoods.oauth1.commands.twitter
{
	public interface ITwitterApiCommand
	{
		function get api_id():String;
		function get url():String;
		function get method():String;
		function get result_type():String;
		function get vars():Array;
	}
}