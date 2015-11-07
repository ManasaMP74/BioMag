#import <UIKit/UIKit.h>
#import "HeaderTableView.h"
@protocol cellHeight<NSObject>
-(void)increaseCellHeight:(float)height withCell:(UICollectionViewCell*)cell withSelectedScanPoint:(NSArray*)selectedScanPointindexpath withHeader:(NSIndexPath*)headerIndex;
-(void)decreaseCellHeight:(float)height withCell:(UICollectionViewCell*)cell withSelectedScanPoint:(NSArray*)selectedScanPointindexpath withHeader:(NSIndexPath*)headerIndex;
-(void)deleteSittingCell:(UICollectionViewCell*)cell;
-(void)editSittingCell:(UICollectionViewCell*)cell;
@end
@interface SittingCollectionViewCell : UICollectionViewCell<headerCellHeight>
@property (strong, nonatomic) IBOutlet UILabel *visitLabel;
@property (strong, nonatomic) IBOutlet UILabel *sittingLabel;
@property (strong, nonatomic) IBOutlet UILabel *visitDateLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *headerViewHeight;
@property (strong, nonatomic) IBOutlet HeaderTableView *headerView;
@property(weak,nonatomic)id<cellHeight>delegate;
@end

