package com.davidwoods.oauth1.helpers
{
	public interface IOAuth10API {
		function get resultType():String;
		
		function get apiversion():String;
		function get base():String;
		
		function get baseurl():String;
		function get baseurl_https():String;
		
		function get apiurl():String;
		function get apiurl_https():String;
		
		function get consumer_key():String;
		function get consumer_secret():String;
	}
}