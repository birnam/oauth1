package com.davidwoods.oauth1.helpers
{
	import flash.filesystem.File;
	import flash.utils.ByteArray;

	public interface IOAuth10Helper
	{
		function get REQUEST_TOKEN():String;
		function get ACCESS_TOKEN():String;
		function get identityStorage():File;
		
		function encrypt(bytes:ByteArray):void;
		function decrypt(bytes:ByteArray):void;
		function encodeVars(item:*, index:int, array:Array):*;
		function buildByteArray(str:String):ByteArray;
		function buildSortedString(v:Array):String;
		function getSortedArray(v:Array):String;
		function getNonce():String;
		function getQueryVariables(str:String):Object;
		function getSignature(url:String, data:Array = null, key:ByteArray = null, method:String = "POST"):String;
		function getTimestamp():String;
	}
}