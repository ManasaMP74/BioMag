#import <UIKit/UIKit.h>
#import "UIImageView+AFNetworking.h"
@interface ProfileImageView : UIView
@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;
@property (strong, nonatomic)NSString *imageCode;
@property (strong, nonatomic)UIImage *storageId;
@property (strong, nonatomic)UIImage *DisplayImg;
@property (strong, nonatomic)NSString *filename;
-(void)alphaViewInitialize;
@end
