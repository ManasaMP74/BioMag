#import "TagCollectionViewCell.h"

@implementation TagCollectionViewCell
- (IBAction)tagButton:(id)sender {
 [_delegate deleteTagCell:self];
}

@end
