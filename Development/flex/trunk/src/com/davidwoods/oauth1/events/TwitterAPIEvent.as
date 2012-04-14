package com.davidwoods.oauth1.events
{
	import flash.events.Event;
	
	public class TwitterAPIEvent extends Event
	{
		public static const TWITTER_DATA:String = "com.davidwoods.oauth1.events.TWITTER_DATA";		public static const ERROR:String = "com.davidwoods.oauth1.events.ERROR";
		public static const IO_ERROR:String = "com.davidwoods.oauth1.events.IO_ERROR";
		public static const SECURITY_ERROR:String = "com.davidwoods.oauth1.events.SECURITY_ERROR";

		// twitter error messages
		/**************************************
		 * From Twitter API Wiki
		 * http://apiwiki.twitter.com/w/page/22554652/HTTP-Response-Codes-and-Errors
		 * 
		 * HTTP Status Codes
		 * The Twitter API attempts to return appropriate HTTP status codes for every request. It is possible to surpress response codes for the REST API.
		 *  
		 * 200 OK: Success!
		 * 304 Not Modified: There was no new data to return.
		 * 400 Bad Request: The request was invalid.  An accompanying error message will explain why. This is the status code will be returned during rate limiting.
		 * 401 Unauthorized: Authentication credentials were missing or incorrect.
		 * 403 Forbidden: The request is understood, but it has been refused.  An accompanying error message will explain why. This code is used when requests are being denied due to update limits.
		 * 404 Not Found: The URI requested is invalid or the resource requested, such as a user, does not exists.
		 * 406 Not Acceptable: Returned by the Search API when an invalid format is specified in the request.
		 * 420 Enhance Your Calm: Returned by the Search and Trends API  when you are being rate limited.
		 * 500 Internal Server Error: Something is broken.  Please post to the group so the Twitter team can investigate.
		 * 502 Bad Gateway: Twitter is down or being upgraded.
		 * 503 Service Unavailable: The Twitter servers are up, but overloaded with requests. Try again later.
		 * 
		 * **************************************/
		
		public static const STATUS_SUCCESS:String = "200";
		public static const STATUS_REDIRECT_PERMANENT:String = "301";
		public static const STATUS_REDIRECT:String = "302";
		public static const STATUS_NOT_MODIFIED:String = "304";
		public static const STATUS_BAD_REQUEST:String = "400";
		public static const STATUS_UNAUTHORIZED:String = "401";
		public static const STATUS_FORBIDDEN:String = "403";
		public static const STATUS_NOT_FOUND:String = "404";
		public static const STATUS_NOT_ACCEPTABLE:String = "406";
		public static const STATUS_ENHANCE_YOUR_CALM:String = "420";
		public static const STATUS_INTERNAL_SERVER_ERROR:String = "500";
		public static const STATUS_BAD_GATEWAY:String = "502";
		public static const STATUS_SERVICE_UNAVAILABLE:String = "503";
		public static const STATUS_UNKNOWN_RESULT:String = "unknown result";
		
		public var returndata:String;
		
		public function TwitterAPIEvent(type:String, data:String='', bubbles:Boolean=false, cancelable:Boolean=false)
		{
			returndata = data;
			super(type, bubbles, cancelable);
		}
	}
}