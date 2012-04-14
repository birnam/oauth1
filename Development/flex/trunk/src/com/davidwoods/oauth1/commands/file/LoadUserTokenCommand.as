package com.davidwoods.oauth1.commands.file
{
    import com.davidwoods.oauth1.events.AuthorizationEvent;
    import com.davidwoods.oauth1.helpers.IOAuth10Helper;
    import com.davidwoods.oauth1.models.auth.IOAuth10DataModel;

	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import org.robotlegs.mvcs.Command;
	
	public class LoadUserTokenCommand extends Command
	{
		[Inject] public var authData:IOAuth10DataModel;
		[Inject] public var helper:IOAuth10Helper;
		
		override public function execute():void {
			if (helper.identityStorage && helper.identityStorage.exists) {
				var fileBytes:ByteArray = new ByteArray();
				var fileStream:FileStream = new FileStream();
				
				fileStream.open(helper.identityStorage, FileMode.READ);
				fileStream.readBytes(fileBytes);
				fileStream.close();
				helper.decrypt(fileBytes);
				
				authData.readVars(fileBytes.toString());
				
				dispatch(new AuthorizationEvent(AuthorizationEvent.DATA_COMPLETE));
			} else {
				dispatch(new AuthorizationEvent(AuthorizationEvent.FILE_TOKEN_LOAD_FAILED));
			}
		}

	}
}