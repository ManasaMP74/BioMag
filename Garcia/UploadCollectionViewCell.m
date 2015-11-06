#import "UploadCollectionViewCell.h"

@implementation UploadCollectionViewCell

- (IBAction)deleteCell:(id)sender {
    [_delegate deleteCell:self];
}
@end
