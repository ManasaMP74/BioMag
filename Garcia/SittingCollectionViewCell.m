#import "SittingCollectionViewCell.h"

@implementation SittingCollectionViewCell

- (void)awakeFromNib
{
    self.headerView.delegate = self;
}
-(void)increaseHeadCellHeight:(float)height withSelectedScanPoint:(NSArray *)scanPointindexPath withHeader:(NSIndexPath*)headerIndex{
 [self.delegate increaseCellHeight:height withCell:self withSelectedScanPoint:scanPointindexPath withHeader:headerIndex];
}
-(void)decreaseHeadCellHeight:(float)height withSelectedScanPoint:(NSArray *)scanPointindexPath withHeader:(NSIndexPath*)headerIndex{
 [self.delegate decreaseCellHeight:height withCell:self withSelectedScanPoint:scanPointindexPath withHeader:headerIndex];
}
- (IBAction)closeSittingCell:(id)sender {
    [self.delegate deleteSittingCell:self];
}
- (IBAction)editSitting:(id)sender {
    [self.delegate editSittingCell:self];
}
@end
