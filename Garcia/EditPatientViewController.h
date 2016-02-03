#import <UIKit/UIKit.h>
#import "searchPatientModel.h"
#import "UIImageView+AFNetworking.h"
@protocol editPatient<NSObject>
-(void)successfullyEdited;
@end
@interface EditPatientViewController : UIViewController<UITextViewDelegate>
@property(strong,nonatomic)searchPatientModel *model;
@property(weak,nonatomic)id<editPatient>delegate;
@end
