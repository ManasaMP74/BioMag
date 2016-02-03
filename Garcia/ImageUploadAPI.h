#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ImageUploadAPI : NSObject
- (void)uploadDocumentPath:(NSString *)imagePath forRequestCode:(NSString *)reqCode withDocumentType:(NSArray*)docType withText:(NSArray*)caption onCompletion:(void (^)(BOOL))completionHandler;
- (void)uploadUserImagePath:(NSString *)imagePath forRequestCode:(NSString *)reqCode withDocumentType:(NSString*)docType onCompletion:(void (^)(BOOL))completionHandler;
@end
