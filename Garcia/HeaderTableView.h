#import <UIKit/UIKit.h>
#import "CollectionViewTableViewCell.h"
#import "ScanPoinTableViewCell.h"
#import "CorrespondingPointView.h"
@protocol headerCellHeight<NSObject>
-(void)headCellHeight:(float)height;
@end
@interface HeaderTableView : UIView<UITableViewDataSource,UITableViewDelegate,selectedScanPoint>
@property (strong, nonatomic) IBOutlet CollectionViewTableViewCell *cell;
@property (strong, nonatomic) IBOutlet UITableView *headerTableview;
@property (strong, nonatomic) IBOutlet ScanPoinTableViewCell *scanPointCell;
@property(weak,nonatomic)id<headerCellHeight>delegate;
@end
