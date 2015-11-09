#import <UIKit/UIKit.h>
#import "PostmanConstant.h"
#import "Postman.h"
@protocol sendPatientDetailtoContainerVC<NSObject>
-(void)sendData:(NSString*)str;
@end
@interface SearchPatientViewController : UIViewController
@property(weak,nonatomic)id<sendPatientDetailtoContainerVC>delegate;
-(void)hideKeyBoard;
@end
