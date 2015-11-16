#import <UIKit/UIKit.h>
#import "CollectionViewTableViewCell.h"
#import "ScanPoinTableViewCell.h"
#import "CorrespondingPointView.h"
#import "SittingModelClass.h"
@protocol headerCellHeight<NSObject>
-(void)increaseHeadCellHeight:(float)height withSelectedScanPoint:(NSArray*)scanPointindexPath withHeader:(NSIndexPath*)headerIndex withNoteHeader:(NSIndexPath*)NoteIndex;
-(void)decreaseHeadCellHeight:(float)height withSelectedScanPoint:(NSArray*)scanPointindexPath withHeader:(NSIndexPath*)headerIndex withNoteHeader:(NSIndexPath*)NoteIndex;
@end
@interface HeaderTableView : UIView<UITableViewDataSource,UITableViewDelegate,selectedScanPoint>
@property (strong, nonatomic) IBOutlet CollectionViewTableViewCell *cell;
@property (strong, nonatomic) IBOutlet UITableView *headerTableview;
@property (strong, nonatomic) IBOutlet ScanPoinTableViewCell *scanPointCell;
@property(weak,nonatomic)id<headerCellHeight>delegate;

-(float)increaseHeaderinHeaderTV :(SittingModelClass*)model;
-(float)decreaseHeaderinHeaderTV :(SittingModelClass*)model;
@property(strong,nonatomic)NSArray *selectedScanPointArrayFromPatientSheet;
@end
