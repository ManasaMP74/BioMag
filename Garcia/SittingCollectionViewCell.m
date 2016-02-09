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
@end
