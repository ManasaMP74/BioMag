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
-(void)selectedCell:(NSString*)selectedHeader{
    [self.delegate selectedHeaderCell:selectedHeader withcell:self];
}
-(void)deselectedCell:(NSString*)deselectedHeader{
    [self.delegate deselectedHeaderCell:deselectedHeader withcell:self];
}
@end
