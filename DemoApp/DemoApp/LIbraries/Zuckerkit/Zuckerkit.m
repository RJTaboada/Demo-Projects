
#import "Zuckerkit.h"
#import "Zuckerkeys.h"

#import <FacebookSDK/FacebookSDK.h>
#import <FacebookSDK/FBDialogs.h>
#import <FacebookSDK/FBWebDialogs.h>

@interface Zuckerkit ()
// single use blocks. these blocks are immediatly nulled after they are used
@property (nonatomic, copy) void(^openBlock)(NSError *error);
@property (nonatomic, copy) void(^permissionsBlock)(NSError *error);
@end

@implementation Zuckerkit

+ (instancetype)sharedInstance
{
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self.class new];
        [instance setSettings];
    });
    return instance;
}

- (void)setSettings
{
    [FBSettings setDefaultAppID:FacebookAppId()];
    [FBSettings setDefaultDisplayName:FacebookDisplayName()];
}

- (BOOL)handleOpenUrl:(NSURL*)url
{
   return [FBSession.activeSession handleOpenURL:url];
}

- (void)handleDidBecomeActive
{
    [FBSession.activeSession handleDidBecomeActive];
}

NSString *NSStringFromFBSessionState(FBSessionState state)
{
    switch (state) {
        case FBSessionStateClosed:
            return @"FBSessionStateClosed";
        case FBSessionStateClosedLoginFailed:
            return @"FBSessionStateClosedLoginFailed";
        case FBSessionStateCreated:
            return @"FBSessionStateCreated";
        case FBSessionStateCreatedOpening:
            return @"FBSessionStateCreatedOpening";
        case FBSessionStateCreatedTokenLoaded:
            return @"FBSessionStateCreatedTokenLoaded";
        case FBSessionStateOpen:
            return @"FBSessionStateOpen";
        case FBSessionStateOpenTokenExtended:
            return @"FBSessionStateOpenTokenExtended";
            
    }
    return @"Not Found";
}

- (void)openSessionWithBasicInfoThenRequestPublishPermissions:(void(^)(NSError *error))completionBlock
{
    [self openSessionWithBasicInfo:^(NSError *error) {
        if(error) {
            completionBlock(error);
            return;
        }
        
        [self requestPublishPermissions:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(error);
            });
        }];
    }];
}

- (void)openSessionWithBasicInfo:(void(^)(NSError *error))completionBlock
{
    if([[FBSession activeSession] isOpen]) {
        completionBlock(nil);
        return;
    }
    
    self.openBlock = completionBlock;
    
    [FBSession openActiveSessionWithReadPermissions:@[@"basic_info"] allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self sessionStateChanged:session state:status error:error open:YES permissions:NO];
        });
    }];
}

static NSString *const publish_actions = @"publish_actions";

- (void)requestPublishPermissions:(void(^)(NSError *error))completionBlock
{
    if([[[FBSession activeSession] permissions] indexOfObject:publish_actions] != NSNotFound) {
        completionBlock(nil);
        return;
    }
    
    if([[FBSession activeSession] isOpen] == NO) {
        // error
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Attempting to request publish permissions on unopened session." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        return;
    }
    
    self.permissionsBlock = completionBlock;
    
    [FBSession.activeSession requestNewPublishPermissions:@[publish_actions] defaultAudience:FBSessionDefaultAudienceEveryone completionHandler:^(FBSession *session, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self sessionStateChanged:session state:session.state error:error open:NO permissions:YES];
        });
    }];
}

- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState)state error:(NSError *)error open:(BOOL)open permissions:(BOOL)permissions
{
    if(self.openBlock && open) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.openBlock(error);
            self.openBlock = nil;
        });
    }
    else if(self.permissionsBlock && permissions) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.permissionsBlock(error);
            self.permissionsBlock = nil;
        });
    }
}

- (void)openSessionWithBasicInfoThenRequestPublishPermissionsAndGetAudienceType:(void(^)(NSError *error, FacebookAudienceType))completionBlock
{
    [self openSessionWithBasicInfoThenRequestPublishPermissions:^(NSError *error) {
        if(error) {
            completionBlock(error, 0);
            return;
        }
        
        [self getAppAudienceType:^(FacebookAudienceType audienceType, NSError *error) {
            if(error) {
                completionBlock(error, 0);
                return;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, audienceType);
            });
        }];
    }];
}

