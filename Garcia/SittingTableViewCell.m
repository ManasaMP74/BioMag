#import "SittingTableViewCell.h"

@implementation SittingTableViewCell
- (void)awakeFromNib {
    self.sittingTextView.delegate=self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)expandableButtonAction:(id)sender {
 [self.delegate expandCell:self];

}
- (IBAction)getPreviousSittingDetail:(id)sender {
        [self.delegate expandCellTOGetPreviousSitting:self];
}
- (IBAction)getGermsView:(id)sender {
    [self.delegate getGermsView:self];
}
- (IBAction)checkNoIssues:(id)sender {
    [self.delegate issueAndNoIssue:self];
}

@end
