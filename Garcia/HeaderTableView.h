#import <UIKit/UIKit.h>
#import "CollectionViewTableViewCell.h"
@protocol headerCellHeight<NSObject>
-(void)headCellHeight;
@end
@interface HeaderTableView : UIView<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet CollectionViewTableViewCell *cell;
@property (strong, nonatomic) IBOutlet UITableView *headerTableview;
@property(weak,nonatomic)id<headerCellHeight>delegate;
@end
