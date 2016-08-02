#import "SittingCollectionViewCell.h"

@implementation SittingCollectionViewCell

- (void)awakeFromNib
{
    _headerTableView.delegate=self;
}
- (IBAction)closeSittingCell:(id)sender {
    [self.delegate deleteSittingCell:self];
}
- (IBAction)editSitting:(id)sender {
    [self.delegate editSittingCell:self];
}
-(void)selectedCell:(NSString*)selectedHeader withCorrespondingHeight:(CGFloat)height{
    [self.delegate selectedHeaderCell:selectedHeader withcell:self withCorrespondingHeight:height];
}
-(void)deselectedCell:(NSString*)deselectedHeader withCorrespondingHeight:(CGFloat)height{
    [self.delegate deselectedHeaderCell:deselectedHeader withcell:self withCorrespondingHeight:height];
}
-(void)selectedToxicCell:(NSString*)selectedToxicHeader{
    [self.delegate selectedToxicCell1:selectedToxicHeader withcell:self];
}
-(void)deselectedToxicCell:(NSString*)deselectedHeader{
    [self.delegate deselectedToxicCell1:deselectedHeader withcell:self];
}
//-(void)completedSittingByTapOnSwitchFromHeaderCell{
//    [self.delegate completedSittingByTapOnSwitchFromHeaderCell:self];
//}
@end
