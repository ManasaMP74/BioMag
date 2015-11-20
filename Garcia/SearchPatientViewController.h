#import <UIKit/UIKit.h>
#import "PostmanConstant.h"
#import "Postman.h"
#import "UIImageView+AFNetworking.h"

@protocol showMBProgressInContainerVC<NSObject>
-(void)showMBprogressTillLoadThedata;
-(void)hideMBprogressTillLoadThedata;
-(void)hideAllMBprogressTillLoadThedata;
@end
@interface SearchPatientViewController : UIViewController
@property(weak,nonatomic)id<showMBProgressInContainerVC>delegate;
-(void)hideKeyBoard;
-(void)againCallApiAfterAddPatient;
-(void)againCallApiAfterEditPatient;
@end
