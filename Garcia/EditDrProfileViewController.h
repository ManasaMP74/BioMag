#import <UIKit/UIKit.h>
#import "VMEnvironment.h"
@protocol editSuccess<NSObject>
-(void)editedSuccessfully;
@end
@interface EditDrProfileViewController : UIViewController
@property(weak,nonatomic)id<editSuccess>delegate;
@end
