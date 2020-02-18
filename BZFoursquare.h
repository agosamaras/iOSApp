#import <Foundation/Foundation.h>
#import "BZFoursquareRequest.h"

@protocol BZFoursquareSessionDelegate;

@interface BZFoursquare : NSObject

@property(nonatomic,copy,readonly) NSString *clientID;
@property(nonatomic,copy,readonly) NSString *callbackURL;
@property(nonatomic,copy) NSString *clientSecret; // for userless access
@property(nonatomic,copy) NSString *version; // YYYYMMDD
@property(nonatomic,copy) NSString *locale;  // en (default), fr, de, it, etc.
@property(nonatomic,assign) id<BZFoursquareSessionDelegate> sessionDelegate;
@property(nonatomic,copy) NSString *accessToken;

- (id)initWithClientID:(NSString *)clientID callbackURL:(NSString *)callbackURL;

- (BOOL)startAuthorization;
- (BOOL)handleOpenURL:(NSURL *)url;
- (void)invalidateSession;
- (BOOL)isSessionValid;

- (BZFoursquareRequest *)requestWithPath:(NSString *)path HTTPMethod:(NSString *)HTTPMethod parameters:(NSDictionary *)parameters delegate:(id<BZFoursquareRequestDelegate>)delegate;
- (BZFoursquareRequest *)userlessRequestWithPath:(NSString *)path HTTPMethod:(NSString *)HTTPMethod parameters:(NSDictionary *)parameters delegate:(id<BZFoursquareRequestDelegate>)delegate;

@end

@protocol BZFoursquareSessionDelegate <NSObject>
@optional
- (void)foursquareDidAuthorize:(BZFoursquare *)foursquare;
- (void)foursquareDidNotAuthorize:(BZFoursquare *)foursquare error:(NSDictionary *)errorInfo;
@end