- (void)getUserInfo:(void(^)(id<FBGraphUser> user, NSError *error))completionBlock
{
    [[FBRequest requestForMe] startWithCompletionHandler:
     ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
         completionBlock(user, error);
     }];
}

- (void)getFriends:(void(^)(NSArray *friends, NSError *error))completionBlock
{
    FBRequest* friendsRequest = [FBRequest requestForMyFriends];
    friendsRequest.session = [FBSession activeSession];
    [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection, NSDictionary* result, NSError *error) {
        if(error) {
            completionBlock(nil, error);
            return;
        }
        
        NSArray* friends = result[@"data"];
        completionBlock(friends, nil);
    }];
}

- (void)showAppRequestDialogueWithMessage:(NSString*)message toUserId:(NSString*)userId
{
    [FBWebDialogs presentDialogModallyWithSession:[FBSession activeSession] dialog:@"apprequests"
      parameters:@{@"to" : userId, @"message" : message}
      handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
      
    }];
}


#pragma mark - RJ
- (void)sendRequest {
    // Display the requests dialog
    [FBWebDialogs
     presentRequestsDialogModallyWithSession:nil
     message:@"Learn how to make your iOS apps social."
     title:nil
     parameters:nil
     handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
         if (error) {
             // Error launching the dialog or sending the request.
             NSLog(@"Error sending request.");
         } else {
             if (result == FBWebDialogResultDialogNotCompleted) {
                 // User clicked the "x" icon
                 NSLog(@"User canceled request.");
             } else {
                 // Handle the send request callback
                 NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                 if (![urlParams valueForKey:@"request"]) {
                     // User clicked the Cancel button
                     NSLog(@"User canceled request.");
                 } else {
                     // User clicked the Send button
                     NSString *requestID = @"100000620543264"; //[urlParams valueForKey:@"request"];
                     NSLog(@"Request ID: %@", requestID);
                 }
             }
         }
     }];
}

- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}
#pragma mark -end

- (NSString*)accessToken
{
    return [[[FBSession activeSession] accessTokenData] accessToken];
}

- (void)logout
{
    [FBSession.activeSession closeAndClearTokenInformation];
}

#pragma mark - Other

FacebookAudienceType AudienceTypeForValue(NSString *value)
{
    if([value isEqualToString:@"ALL_FRIENDS"])        return FacebookAudienceTypeFriends;
    if([value isEqualToString:@"SELF"])               return FacebookAudienceTypeSelf;
    if([value isEqualToString:@"EVERYONE"])           return FacebookAudienceTypeEveryone;
    if([value isEqualToString:@"FRIENDS_OF_FRIENDS"]) return FacebookAudienceTypeFriends;
    if([value isEqualToString:@"NO_FRIENDS"])         return FacebookAudienceTypeSelf;
    return FacebookAudienceTypeSelf;
}

BOOL FacebookAudienceTypeIsRestricted(FacebookAudienceType type)
{
    return type == FacebookAudienceTypeSelf;
}

- (void)getAppAudienceType:(void(^)(FacebookAudienceType audienceType, NSError *error))completionBlock
{
    if(![[[FBSession activeSession] accessTokenData] accessToken]) {
        completionBlock(0, [NSError new]);
        return;
    }
    
    NSString *query = @"SELECT value FROM privacy_setting WHERE name = 'default_stream_privacy'";
    NSDictionary *queryParam = @{ @"q": query, @"access_token" :  [[[FBSession activeSession] accessTokenData] accessToken]};
    
    [FBRequestConnection startWithGraphPath:@"/fql" parameters:queryParam HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if(error) {
            completionBlock(0, error);
            return;
        }
        
        FBGraphObject *object = result;
        id type = [object objectForKey:@"data"][0][@"value"];
        completionBlock(AudienceTypeForValue(type), nil);
    }];
}

@end