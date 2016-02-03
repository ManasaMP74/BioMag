#import "SymptomTagCollectionViewCell.h"

@implementation SymptomTagCollectionViewCell

- (IBAction)deleteCell:(id)sender {
    [self.delegate deleteCell:self];
}
@end
