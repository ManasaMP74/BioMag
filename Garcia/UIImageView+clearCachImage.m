#import "UIImageView+clearCachImage.h"
#import "UIImageView+AFNetworking.h"
@implementation UIImageView (clearCachImage)
- (void)clearImageCacheForURL:(NSURL *)url
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    
    UIImage *cachedImage = [[[self class] sharedImageCache] cachedImageForRequest:request];
    if (cachedImage) {
        [self clearCached:[[self class] sharedImageCache] Request:request];
    }
}
- (void)clearCached:(NSCache *)imageCache Request:(NSURLRequest *)request
{
    if (request) {
        [imageCache removeObjectForKey:[[request URL] absoluteString]];
    }
}

@end
