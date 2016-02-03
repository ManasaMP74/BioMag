#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ProfileImageModel : NSObject
@property(strong,nonatomic)NSString *profileImageBase64Data;
@property(strong,nonatomic)NSString *profileImageId;
@property(strong,nonatomic)NSString *profileImageRequestCode;
@property(strong,nonatomic)NSString *profileImageCode;
@property(strong,nonatomic)NSString *profileImageDocumentTypeCode;
@property(strong,nonatomic)NSString *profileImageContentType;
@property(strong,nonatomic)UIImage *profileImage;
@end
