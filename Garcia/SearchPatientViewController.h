#import <UIKit/UIKit.h>
#import "PostmanConstant.h"
#import "Postman.h"
#import "UIImageView+AFNetworking.h"
#import "VMEnvironment.h"
@interface SearchPatientViewController : UIViewController
-(void)hideKeyBoard;
-(void)againCallApiAfterAddPatient:(NSString *)code;
-(void)againCallApiAfterEditPatient:(NSString *)code;
-(void)reloadTableviewAfterAddNewTreatment;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hudContainerViewHeight;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@end
