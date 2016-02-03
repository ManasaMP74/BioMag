#import <UIKit/UIKit.h>
#import "PostmanConstant.h"
#import "Postman.h"
#import "UIImageView+AFNetworking.h"
@interface SearchPatientViewController : UIViewController
-(void)hideKeyBoard;
-(void)againCallApiAfterAddPatient:(NSString *)code;
-(void)againCallApiAfterEditPatient:(NSString *)code;
-(void)reloadTableviewAfterAddNewTreatment;
@end
