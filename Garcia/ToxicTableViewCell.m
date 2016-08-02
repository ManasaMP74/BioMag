#import "ToxicTableViewCell.h"

@implementation ToxicTableViewCell

- (void)awakeFromNib {
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

   }
- (IBAction)selectTheCell:(id)sender {
    [self.delegate selectedToxicCell:self];
}
- (IBAction)completedSittingSwitch:(id)sender {
    [self.delegate completedSittingByTapOnSwitch];
}

@end
