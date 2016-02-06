#import "ScanPointTableViewCell.h"

@implementation ScanPointTableViewCell

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (IBAction)selectedScanPoint:(id)sender {

    [self.delegate selectedScanPoint:self];
}

@end
