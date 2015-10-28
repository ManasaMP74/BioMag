#import "CollectionViewTableViewCell.h"
#import "SittingCollectionViewCell.h"
@implementation CollectionViewTableViewCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
   // UITableView *table
    NSLog(@"%@",[self superview]);

}
- (IBAction)headButton:(id)sender {
}
- (IBAction)scanPointButton:(id)sender {
}

@end
