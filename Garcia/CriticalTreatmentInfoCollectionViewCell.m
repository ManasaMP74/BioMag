#import "CriticalTreatmentInfoCollectionViewCell.h"

@implementation CriticalTreatmentInfoCollectionViewCell
- (IBAction)deleteCell:(id)sender {
    [self.delegate deleteCell:self];

}

@end
