#import <UIKit/UIKit.h>
#import "AddedSittingViewTableViewCell.h"
@interface AddedSittingView : UIView<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet AddedSittingViewTableViewCell *customCell;

@property(strong,nonatomic)NSArray *selectedSittingPair;
@end
