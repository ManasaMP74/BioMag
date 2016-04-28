#import <UIKit/UIKit.h>
#import "VMEnvironment.h"
#import "sittingModel.h"
@protocol editAnatomicalPointSucceed<NSObject>
-(void)successOfEditAnatomicalPoint;
@end
@interface EditAnatomicalPoint : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *mapAnotomicalLabel;
@property (weak, nonatomic) IBOutlet UILabel *anotomicalScanpointNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *anotomicalCorrespondingLabel;
@property (weak, nonatomic) IBOutlet UILabel *anotomicalSortNumberLabel;
@property (weak, nonatomic) IBOutlet UITextField *anatomicalScanpointTF;
@property (weak, nonatomic) IBOutlet UITextField *anatomicalCorrespondingPairTF;
@property (weak, nonatomic) IBOutlet UITextField *anatomicalSortNumberTF;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTV;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *selectScanpoint;
@property (weak, nonatomic) IBOutlet UIButton *selectCorrespondinPair;
@property (weak, nonatomic) IBOutlet UITableView *scanpointTable;
@property (weak, nonatomic) IBOutlet UITableView *correspondingPairTable;
@property (weak, nonatomic) IBOutlet UILabel *anatomicalSectionLabel;
@property (weak, nonatomic) IBOutlet UITextField *anatomicalSectionTF;
@property (weak, nonatomic) IBOutlet UIButton *anatomicalSelectSection;
@property (weak, nonatomic) IBOutlet UILabel *anatomicalGermsLabel;
@property (weak, nonatomic) IBOutlet UITextField *anatomicalGermsTF;
@property (weak, nonatomic) IBOutlet UIButton *selectGerms;
@property (weak, nonatomic) IBOutlet UILabel *anatomicalAuthorLabel;
@property (weak, nonatomic) IBOutlet UITextField *anatomicalAuthorTF;
@property (weak, nonatomic) IBOutlet UIButton *selectAuthor;
@property (weak, nonatomic) IBOutlet UITableView *authorTableView;
@property (weak, nonatomic) IBOutlet UITableView *germsTableView;
@property (weak, nonatomic) IBOutlet UITableView *sectionTableview;
@property (weak, nonatomic) IBOutlet UITableView *langTable;
@property (weak, nonatomic) IBOutlet UIButton *langButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *langTableHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *langTableWidth;
@property (weak, nonatomic) IBOutlet UIControl *view1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *authorTVHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *germsTVHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *correspondingTVHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scanpointTvHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sectionTvHeight;

@property(strong,nonatomic)sittingModel *selectedPersonalAnatomicalPair;
@property (weak, nonatomic)id <editAnatomicalPointSucceed>delegate;
@end
