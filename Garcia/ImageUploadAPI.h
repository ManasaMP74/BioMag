#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ImageUploadAPI : NSObject
- (void)uploadUserImagePath:(NSString *)imagePath forRequestCode:(NSString *)reqCode withDocumentType:(NSString*)docType onCompletion:(void (^)(BOOL success))completionHandler;

@end
