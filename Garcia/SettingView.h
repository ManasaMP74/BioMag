#import <UIKit/UIKit.h>

@interface SettingView : UIView

@property (strong, nonatomic) IBOutlet UILabel *settingHeaderLabel;
@property (strong, nonatomic) IBOutlet UILabel *visitLabel;
@property (strong, nonatomic) IBOutlet UILabel *sectionLabel;
@property (strong, nonatomic) IBOutlet UILabel *intervalLabel;
@property (strong, nonatomic) IBOutlet UILabel *completedLabel;
@property (strong, nonatomic) IBOutlet UIButton *AddButton;
@property (strong, nonatomic) IBOutlet UIButton *completedCheckBox;
@property (strong, nonatomic) IBOutlet UITextField *intervalTF;
@property (strong, nonatomic) IBOutlet UITextField *visitTF;
-(void)alphaViewInitialize;
@end
