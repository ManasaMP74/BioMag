#import <UIKit/UIKit.h>
#import "CollectionViewTableViewCell.h"
#import "ScanPoinTableViewCell.h"
#import "CorrespondingPointView.h"
@protocol headerCellHeight<NSObject>
-(void)increaseHeadCellHeight:(float)height withSelectedScanPoint:(NSArray*)scanPointindexPath;
-(void)decreaseHeadCellHeight:(float)height withSelectedScanPoint:(NSArray*)scanPointindexPath;
@end
@interface HeaderTableView : UIView<UITableViewDataSource,UITableViewDelegate,selectedScanPoint>
@property (strong, nonatomic) IBOutlet CollectionViewTableViewCell *cell;
@property (strong, nonatomic) IBOutlet UITableView *headerTableview;
@property (strong, nonatomic) IBOutlet ScanPoinTableViewCell *scanPointCell;
@property(weak,nonatomic)id<headerCellHeight>delegate;

-(float)increaseHeaderinHeaderTV :(NSArray*)indexpath;
-(float)decreaseHeaderinHeaderTV :(NSArray*)indexpath;
@end
