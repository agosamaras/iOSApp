#import <Foundation/Foundation.h>

@protocol BZFoursquareRequestDelegate;

@interface BZFoursquareRequest : NSObject

@property(nonatomic,copy,readonly) NSString *path;
@property(nonatomic,copy,readonly) NSString *HTTPMethod;
@property(nonatomic,copy,readonly) NSDictionary *parameters;
@property(nonatomic,assign) id<BZFoursquareRequestDelegate> delegate;
@property(nonatomic,retain) NSOperationQueue *delegateQueue NS_AVAILABLE(NA, 6_0);
// responses
@property(nonatomic,copy,readonly) NSDictionary *meta;
@property(nonatomic,copy,readonly) NSArray *notifications;
@property(nonatomic,copy,readonly) NSDictionary *response;

+ (NSURL *)baseURL;

- (id)initWithPath:(NSString *)path HTTPMethod:(NSString *)HTTPMethod parameters:(NSDictionary *)parameters delegate:(id<BZFoursquareRequestDelegate>)delegate;

- (void)start;
- (void)cancel;

@end

@protocol BZFoursquareRequestDelegate <NSObject>
@optional
- (void)requestDidStartLoading:(BZFoursquareRequest *)request;
- (void)requestDidFinishLoading:(BZFoursquareRequest *)request;
- (void)request:(BZFoursquareRequest *)request didFailWithError:(NSError *)error;
@end

FOUNDATION_EXPORT NSString * const BZFoursquareErrorDomain;
