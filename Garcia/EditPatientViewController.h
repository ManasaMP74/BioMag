#import <UIKit/UIKit.h>
#import "searchPatientModel.h"
@interface EditPatientViewController : UIViewController<UITextViewDelegate,UIAlertViewDelegate>
@property(strong,nonatomic)searchPatientModel *model;
@end
