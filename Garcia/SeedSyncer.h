#import <Foundation/Foundation.h>
@interface SeedSyncer : NSObject
+ (SeedSyncer *)sharedSyncer;
- (void)callSeedAPI:(void (^)(BOOL success))completionHandler;
- (void)saveResponse:(NSString *)responseString forIdentity:(NSString *)identity;
- (void)getResponseFor:(NSString *)identity completionHandler:(void (^)(BOOL success, id response))completionHandler;
@end
