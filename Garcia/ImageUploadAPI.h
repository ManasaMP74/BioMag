#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ImageUploadAPI : NSObject
- (void)uploadDocumentPath:(NSString *)imagePath forRequestCode:(NSString *)reqCode withDocumentType:(NSArray*)docType withText:(NSArray*)caption withRequestType:(NSString*)reqType onCompletion:(void (^)(BOOL))completionHandler;



- (void)uploadUserImagePath:(NSString *)imagePath forRequestCode:(NSString *)reqCode withDocumentType:(NSString*)docType andRequestType:(NSString *)reqType onCompletion:(void (^)(BOOL))completionHandler;



- (void)uploadUserForVzoneDocumentPath:(NSString *)imagePath forRequestCode:(NSString *)reqCode withType:(NSString *)type withText:(NSString*)caption withRequestType:(NSString*)reqType withUserId:(NSString*)UserId onCompletion:(void (^)(BOOL))completionHandler;


@end
