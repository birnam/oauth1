package com.davidwoods.oauth1.commands.file
{
	import com.davidwoods.oauth1.helpers.IOAuth10Helper;
    import com.davidwoods.oauth1.models.auth.IOAuth10DataModel;

	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import org.robotlegs.mvcs.Command;
	
	public class SaveUserTokenCommand extends Command
	{
		[Inject] public var authData:IOAuth10DataModel;
		[Inject] public var helper:IOAuth10Helper;
		
		override public function execute():void {
			if (!helper.identityStorage) {
				// error!!
				return;
			}
			
			var fileBytes:ByteArray = new ByteArray();
			var fileStream:FileStream = new FileStream();
			
			fileBytes = helper.buildByteArray(authData.toQueryString());
			helper.encrypt(fileBytes);
			fileStream.open(helper.identityStorage, FileMode.WRITE);
			fileStream.writeBytes(fileBytes);
			fileStream.close();
		}
	}
}