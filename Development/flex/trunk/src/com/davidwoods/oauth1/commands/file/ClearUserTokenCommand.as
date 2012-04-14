package com.palebluedotstudio.social.twhoop.commands.file
{
	import com.palebluedotstudio.social.twhoop.events.AuthorizationEvent;
	import com.palebluedotstudio.social.twhoop.helpers.ITwitterAuthHelper;
	import com.palebluedotstudio.social.twhoop.models.auth.ITwitterAuthDataModel;
	
	import org.robotlegs.mvcs.Command;
	
	public class ClearUserTokenCommand extends Command
	{
		[Inject] public var twhoopdata:ITwitterAuthDataModel;
		[Inject] public var helper:ITwitterAuthHelper;
		
		override public function execute():void {
			twhoopdata.clear();
			if (!helper.identityStorage || !helper.identityStorage.exists) {
				// error!!
				return;
			}
			helper.identityStorage.deleteFile();
			
			dispatch(new AuthorizationEvent(AuthorizationEvent.FILE_TOKEN_CLEARED));
		}
	}
}