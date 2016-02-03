#import "SearchPatientTableViewCell.h"
#import "Constant.h"
@implementation SearchPatientTableViewCell
{
    Constant *constant;
}
- (void)awakeFromNib {
    constant=[[Constant alloc]init];
    self.patientImageView.layer.cornerRadius=self.patientImageView.frame.size.width/2;
    self.patientImageView.clipsToBounds=YES;
    [constant setFontForLabel:self.patientNameLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
