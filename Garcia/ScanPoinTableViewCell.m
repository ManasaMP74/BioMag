#import "ScanPoinTableViewCell.h"

@implementation ScanPoinTableViewCell

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}
- (IBAction)selectCell:(id)sender {
    [self.delegate selectedScanPoint:self];
}

@end
