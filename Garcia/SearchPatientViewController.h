#import <UIKit/UIKit.h>
#import "PostmanConstant.h"
#import "Postman.h"
@protocol showMBProgressInContainerVC<NSObject>
-(void)showMBprogressTillLoadThedata;
-(void)hideMBprogressTillLoadThedata;
@end
@interface SearchPatientViewController : UIViewController
@property(weak,nonatomic)id<showMBProgressInContainerVC>delegate;
-(void)hideKeyBoard;
-(void)againCallApiAfterAddPatient;
@end
