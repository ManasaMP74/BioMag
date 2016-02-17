#import <UIKit/UIKit.h>
#import "UIImageView+AFNetworking.h"
@interface ProfileImageView : UIView
@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;
@property (strong, nonatomic)NSString *imageCode;
@property (strong, nonatomic)UIImage *storageId;
@property (strong, nonatomic)UIImage *DisplayImg;

-(void)alphaViewInitialize;
@end
