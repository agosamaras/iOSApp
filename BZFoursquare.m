#import <UIKit/UIKit.h>
#import "BZFoursquare.h"
#import "BZFoursquareRequest.h"

#ifndef __has_feature
#define __has_feature(x) 0
#endif

#if __has_feature(objc_arc)
#error This file does not support Objective-C Automatic Reference Counting (ARC)
#endif

#define kMinSupportedVersion    @"20120609"
#define kAuthorizeBaseURL       @"https://foursquare.com/oauth2/authorize"
#define myClientID              @"PH3EUE13ZGWZY3RGGTFGNBNXEMA42RFBTL1Q0PHHGXNAMAWW"
#define myClientSecret          @"MYGHKIALLQ00JARCTKJZGPVQHKMWZQMXDKSY4R5KW0053GYF"
#define myCallbackURL           @"fsqdemo://foursquare"

@interface BZFoursquare ()
@property(nonatomic,copy,readwrite) NSString *clientID;
@property(nonatomic,copy,readwrite) NSString *callbackURL;
@end

@implementation BZFoursquare


- (id)init {
    return [self initWithClientID:nil callbackURL:nil];
}

- (id)initWithClientID:(NSString *)clientID callbackURL:(NSString *)callbackURL {
    NSParameterAssert(clientID != nil && callbackURL != nil);
    self = [super init];
    if (self) {
        self.clientID = myClientID;
        self.callbackURL = callbackURL;
        self.version = kMinSupportedVersion;
    }
    return self;
}

- (void)dealloc {
    self.clientID = nil;
    self.callbackURL = nil;
    self.clientSecret = nil;
    self.version = nil;
    self.locale = nil;
    self.sessionDelegate = nil;
    self.accessToken = nil;
    [super dealloc];
}

- (BOOL)handleOpenURL:(NSURL *)url {
    if (!_callbackURL || [[url absoluteString] rangeOfString:_callbackURL options:(NSCaseInsensitiveSearch | NSAnchoredSearch)].length == 0) {
        return NO;
    }
    NSString *fragment = [url fragment];
    NSArray *pairs = [fragment componentsSeparatedByString:@"&"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *key = kv[0];
        NSString *val = [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        parameters[key] = val;
    }
    self.accessToken = parameters[@"access_token"];
    if (_accessToken) {
        if ([_sessionDelegate respondsToSelector:@selector(foursquareDidAuthorize:)]) {
            [_sessionDelegate foursquareDidAuthorize:self];
        }
    } else {
        if ([_sessionDelegate respondsToSelector:@selector(foursquareDidNotAuthorize:error:)]) {
            [_sessionDelegate foursquareDidNotAuthorize:self error:parameters];
        }
    }
    return YES;
}

- (void)invalidateSession {
    self.accessToken = nil;
}

- (BOOL)isSessionValid {
    return (_accessToken != nil);
}

- (BZFoursquareRequest *)userlessRequestWithPath:(NSString *)path HTTPMethod:(NSString *)HTTPMethod parameters:(NSDictionary *)parameters delegate:(id<BZFoursquareRequestDelegate>)delegate {
    NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:parameters];
    NSLog(@"Query is: %@", mDict[@"query"]);
    mDict[@"client_id"] = myClientID;
    mDict[@"client_secret"] = myClientSecret;
       if (_version) {
        mDict[@"v"] = _version;
    }
//    if (_locale) {
//        mDict[@"locale"] = _locale;
//    }
    return [[[BZFoursquareRequest alloc] initWithPath:path HTTPMethod:HTTPMethod parameters:mDict delegate:delegate] autorelease];
}

@end
