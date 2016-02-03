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
    if (![_sittingNumber.text isEqualToString:@"S1"]) {
        [self.delegate expandCellTOGetPreviousSitting:self];
    }
}
- (IBAction)getGermsView:(id)sender {
    [self.delegate getGermsView:self];
}
- (IBAction)checkNoIssues:(id)sender {
    if ([_checkBox.currentBackgroundImage isEqual:[UIImage imageNamed:@"issue-Button"]]) {
        [_checkBox setBackgroundImage:[UIImage imageNamed:@"no-issue-Button"] forState:normal];
        [_checkBox setTitle:@"No issues" forState:normal];
    }else {
     [_checkBox setBackgroundImage:[UIImage imageNamed:@"issue-Button"] forState:normal];
         [_checkBox setTitle:@"Issues" forState:normal];
    }
}

@end
