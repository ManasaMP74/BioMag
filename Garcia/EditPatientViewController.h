#import <UIKit/UIKit.h>
#import "searchPatientModel.h"
@protocol editPatient<NSObject>
-(void)successfullyEdited;
@end
@interface EditPatientViewController : UIViewController<UITextViewDelegate,UIAlertViewDelegate>
@property(strong,nonatomic)searchPatientModel *model;
@property(weak,nonatomic)id<editPatient>delegate;
@end
