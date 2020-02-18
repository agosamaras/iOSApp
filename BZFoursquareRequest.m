#import <MobileCoreServices/MobileCoreServices.h>
#import "BZFoursquareRequest.h"
#import "BZFoursquare.h"

#ifndef __has_feature
#define __has_feature(x) 0
#endif

#if __has_feature(objc_arc)
#error This file does not support Objective-C Automatic Reference Counting (ARC)
#endif

#define kAPIv2BaseURL           @"https://api.foursquare.com/v2"
#define kTimeoutInterval        180.0

@interface BZFoursquareRequest ()
@property(nonatomic,copy,readwrite) NSString *path;
@property(nonatomic,copy,readwrite) NSString *HTTPMethod;
@property(nonatomic,copy,readwrite) NSDictionary *parameters;
@property(nonatomic,retain,setter=_setDelegateQueue:) NSOperationQueue *_delegateQueue;
@property(nonatomic,retain) NSURLConnection *connection;
@property(nonatomic,retain) NSMutableData *responseData;
@property(nonatomic,copy,readwrite) NSDictionary *meta;
@property(nonatomic,copy,readwrite) NSArray *notifications;
@property(nonatomic,copy,readwrite) NSDictionary *response;
- (NSURLRequest *)requestForGETMethod;
@end

@implementation BZFoursquareRequest

+ (NSURL *)baseURL {
    return [NSURL URLWithString:kAPIv2BaseURL];
}

- (id)init {
    return [self initWithPath:nil HTTPMethod:nil parameters:nil delegate:nil];
}

- (id)initWithPath:(NSString *)path HTTPMethod:(NSString *)HTTPMethod parameters:(NSDictionary *)parameters delegate:(id<BZFoursquareRequestDelegate>)delegate {
    self = [super init];
    if (self) {
        self.path = path;
        self.HTTPMethod = HTTPMethod ?: @"GET";
        self.parameters = parameters;
        self.delegate = delegate;
    }
    return self;
}

- (void)dealloc {
    self.path = nil;
    self.HTTPMethod = nil;
    self.parameters = nil;
    self.delegate = nil;
    self._delegateQueue = nil;
    self.connection = nil;
    self.responseData = nil;
    self.meta = nil;
    self.notifications = nil;
    self.response = nil;
    [super dealloc];
}

- (NSOperationQueue *)delegateQueue {
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_5_1) {
        // 5.1.x or earlier
        // Note: NSURLConnection setDelegateQueue is broken on iOS 5.x.
        // See http://openradar.appspot.com/10529053.
        [self doesNotRecognizeSelector:_cmd];
        return nil;
    } else {
        // 6.0 or later
        return __delegateQueue;
    }
}

- (void)setDelegateQueue:(NSOperationQueue *)delegateQueue {
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_5_1) {
        // 5.1.x or earlier
        // Note: NSURLConnection setDelegateQueue is broken on iOS 5.x.
        // See http://openradar.appspot.com/10529053.
        [self doesNotRecognizeSelector:_cmd];
    } else {
        // 6.0 or later
        self._delegateQueue = delegateQueue;
    }
}

- (void)start {
    [self cancel];
    self.meta = nil;
    self.notifications = nil;
    self.response = nil;
    NSLog(@"Request_start Query is: %@", self.parameters[@"query"]);
    NSURLRequest *request;
    if ([_HTTPMethod isEqualToString:@"GET"]) {
        request = [self requestForGETMethod];
    }
    else {
        NSAssert2(NO, @"*** %s: HTTP %@ method not supported", __PRETTY_FUNCTION__, _HTTPMethod);
        request = nil;
    }
    self.connection = [[[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO] autorelease];
    NSAssert1(_connection != nil, @"*** %s: connection is nil", __PRETTY_FUNCTION__);
    if (__delegateQueue) {
        [_connection setDelegateQueue:__delegateQueue];
    }
    [_connection start];
}

- (void)cancel {
    if (_connection) {
        [_connection cancel];
        self.connection = nil;
        self.responseData = nil;
    }
}
#pragma mark -
#pragma mark NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.responseData = [NSMutableData data];
    if ([_delegate respondsToSelector:@selector(requestDidStartLoading:)]) {
        [_delegate requestDidStartLoading:self];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSString *responseString = [[[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding] autorelease];
    NSError *error = nil;
    NSDictionary *response = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    if (!response) {
        goto bye;
    }
    self.meta = response[@"meta"];
    self.notifications = response[@"notifications"];
    self.response = response[@"response"];
    NSInteger code = [_meta[@"code"] integerValue];
    if (code / 100 != 2) {
        error = [NSError errorWithDomain:BZFoursquareErrorDomain code:code userInfo:_meta];
    }
bye:
    if (error) {
        if ([_delegate respondsToSelector:@selector(request:didFailWithError:)]) {
            [_delegate request:self didFailWithError:error];
        }
    } else {
        if ([_delegate respondsToSelector:@selector(requestDidFinishLoading:)]) {
            [_delegate requestDidFinishLoading:self];
        }
    }
    self.connection = nil;
    self.responseData = nil;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    if ([_delegate respondsToSelector:@selector(request:didFailWithError:)]) {
        [_delegate request:self didFailWithError:error];
    }
    self.connection = nil;
    self.responseData = nil;
}

#pragma mark -
#pragma mark Anonymous category

- (NSURLRequest *)requestForGETMethod {
    NSMutableArray *pairs = [NSMutableArray array];
    for (NSString *key in _parameters) {
        NSString *value = _parameters[key];
        if (![value isKindOfClass:[NSString class]]) {
            if ([value isKindOfClass:[NSNumber class]]) {
                value = [value description];
            } else {
                continue;
            }
        }
        CFStringRef escapedValue = CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)value, NULL, CFSTR("%:/?#[]@!$&'()*+,;="), kCFStringEncodingUTF8);
        NSMutableString *pair = [[key mutableCopy] autorelease];
        [pair appendString:@"="];
        [pair appendString:(NSString *)escapedValue];
        [pairs addObject:pair];
        CFRelease(escapedValue);
    }
    NSString *URLString = [kAPIv2BaseURL stringByAppendingPathComponent:_path];
    NSMutableString *mURLString = [[URLString mutableCopy] autorelease];
    [mURLString appendString:@"?"];
    [mURLString appendString:[pairs componentsJoinedByString:@"&"]];
    NSLog(@"URL: %@",mURLString);
    NSURL *URL = [NSURL URLWithString:mURLString];

    NSLog(@"URL: %@",URL);
    
    return [NSURLRequest requestWithURL:URL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:kTimeoutInterval];    
}
@end

NSString * const BZFoursquareErrorDomain = @"BZFoursquareErrorDomain";
