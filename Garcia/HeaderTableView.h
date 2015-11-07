#import <UIKit/UIKit.h>
#import "CollectionViewTableViewCell.h"
#import "ScanPoinTableViewCell.h"
#import "CorrespondingPointView.h"
@protocol headerCellHeight<NSObject>
-(void)increaseHeadCellHeight:(float)height withSelectedScanPoint:(NSArray*)scanPointindexPath withHeader:(NSIndexPath*)headerIndex;
-(void)decreaseHeadCellHeight:(float)height withSelectedScanPoint:(NSArray*)scanPointindexPath withHeader:(NSIndexPath*)headerIndex;
@end
@interface HeaderTableView : UIView<UITableViewDataSource,UITableViewDelegate,selectedScanPoint>
@property (strong, nonatomic) IBOutlet CollectionViewTableViewCell *cell;
@property (strong, nonatomic) IBOutlet UITableView *headerTableview;
@property (strong, nonatomic) IBOutlet ScanPoinTableViewCell *scanPointCell;
@property(weak,nonatomic)id<headerCellHeight>delegate;

-(float)increaseHeaderinHeaderTV :(NSArray*)indexpath withHeader:(NSIndexPath*)headerIndex;
-(float)decreaseHeaderinHeaderTV :(NSArray*)indexpath withHeader:(NSIndexPath*)headerIndex;
@property(strong,nonatomic)NSArray *selectedScanPointArrayFromPatientSheet;
@end
