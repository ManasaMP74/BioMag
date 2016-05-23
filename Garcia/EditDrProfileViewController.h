#import <UIKit/UIKit.h>
#import "VMEnvironment.h"
#define NULL_CHECK(X) [X isKindOfClass:[NSNull class]]?nil:X
@protocol editSuccess<NSObject>
-(void)editedSuccessfully;
@end
@interface EditDrProfileViewController : UIViewController
@property(weak,nonatomic)id<editSuccess>delegate;
@end
