#import <UIKit/UIKit.h>
@protocol editSuccess<NSObject>
-(void)editedSuccessfully;
@end
@interface EditDrProfileViewController : UIViewController
@property(weak,nonatomic)id<editSuccess>delegate;
@end
