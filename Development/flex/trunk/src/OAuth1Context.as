package {
import com.davidwoods.oauth1.commands.TwitterRequestCommand;
import com.davidwoods.oauth1.commands.TwitterResponseCommand;
import com.davidwoods.oauth1.commands.auth.InitAuthorizationCommand;
import com.davidwoods.oauth1.commands.auth.RequestAccessTokenCommand;
import com.davidwoods.oauth1.commands.auth.RequestRequestTokenCommand;
import com.davidwoods.oauth1.events.AuthorizationEvent;
import com.davidwoods.oauth1.events.TwitterRequestEvent;
import com.davidwoods.oauth1.events.TwitterResponseEvent;
import com.davidwoods.oauth1.helpers.IOAuth10API;
import com.davidwoods.oauth1.helpers.IOAuth10Helper;
import com.davidwoods.oauth1.helpers.TwitterAPI;
import com.davidwoods.oauth1.helpers.OAuth10Helper;
import com.davidwoods.oauth1.services.auth.ITwitterAuthService;
import com.davidwoods.oauth1.services.auth.TwitterAuthService;
import com.palebluedotstudio.social.twhoop.commands.file.ClearUserTokenCommand;
import com.palebluedotstudio.social.twhoop.commands.file.LoadUserTokenCommand;
import com.palebluedotstudio.social.twhoop.commands.file.SaveUserTokenCommand;
import com.palebluedotstudio.social.twhoop.events.ui.TwhoopMainEvent;

import flash.display.DisplayObjectContainer;

import org.robotlegs.mvcs.Context;

public class OAuth1Context extends Context {
    public function OAuth1Context(contextView:DisplayObjectContainer=null, autoStartup:Boolean=true) {
        super(contextView, autoStartup);
    }

    override public function startup():void {
        // services
        injector.mapSingletonOf(ITwitterAuthService, TwitterAuthService);

        // helpers
        injector.mapSingletonOf(IOAuth10API, TwitterAPI);
        injector.mapSingletonOf(IOAuth10Helper, OAuth10Helper);
//        injector.mapSingleton(TwitterAPIPaths);

        // commands
        commandMap.mapEvent(TwhoopMainEvent.READY_TO_AUTHORIZE, InitAuthorizationCommand);
        commandMap.mapEvent(AuthorizationEvent.FILE_LOAD_TOKEN, LoadUserTokenCommand);
        commandMap.mapEvent(AuthorizationEvent.FILE_SAVE_TOKEN, SaveUserTokenCommand);
        commandMap.mapEvent(AuthorizationEvent.FILE_CLEAR_TOKEN, ClearUserTokenCommand);
        commandMap.mapEvent(AuthorizationEvent.AUTHORIZATION_REQUEST_REQUEST_TOKEN, RequestRequestTokenCommand);
        commandMap.mapEvent(AuthorizationEvent.AUTHORIZATION_REQUEST_ACCESS_TOKEN, RequestAccessTokenCommand);

        // api commands
        //		other
        commandMap.mapEvent(TwitterRequestEvent.GENERIC_REQUEST, TwitterRequestCommand);
        commandMap.mapEvent(TwitterResponseEvent.GENERIC_RESPONSE, TwitterResponseCommand);
    }
}
}
