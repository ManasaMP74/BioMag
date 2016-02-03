#import <UIKit/UIKit.h>
#import "UIImageView+AFNetworking.h"
@interface ProfileImageView : UIView
@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;
@property (strong, nonatomic)NSString *imageCode;
-(void)alphaViewInitialize;
@end
