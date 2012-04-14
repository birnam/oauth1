package com.davidwoods.oauth1.commands
{
//	import com.adobe.serialization.json.JSON;
	import com.davidwoods.oauth1.commands.twitter.users.UsersSearchCommand;
	import com.davidwoods.oauth1.commands.twitter.users.UsersSearchResultCommand;
	import com.davidwoods.oauth1.events.TwitterAPIEvent;
	import com.davidwoods.oauth1.events.TwitterAPIResultEvent;
	import com.davidwoods.oauth1.events.TwitterRequestEvent;
	import com.davidwoods.oauth1.events.TwitterResponseEvent;
	import com.davidwoods.oauth1.events.twitter.account.*;
	import com.davidwoods.oauth1.events.twitter.block.*;
	import com.davidwoods.oauth1.events.twitter.directmessages.*;
	import com.davidwoods.oauth1.events.twitter.favorites.*;
	import com.davidwoods.oauth1.events.twitter.friendsandfollowers.*;
	import com.davidwoods.oauth1.events.twitter.friendship.*;
	import com.davidwoods.oauth1.events.twitter.geo.*;
	import com.davidwoods.oauth1.events.twitter.help.*;
	import com.davidwoods.oauth1.events.twitter.legal.*;
	import com.davidwoods.oauth1.events.twitter.list.*;
	import com.davidwoods.oauth1.events.twitter.listmembers.*;
	import com.davidwoods.oauth1.events.twitter.listsubscribers.*;
	import com.davidwoods.oauth1.events.twitter.localtrends.*;
	import com.davidwoods.oauth1.events.twitter.notification.*;
	import com.davidwoods.oauth1.events.twitter.savedsearch.*;
	import com.davidwoods.oauth1.events.twitter.spamreporting.*;
	import com.davidwoods.oauth1.events.twitter.timeline.*;
	import com.davidwoods.oauth1.events.twitter.trends.*;
	import com.davidwoods.oauth1.events.twitter.tweets.*;
	import com.davidwoods.oauth1.events.twitter.users.*;
	import com.davidwoods.oauth1.events.ui.TwhoopErrorMessageEvent;
	import com.davidwoods.oauth1.helpers.IOAuth10API;
	import com.davidwoods.oauth1.helpers.IOAuth10Helper;
	import com.davidwoods.oauth1.models.auth.ITwitterAuthDataModel;
	import com.davidwoods.oauth1.models.twitter.account.*;
	import com.davidwoods.oauth1.models.twitter.block.*;
	import com.davidwoods.oauth1.models.twitter.directmessages.*;
	import com.davidwoods.oauth1.models.twitter.favorites.*;
	import com.davidwoods.oauth1.models.twitter.friendsandfollowers.*;
	import com.davidwoods.oauth1.models.twitter.geo.*;
	import com.davidwoods.oauth1.models.twitter.help.*;
	import com.davidwoods.oauth1.models.twitter.legal.*;
	import com.davidwoods.oauth1.models.twitter.savedsearch.*;
	import com.davidwoods.oauth1.models.twitter.spamreporting.*;
	import com.davidwoods.oauth1.models.twitter.timeline.*;
	import com.davidwoods.oauth1.models.twitter.users.*;
	import com.davidwoods.oauth1.paths.TwitterAPIPaths;
	import com.davidwoods.oauth1.structs.*;
	
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;
	
	import org.robotlegs.mvcs.Command;
	
	public class TwitterResponseCommand extends Command
	{
		[Inject] public var event:TwitterResponseEvent;
		[Inject] public var paths:TwitterAPIPaths;
		
		// account
		[Inject] public var accountRateLimitStatusResult:AccountRateLimitStatusResultModel;
		[Inject] public var accountTotalsResult:AccountTotalsResultModel;
		[Inject] public var accountSettingsResult:AccountSettingsResultModel;
		[Inject] public var accountVerifyCredentialsResult:AccountVerifyCredentialsResultModel;
		// blocks
		[Inject] public var blockBlockingResult:BlockBlockingResultModel;
		[Inject] public var blockBlockingIDsResult:BlockBlockingIDsResultModel;
		[Inject] public var blockExistsResult:BlockExistsResultModel;
		// directmessages
		[Inject] public var directmessagesDirectMessagesResult:DirectMessagesDirectMessagesResultModel;
		[Inject] public var directmessagesSentResult:DirectMessagesSentResultModel;
		// favorites
		[Inject] public var favoritesFavoritesResult:FavoritesFavoritesResultModel;
		// favorites
		[Inject] public var friendsandfollowersFriendsResult:FriendsAndFollowersFriendsResultModel;
		[Inject] public var friendsandfollowersFollowersResult:FriendsAndFollowersFollowersResultModel;
		// geo
		[Inject] public var geoPlaceIdResult:GeoPlaceIdResultModel;
		[Inject] public var geoPlaceResult:GeoPlaceResultModel;
		[Inject] public var geoReverseGeocodeResult:GeoReverseGeocodeResultModel;
		[Inject] public var geoSearchResult:GeoSearchResultModel;
		[Inject] public var geoSimilarPlacesResult:GeoSimilarPlacesResultModel;
		// help
		[Inject] public var helpTestResult:HelpTestModel;
		// legal
		[Inject] public var legalTosResult:LegalTosModel;
		[Inject] public var legalPrivacyResult:LegalPrivacyModel;
		// savedsearch
		[Inject] public var savedSearchSearchesResult:SavedSearchSearchesModel;
		[Inject] public var savedSearchResult:SavedSearchModel;
		// spamreporting
		[Inject] public var spamReportingReportSpamResult:SpamReportingReportSpamResultModel;
		// timeline
		[Inject] public var timelinePublicTimelineResult:TimelinePublicTimelineResultModel;
		[Inject] public var timelineUserTimelineResult:TimelineUserTimelineResultModel;
		[Inject] public var timelineHomeTimelineResult:TimelineHomeTimelineResultModel;
		[Inject] public var timelineMentionsResult:TimelineMentionsResultModel;
		[Inject] public var timelineRetweetedByMeResult:TimelineRetweetedByMeResultModel;
		[Inject] public var timelineRetweetedToMeResult:TimelineRetweetedToMeResultModel;
		[Inject] public var timelineRetweetsOfMeResult:TimelineRetweetsOfMeResultModel;
		// users
		[Inject] public var usersShowResult:UsersShowResultModel;
		[Inject] public var usersSearchResult:UsersSearchResultModel;
		[Inject] public var usersProfileIMageResult:UsersProfileImageResultModel;
		
		override public function execute():void {
			if (event.data == null || typeof(event.data) == 'undefined') {
				trace("response error: data is undefined for " + event.apirequest + " request");
				return;
			}

			var epass:TwitterAPIResultEvent;
			switch(event.apirequest) {
				/*
				 * USER
				 */
				case paths.User.Lookup:
					epass = new UsersLookupEvent(UsersLookupEvent.RECEIVE);
					epass.result = event.data.toString();
					dispatch(epass);
					break;
				case paths.User.Show:
					epass = new UsersShowEvent(UsersShowEvent.RECEIVE);
					epass.result = event.data.toString();
					usersShowResult.profile = new Profile(epass.result);
					dispatch(epass);
					break;
				case paths.User.Search:
					epass = new UsersSearchEvent(UsersSearchEvent.RECEIVE);
					epass.result = event.data.toString();
					usersSearchResult.profiles = new ProfileSet(epass.result);
					dispatch(epass);
					break;
				case paths.User.Suggestions:
					epass = new UsersSuggestionEvent(UsersSuggestionEvent.RECEIVE);
					epass.result = event.data.toString();
					dispatch(epass);
					break;
				case paths.User.SuggestionsSlug:
					epass = new UsersSuggestionSlugEvent(UsersSuggestionSlugEvent.RECEIVE);
					epass.result = event.data.toString();
					dispatch(epass);
					break;
				case paths.User.ProfileImage:
					epass = new UsersProfileImageEvent(UsersProfileImageEvent.RECEIVE);
					epass.result = event.redirect;
					usersProfileIMageResult.url = epass.result;
					dispatch(epass);
					break;
				
				/*
				* LEGAL
				*/
				case paths.Legal.Tos:
					epass = new LegalTosEvent(LegalTosEvent.RECEIVE);
					epass.result = event.data.toString();
					legalTosResult.tos = new Tos(epass.result);
					dispatch(epass);
					break;
				case paths.Legal.Privacy:
					epass = new LegalPrivacyEvent(LegalPrivacyEvent.RECEIVE);
					epass.result = event.data.toString();
					legalPrivacyResult.privacy = new Privacy(epass.result);
					dispatch(epass);
					break;
				
				/*
				* HELP
				*/
				case paths.Help.Test:
					epass = new HelpTestEvent(HelpTestEvent.RECEIVE);
					epass.result = event.data.toString();
					helpTestResult.message = new PlainText(epass.result);
					dispatch(epass);
					break;
				/*
				* ACCOUNT
				*/
				case paths.Account.VerifyCredentials:
					epass = new AccountVerifyCredentialsEvent(AccountVerifyCredentialsEvent.RECEIVE);
					epass.result = event.data.toString();
					accountVerifyCredentialsResult.profile = new Profile(epass.result);
					dispatch(epass);
					break;
				case paths.Account.RateLimitStatus:
					epass = new AccountRateLimitStatusEvent(AccountRateLimitStatusEvent.RECEIVE);
					epass.result = event.data.toString();
					accountRateLimitStatusResult.status = new RateLimitStatus(epass.result);
					dispatch(epass);
					break;
				case paths.Account.UpdateProfileColors:
					epass = new AccountUpdateProfileColorsEvent(AccountUpdateProfileColorsEvent.RECEIVE);
					epass.result = event.data.toString();
					dispatch(epass);
					break;
				case paths.Account.UpdateProfileImage:
					epass = new AccountUpdateProfileImageEvent(AccountUpdateProfileImageEvent.RECEIVE);
					epass.result = event.data.toString();
					dispatch(epass);
					break;
				case paths.Account.UpdateProfileBackgroundImage:
					epass = new AccountUpdateProfileBackgroundImageEvent(AccountUpdateProfileBackgroundImageEvent.RECEIVE);
					epass.result = event.data.toString();
					dispatch(epass);
					break;
				case paths.Account.UpdateProfile:
					epass = new AccountUpdateProfileEvent(AccountUpdateProfileEvent.RECEIVE);
					epass.result = event.data.toString();
					dispatch(epass);
					break;
				case paths.Account.Totals:
					epass = new AccountTotalsEvent(AccountTotalsEvent.RECEIVE);
					epass.result = event.data.toString();
					accountTotalsResult.totals = new Totals(epass.result);
					dispatch(epass);
					break;
				case paths.Account.UpdateSettings+"POST":
					epass = new AccountUpdateSettingsEvent(AccountUpdateSettingsEvent.RECEIVE);
					epass.result = event.data.toString();
					dispatch(epass);
					break;
				case paths.Account.Settings+"GET":
					epass = new AccountSettingsEvent(AccountSettingsEvent.RECEIVE);
					epass.result = event.data.toString();
					accountSettingsResult.settings = new Settings(epass.result);
					dispatch(epass);
					break;
				
				/*
				* BLOCK
				*/
				case paths.Block.Create:
					epass = new BlockCreateEvent(BlockCreateEvent.RECEIVE);
					epass.result = event.data.toString();
					dispatch(epass);
					break;
				case paths.Block.Destroy:
					epass = new BlockDestroyEvent(BlockDestroyEvent.RECEIVE);
					epass.result = event.data.toString();
					dispatch(epass);
					break;
				case paths.Block.Exists:
					epass = new BlockExistsEvent(BlockExistsEvent.RECEIVE);
					epass.result = event.data.toString();
					blockExistsResult.profile = new Profile(epass.result);
					dispatch(epass);
					break;
				case paths.Block.Blocking:
					epass = new BlockBlockingEvent(BlockBlockingEvent.RECEIVE);
					epass.result = event.data.toString();
					blockBlockingResult.profiles = new ProfileSet(epass.result);
					dispatch(epass);
					break;
				case paths.Block.BlockingIDs:
					epass = new BlockBlockingIDsEvent(BlockBlockingIDsEvent.RECEIVE);
					epass.result = event.data.toString();
					blockBlockingIDsResult.ids = new PlainNumberSet(epass.result);
					dispatch(epass);
					break;
				
				/*
				* DIRECTMESSAGES
				*/
				case paths.DirectMessages.DirectMessages:
					epass = new DirectMessagesDirectMessagesEvent(DirectMessagesDirectMessagesEvent.RECEIVE);
					epass.result = event.data.toString();
					directmessagesDirectMessagesResult.messages = new DirectMessageSet(epass.result);
					dispatch(epass);
					break;
				case paths.DirectMessages.Sent:
					epass = new DirectMessagesSentEvent(DirectMessagesSentEvent.RECEIVE);
					epass.result = event.data.toString();
					directmessagesSentResult.messages = new DirectMessageSet(epass.result);
					dispatch(epass);
					break;
				case paths.DirectMessages.Create:
					epass = new DirectMessagesCreateEvent(DirectMessagesCreateEvent.RECEIVE);
					epass.result = event.data.toString();
					dispatch(epass);
					break;
				case paths.DirectMessages.Destroy:
					epass = new DirectMessagesDestroyEvent(DirectMessagesDestroyEvent.RECEIVE);
					epass.result = event.data.toString();
					dispatch(epass);
					break;
				
				/*
				* FAVORITES
				*/
				case paths.Favorites.Favorites:
					epass = new FavoritesFavoritesEvent(FavoritesFavoritesEvent.RECEIVE);
					epass.result = event.data.toString();
					favoritesFavoritesResult.favorites = new StatusSet(epass.result);
					dispatch(epass);
					break;
				case paths.Favorites.Create:
					epass = new FavoritesCreateEvent(FavoritesCreateEvent.RECEIVE);
					epass.result = event.data.toString();
					dispatch(epass);
					break;
				case paths.Favorites.Destroy:
					epass = new FavoritesDestroyEvent(FavoritesDestroyEvent.RECEIVE);
					epass.result = event.data.toString();
					dispatch(epass);
					break;
				
				/*
				* FRIENDSANDFOLLOWERS
				*/
				case paths.FriendsAndFollowers.Friends:
					epass = new FriendsAndFollowersFriendsEvent(FriendsAndFollowersFriendsEvent.RECEIVE);
					epass.result = event.data.toString();
					friendsandfollowersFriendsResult.friends = new PlainNumberSet(epass.result);
					dispatch(epass);
					break;
				case paths.FriendsAndFollowers.Followers:
					epass = new FriendsAndFollowersFollowersEvent(FriendsAndFollowersFollowersEvent.RECEIVE);
					epass.result = event.data.toString();
					friendsandfollowersFollowersResult.followers = new PlainNumberSet(epass.result);
					dispatch(epass);
					break;
				
				/*
				* FRIENDSHIP
				*/
				case paths.Friendship.Create:
					epass = new FriendshipCreateEvent(FriendshipCreateEvent.RECEIVE);
					epass.result = event.data.toString();
					dispatch(epass);
					break;
				case paths.Friendship.Destroy:
					epass = new FriendshipDestroyEvent(FriendshipDestroyEvent.RECEIVE);
					epass.result = event.data.toString();
					dispatch(epass);
					break;
				case paths.Friendship.Exists:
					epass = new FriendshipExistsEvent(FriendshipExistsEvent.RECEIVE);
					epass.result = event.data.toString();
					dispatch(epass);
					break;
				case paths.Friendship.Show:
					epass = new FriendshipShowEvent(FriendshipShowEvent.RECEIVE);
					epass.result = event.data.toString();
					dispatch(epass);
					break;
				case paths.Friendship.Incoming:
					epass = new FriendshipIncomingEvent(FriendshipIncomingEvent.RECEIVE);
					epass.result = event.data.toString();
					dispatch(epass);
					break;
				case paths.Friendship.Outgoing:
					epass = new FriendshipOutgoingEvent(FriendshipOutgoingEvent.RECEIVE);
					epass.result = event.data.toString();
					dispatch(epass);
					break;
				
				/*
				* GEO
				*/
				case paths.Geo.Search:
					epass = new GeoSearchEvent(GeoSearchEvent.RECEIVE);
					epass.result = event.data.toString();
					geoSearchResult.placeset = new PlaceSet(epass.result);
					dispatch(epass);
					break;
				case paths.Geo.SimilarPlaces:
					epass = new GeoSimilarPlacesEvent(GeoSimilarPlacesEvent.RECEIVE);
					epass.result = event.data.toString();
					geoSimilarPlacesResult.placeset = new PlaceSet(epass.result);
					dispatch(epass);
					break;
				case paths.Geo.ReverseGeocode:
					epass = new GeoReverseGeocodeEvent(GeoReverseGeocodeEvent.RECEIVE);
					epass.result = event.data.toString();
					geoReverseGeocodeResult.placeset = new PlaceSet(epass.result);
					dispatch(epass);
					break;
				case paths.Geo.PlaceId:
					epass = new GeoPlaceIdEvent(GeoPlaceIdEvent.RECEIVE);
					epass.result = event.data.toString();
					geoPlaceIdResult.place = new Place(epass.result);
					dispatch(epass);
					break;
				case paths.Geo.Place:
					epass = new GeoPlaceEvent(GeoPlaceEvent.RECEIVE);
					epass.result = event.data.toString();
					geoPlaceResult.place = new Place(epass.result);
					dispatch(epass);
					break;
				
				/*
				* LIST
				*/
				case paths.List.Lists:
					epass = new ListListsEvent(ListListsEvent.RECEIVE);
					epass.result = event.data.toString();
					dispatch(epass);
					break;
				case paths.List.Memberships:
					epass = new ListMembershipsEvent(ListMembershipsEvent.RECEIVE);
					epass.result = event.data.toString();
					dispatch(epass);
					break;
				case paths.List.Subscriptions:
					epass = new ListSubscriptionsEvent(ListSubscriptionsEvent.RECEIVE);
					epass.result = event.data.toString();
					dispatch(epass);
					break;
				case paths.List.Show:
					epass = new ListShowEvent(ListShowEvent.RECEIVE);
					epass.result = event.data.toString();
					dispatch(epass);
					break;
				case paths.List.Statuses:
					epass = new ListStatusesEvent(ListStatusesEvent.RECEIVE);
					epass.result = event.data.toString();
					dispatch(epass);
					break;
				case paths.List.Create:
					epass = new ListCreateEvent(ListCreateEvent.RECEIVE);
					epass.result = event.data.toString();
					dispatch(epass);
					break;
				case paths.List.Update:
					epass = new ListUpdateEvent(ListUpdateEvent.RECEIVE);
					epass.result = event.data.toString();
					dispatch(epass);
					break;
				case paths.List.Destroy:
					epass = new ListDestroyEvent(ListDestroyEvent.RECEIVE);
					epass.result = event.data.toString();
					dispatch(epass);
					break;
				
				/*
				* LISTMEMBERS
				*/
				case paths.ListMembers.Members:
					epass = new ListMembersMembersEvent(ListMembersMembersEvent.RECEIVE);
					epass.result = event.data.toString();
					dispatch(epass);
					break;
				case paths.ListMembers.Show:
					epass = new ListMembersShowEvent(ListMembersShowEvent.RECEIVE);
					epass.result = event.data.toString();
					dispatch(epass);
					break;
				case paths.ListMembers.Create:
					epass = new ListMembersCreateEvent(ListMembersCreateEvent.RECEIVE);
					epass.result = event.data.toString();
					dispatch(epass);
					break;
				case paths.ListMembers.CreateAll:
					epass = new ListMembersCreateAllEvent(ListMembersCreateAllEvent.RECEIVE);
					epass.result = event.data.toString();
					dispatch(epass);
					break;
				case paths.ListMembers.Destroy:
					epass = new ListMembersDestroyEvent(ListMembersDestroyEvent.RECEIVE);
					epass.result = event.data.toString();
					dispatch(epass);
					break;
				
				/*
				* LISTSUBSCRIBERS
				*/
				case paths.ListSubscribers.Subscribers:
					epass = new ListSubscribersSubscribersEvent(ListSubscribersSubscribersEvent.RECEIVE);
					epass.result = event.data.toString();
					dispatch(epass);
					break;
				case paths.ListSubscribers.Show:
					epass = new ListSubscribersShowEvent(ListSubscribersShowEvent.RECEIVE);
					epass.result = event.data.toString();
					dispatch(epass);
					break;
				case paths.ListSubscribers.Create:
					epass = new ListSubscribersCreateEvent(ListSubscribersCreateEvent.RECEIVE);
					epass.result = event.data.toString();
					dispatch(epass);
					break;
				case paths.ListSubscribers.Destroy:
					epass = new ListSubscribersDestroyEvent(ListSubscribersDestroyEvent.RECEIVE);
					epass.result = event.data.toString();
					dispatch(epass);
					break;
				
				/*
				* LOCALTRENDS
				*/
				case paths.LocalTrends.Available:
					epass = new LocalTrendsAvailableEvent(LocalTrendsAvailableEvent.RECEIVE);
					epass.result = event.data.toString();
					dispatch(epass);
					break;
				case paths.LocalTrends.WOEID:
					epass = new LocalTrendsWOEIDEvent(LocalTrendsWOEIDEvent.RECEIVE);
					epass.result = event.data.toString();
					dispatch(epass);
					break;
				
				/*
				* NOTIFICATION
				*/
				case paths.Notification.Follow:
					epass = new NotificationFollowEvent(NotificationFollowEvent.RECEIVE);
					epass.result = event.data.toString();
					dispatch(epass);
					break;
				case paths.Notification.Leave:
					epass = new NotificationLeaveEvent(NotificationLeaveEvent.RECEIVE);
					epass.result = event.data.toString();
					dispatch(epass);
					break;
				
				/*
				* SAVEDSEARCH
				*/
				case paths.SavedSearch.Searches:
					epass = new SavedSearchSearchesEvent(SavedSearchSearchesEvent.RECEIVE);
					epass.result = event.data.toString();
					savedSearchSearchesResult.searches = new SavedSearchSet(epass.result); 
					dispatch(epass);
					break;
				case paths.SavedSearch.Show:
					epass = new SavedSearchShowEvent(SavedSearchShowEvent.RECEIVE);
					epass.result = event.data.toString();
					savedSearchResult.search = new SavedSearch(epass.result);
					dispatch(epass);
					break;
				case paths.SavedSearch.Create:
					epass = new SavedSearchCreateEvent(SavedSearchCreateEvent.RECEIVE);
					epass.result = event.data.toString();
					savedSearchResult.search = new SavedSearch(epass.result);
					dispatch(epass);
					break;
				case paths.SavedSearch.Destroy:
					epass = new SavedSearchDestroyEvent(SavedSearchDestroyEvent.RECEIVE);
					epass.result = event.data.toString();
					savedSearchResult.search = new SavedSearch(epass.result);
					dispatch(epass);
					break;
				
				/*
				* SPAMREPORTING
				*/
				case paths.SpamReporting.ReportSpam:
					epass = new SpamReportingReportSpamEvent(SpamReportingReportSpamEvent.RECEIVE);
					epass.result = event.data.toString();
					spamReportingReportSpamResult.profile = new Profile(epass.result);
					dispatch(epass);
					break;
				
				/*
				* TIMELINE
				*/
				case paths.Timeline.PublicTimeline:
					epass = new TimelinePublicTimelineEvent(TimelinePublicTimelineEvent.RECEIVE);
					epass.result = event.data.toString();
					timelinePublicTimelineResult.timeline = new StatusSet(epass.result);
					dispatch(epass);
					break;
				case paths.Timeline.HomeTimeline:
					epass = new TimelineHomeTimelineEvent(TimelineHomeTimelineEvent.RECEIVE);
					epass.result = event.data.toString();
					timelineHomeTimelineResult.timeline = new StatusSet(epass.result);
					dispatch(epass);
					break;
				case paths.Timeline.UserTimeline:
					epass = new TimelineUserTimelineEvent(TimelineUserTimelineEvent.RECEIVE);
					epass.result = event.data.toString();
					timelineUserTimelineResult.timeline = new StatusSet(epass.result);
					dispatch(epass);
					break;
				case paths.Timeline.Mentions:
					epass = new TimelineMentionsEvent(TimelineMentionsEvent.RECEIVE);
					epass.result = event.data.toString();
					timelineMentionsResult.timeline = new StatusSet(epass.result);
					dispatch(epass);
					break;
				case paths.Timeline.RetweetedByMe:
					epass = new TimelineRetweetedByMeEvent(TimelineRetweetedByMeEvent.RECEIVE);
					epass.result = event.data.toString();
					timelineRetweetedByMeResult.timeline = new StatusSet(epass.result);
					dispatch(epass);
					break;
				case paths.Timeline.RetweetedToMe:
					epass = new TimelineRetweetedToMeEvent(TimelineRetweetedToMeEvent.RECEIVE);
					epass.result = event.data.toString();
					timelineRetweetedToMeResult.timeline = new StatusSet(epass.result);
					dispatch(epass);
					break;
				case paths.Timeline.RetweetsOfMe:
					epass = new TimelineRetweetsOfMeEvent(TimelineRetweetsOfMeEvent.RECEIVE);
					epass.result = event.data.toString();
					timelineRetweetsOfMeResult.timeline = new StatusSet(epass.result);
					dispatch(epass);
					break;
				
				/*
				* TRENDS
				*/
				case paths.Trends.Trends:
					epass = new TrendsTrendsEvent(TrendsTrendsEvent.RECEIVE);
					epass.result = event.data.toString();
					dispatch(epass);
					break;
				case paths.Trends.Current:
					epass = new TrendsCurrentEvent(TrendsCurrentEvent.RECEIVE);
					epass.result = event.data.toString();
					dispatch(epass);
					break;
				case paths.Trends.Daily:
					epass = new TrendsDailyEvent(TrendsDailyEvent.RECEIVE);
					epass.result = event.data.toString();
					dispatch(epass);
					break;
				case paths.Trends.Weekly:
					epass = new TrendsWeeklyEvent(TrendsWeeklyEvent.RECEIVE);
					epass.result = event.data.toString();
					dispatch(epass);
					break;
				
				/*
				* TWEETS
				*/
				case paths.Tweets.Show:
					epass = new TweetsShowEvent(TweetsShowEvent.RECEIVE);
					epass.result = event.data.toString();
					dispatch(epass);
					break;
				case paths.Tweets.Update:
					epass = new TweetsUpdateEvent(TweetsUpdateEvent.RECEIVE);
					epass.result = event.data.toString();
					dispatch(epass);
					break;
				case paths.Tweets.Destroy:
					epass = new TweetsDestroyEvent(TweetsDestroyEvent.RECEIVE);
					epass.result = event.data.toString();
					dispatch(epass);
					break;
				case paths.Tweets.Retweet:
					epass = new TweetsRetweetEvent(TweetsRetweetEvent.RECEIVE);
					epass.result = event.data.toString();
					dispatch(epass);
					break;
				case paths.Tweets.Retweets:
					epass = new TweetsRetweetsEvent(TweetsRetweetsEvent.RECEIVE);
					epass.result = event.data.toString();
					dispatch(epass);
					break;
				case paths.Tweets.RetweetedBy:
					epass = new TweetsRetweetedByEvent(TweetsRetweetedByEvent.RECEIVE);
					epass.result = event.data.toString();
					dispatch(epass);
					break;
				case paths.Tweets.RetweetedByIDs:
					epass = new TweetsRetweetedByIDsEvent(TweetsRetweetedByIDsEvent.RECEIVE);
					epass.result = event.data.toString();
					dispatch(epass);
					break;
				
				
				
				/*
				* OTHER
				*/
				default:
					epass = new TwitterAPIResultEvent(TwitterAPIResultEvent.RECEIVE);
					epass.result = event.data.toString();
					dispatch(epass);
					dispatch(new TwitterAPIEvent(TwitterAPIEvent.TWITTER_DATA, event.data.toString()));
					break;
			}
		}
	}
}