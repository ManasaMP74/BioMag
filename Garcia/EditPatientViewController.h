#import <UIKit/UIKit.h>
#import "searchPatientModel.h"
#import "UIImageView+AFNetworking.h"
#import "VMEnvironment.h"
@protocol editPatient<NSObject>
-(void)successfullyEdited:(NSString *)code;
@end
@interface EditPatientViewController : UIViewController<UITextViewDelegate>
@property(strong,nonatomic)searchPatientModel *model;
@property(weak,nonatomic)id<editPatient>delegate;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
@property (weak, nonatomic) IBOutlet UILabel *transfusionLabel;
@property (weak, nonatomic) IBOutlet UILabel *dobLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobNumbLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *surgeriesLabel;
@property (weak, nonatomic) IBOutlet UIControl *mainController;
@end
