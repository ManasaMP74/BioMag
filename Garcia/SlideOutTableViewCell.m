#import "SlideOutTableViewCell.h"

@implementation SlideOutTableViewCell

- (void)awakeFromNib {
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
- (IBAction)getSection:(id)sender {
    [self.delegate expandCellToGetSectionName:self];
}

@end
