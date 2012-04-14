package com.davidwoods.oauth1.helpers
{
	public class TwitterAPI implements IOAuth10API
	{
		public function get resultType():String { return "json"; }
		
		public function get apiversion():String { return "1"; }
		public function get base():String { return "api.twitter.com/" ; }
		
		public function get baseurl():String { return "http://" + base ; }
		public function get baseurl_https():String { return "https://" + base; }
		
		public function get apiurl():String { return "http://" + base + apiversion + "/"; }
		public function get apiurl_https():String { return "https://" + base + apiversion + "/"; }
		
		public function get consumer_key():String { return "CONSUMERKEY"; }
		public function get consumer_secret():String { return "CONSUMERSECRET"; }
		
		public function TwitterAPI() {
		}
	}
}