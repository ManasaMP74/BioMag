#import <UIKit/UIKit.h>
#import "VMEnvironment.h"
@protocol addedPatient<NSObject>
-(void)successfullyAdded:(NSString *)code;
@end
@interface AddPatientViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property(weak,nonatomic)id<addedPatient>delegate;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
@property (weak, nonatomic) IBOutlet UILabel *transfusionLabel;
@property (weak, nonatomic) IBOutlet UILabel *dobLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobNumbLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *surgeriesLabel;
@end
