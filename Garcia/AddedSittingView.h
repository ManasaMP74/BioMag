#import <UIKit/UIKit.h>
#import "AddedSittingViewTableViewCell.h"
@interface AddedSittingView : UIView<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet AddedSittingViewTableViewCell *customCell;

@property(strong,nonatomic)NSArray *selectedSittingPair;
@property(strong,nonatomic)NSArray *heightOfEachCellArray;
@property (weak, nonatomic) IBOutlet UILabel *sectionLabel;
@property (weak, nonatomic) IBOutlet UILabel *scanpointLabel;
@property (weak, nonatomic) IBOutlet UILabel *correspondingPairLabel;
@property (weak, nonatomic) IBOutlet UILabel *locOfScanPoint;
@property (weak, nonatomic) IBOutlet UILabel *locOfCorrespondingPair;
@end
