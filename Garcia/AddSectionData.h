#import <UIKit/UIKit.h>

@interface AddSectionData : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@property(strong,nonatomic)NSString *differForSaveData;

-(void)alphaViewInitialize;
@end
