package com.davidwoods.oauth1.commands.auth
{
	import com.davidwoods.oauth1.services.auth.ITwitterAuthService;
	
	import org.robotlegs.mvcs.Command;
	
	public class InitAuthorizationCommand extends Command
	{
		[Inject] public var twauth:ITwitterAuthService;
		
		override public function execute():void {
			twauth.getAuthorization();
		}
	}
}