#import <UIKit/UIKit.h>
#import "CorrespondingPointCell.h"
@interface CorrespondingPointView : UIView<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *correspondingTableView;
-(float)corespondingCellHeight;
@property (strong, nonatomic) IBOutlet CorrespondingPointCell *correspondingCell;
@property(strong,nonatomic)NSArray *correspondingPointArray;
-(void)reload;
@end
