#import <UIKit/UIKit.h>
#import "VMEnvironment.h"
@protocol successFullAddingAnatomicalPoints<NSObject>
-(void)successFullAddingAnatomicalPoints;
@end


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
@property (weak, nonatomic) IBOutlet UITableView *personalPairTable;
@property (weak, nonatomic) IBOutlet UILabel *personalPair;
@property (weak, nonatomic) IBOutlet UIView *personalPairView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *personalPairViewHeight;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
@property (weak, nonatomic) IBOutlet UITableView *personalScanPointOrCorrespondingPair;

@property (weak, nonatomic) id <successFullAddingAnatomicalPoints>delegate;
@property (strong, nonatomic) NSArray *personalPairArray;
@end
