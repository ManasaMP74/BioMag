#import <UIKit/UIKit.h>
#import "HeaderTableView.h"
@protocol cellHeight<NSObject>
-(void)increaseCellHeight:(float)height withCell:(UICollectionViewCell*)cell withSelectedScanPoint:(NSArray*)selectedScanPointindexpath withHeader:(NSIndexPath*)headerIndex withNoteHeader:(NSIndexPath*)NoteIndex;
-(void)decreaseCellHeight:(float)height withCell:(UICollectionViewCell*)cell withSelectedScanPoint:(NSArray*)selectedScanPointindexpath withHeader:(NSIndexPath*)headerIndex withNoteHeader:(NSIndexPath*)NoteIndex;
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
@property (strong, nonatomic) IBOutlet UIButton *closeSitting;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@end

