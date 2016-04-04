#import <UIKit/UIKit.h>
#import "VMEnvironment.h"
@interface AddAnotomicalPointsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *addScanpointLabel;
@property (weak, nonatomic) IBOutlet UILabel *scanponitNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *scanpointLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *addCorrespondingPairLabel;
@property (weak, nonatomic) IBOutlet UILabel *correspondingPairNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *correspondingPairLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *mapAnotomicalLabel;
@property (weak, nonatomic) IBOutlet UILabel *anotomicalScanpointNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *anotomicalCorrespondingLabel;
@property (weak, nonatomic) IBOutlet UILabel *anotomicalSortNumberLabel;
@property (weak, nonatomic) IBOutlet UITextField *scanpointNameTF;
@property (weak, nonatomic) IBOutlet UITextField *scanpointLocationTF;
@property (weak, nonatomic) IBOutlet UIButton *saveScanpointBtn;
@property (weak, nonatomic) IBOutlet UITextField *correspondingNameTF;
@property (weak, nonatomic) IBOutlet UITextField *correspondingLocationTF;
@property (weak, nonatomic) IBOutlet UIButton *saveCorresponding;
@property (weak, nonatomic) IBOutlet UITextField *anatomicalNameTF;
@property (weak, nonatomic) IBOutlet UITextField *anatomicalLocationTF;
@property (weak, nonatomic) IBOutlet UITextField *anatomicalSortNumberTF;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTV;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@end
