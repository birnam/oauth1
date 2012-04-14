package com.davidwoods.oauth1.mediators.auth
{
	import com.greensock.TweenLite;
	import com.davidwoods.oauth1.events.AuthorizationEvent;
	import com.davidwoods.oauth1.events.TwitterAPIEvent;
	import com.davidwoods.oauth1.events.ui.TwhoopErrorMessageEvent;
	import com.davidwoods.oauth1.events.ui.TwhoopMainEvent;
	import com.davidwoods.oauth1.models.auth.ITwitterAuthDataModel;
	import com.davidwoods.oauth1.models.auth.TwitterAuthDataModel;
	import com.davidwoods.oauth1.popups.ErrorMessagePopupView;
	import com.davidwoods.oauth1.services.auth.ITwitterAuthService;
	import com.davidwoods.oauth1.services.auth.TwitterAuthService;
	import com.davidwoods.oauth1.views.TwhoopMainView;
	
	import flash.events.Event;
	
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;
	import mx.managers.SystemManager;
	
	import org.robotlegs.base.CommandMap;
	import org.robotlegs.core.IMediator;
	import org.robotlegs.mvcs.Mediator;
	
	import spark.events.PopUpEvent;
	
	public class TwhoopMainMediator extends Mediator implements IMediator
	{
		[Inject] public var twauth:ITwitterAuthService;
		[Inject] public var view:TwhoopMainView;
		[Inject] public var twhoopdata:ITwitterAuthDataModel;
		
		public function TwhoopMainMediator() {
		}
		
		override public function onRegister():void {
			super.onRegister();
			addContextListener(TwhoopMainEvent.CHANGE_VIEW, onChangeView);
			addContextListener(TwhoopErrorMessageEvent.SHOW_ERROR_MESSAGE, onShowErrorMessage);
			TweenLite.delayedCall(0.5, leaveSplash);
		}
		
		protected function onChangeView(event:TwhoopMainEvent):void {
			view.currentState = event.viewname;
		}
		
		protected function leaveSplash():void {
			dispatch(new TwhoopMainEvent(TwhoopMainEvent.READY_TO_AUTHORIZE));
		}
		
		protected function onShowErrorMessage(event:TwhoopErrorMessageEvent):void {
			var errorWindow:ErrorMessagePopupView = PopUpManager.createPopUp(view, ErrorMessagePopupView, true) as ErrorMessagePopupView;
			mediatorMap.createMediator(errorWindow);
			eventMap.mapListener(eventDispatcher, TwhoopErrorMessageEvent.ERROR_CONTINUE, onShowErrorMessageContinue, TwhoopErrorMessageEvent);
			errorWindow.messagetext = event.status + ": " + event.message;
			errorWindow.errortype = event.status;
			PopUpManager.centerPopUp(errorWindow);
		}
		
		protected function onShowErrorMessageContinue(event:TwhoopErrorMessageEvent):void {
			eventMap.unmapListener(eventDispatcher, TwhoopErrorMessageEvent.ERROR_CONTINUE, onShowErrorMessageContinue, TwhoopErrorMessageEvent);
			
			if (event.status == TwitterAPIEvent.STATUS_UNAUTHORIZED) {
				eventMap.mapListener(eventDispatcher, AuthorizationEvent.FILE_TOKEN_CLEARED, onTokenCleared, AuthorizationEvent);
				dispatch(new AuthorizationEvent(AuthorizationEvent.FILE_CLEAR_TOKEN));
			}
		}
		
		protected function onTokenCleared(event:AuthorizationEvent):void {
			eventMap.unmapListener(eventDispatcher, AuthorizationEvent.FILE_TOKEN_CLEARED, onTokenCleared, AuthorizationEvent);
			dispatch(new TwhoopMainEvent(TwhoopMainEvent.READY_TO_AUTHORIZE));
		}
	}
}