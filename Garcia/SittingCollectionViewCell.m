#import "SittingCollectionViewCell.h"

@implementation SittingCollectionViewCell

- (void)awakeFromNib
{
    self.headerView.delegate = self;
}
-(void)increaseHeadCellHeight:(float)height withSelectedScanPoint:(NSArray *)scanPointindexPath withHeader:(NSIndexPath*)headerIndex withNoteHeader:(NSIndexPath*)NoteIndex{
    [self.delegate increaseCellHeight:height withCell:self withSelectedScanPoint:scanPointindexPath withHeader:headerIndex withNoteHeader:NoteIndex];
}
-(void)decreaseHeadCellHeight:(float)height withSelectedScanPoint:(NSArray *)scanPointindexPath withHeader:(NSIndexPath*)headerIndex withNoteHeader:(NSIndexPath*)NoteIndex{
    [self.delegate decreaseCellHeight:height withCell:self withSelectedScanPoint:scanPointindexPath withHeader:headerIndex withNoteHeader:NoteIndex];
}
- (IBAction)closeSittingCell:(id)sender {
    [self.delegate deleteSittingCell:self];
}
- (IBAction)editSitting:(id)sender {
    [self.delegate editSittingCell:self];
}
@end
