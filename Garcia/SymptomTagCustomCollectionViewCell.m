#import "SymptomTagCustomCollectionViewCell.h"

@implementation SymptomTagCustomCollectionViewCell
- (IBAction)deleteCell:(id)sender {
    [self.delegate deleteCell:self];
}

@end
