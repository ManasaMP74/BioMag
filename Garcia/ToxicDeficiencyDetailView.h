#import <UIKit/UIKit.h>
#import "ToxicDeficiencyCell.h"
@interface ToxicDeficiencyDetailView : UIView
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet ToxicDeficiencyCell *customCell;
@property(strong,nonatomic)NSString *selectedToxicCode;
@end
