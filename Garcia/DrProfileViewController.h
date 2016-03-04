#import <UIKit/UIKit.h>

@interface DrProfileViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *doctorImage;
@property (weak, nonatomic) IBOutlet UILabel *dobLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearOfExperienceLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
@property (weak, nonatomic) IBOutlet UILabel *certificateLabel;
@property (weak, nonatomic) IBOutlet UILabel *dobValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearOfExpValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *certificateValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameValueLabel;

@end
