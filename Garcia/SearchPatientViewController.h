#import <UIKit/UIKit.h>
#import "PostmanConstant.h"
#import "Postman.h"
#import "UIImageView+AFNetworking.h"
@interface SearchPatientViewController : UIViewController
-(void)hideKeyBoard;
-(void)againCallApiAfterAddPatient;
-(void)againCallApiAfterEditPatient;
-(void)reloadTableviewAfterAddNewTreatment;
@end
