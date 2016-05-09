#import <UIKit/UIKit.h>

@interface AddAnatomicalPointCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *sectionLabel;
@property (weak, nonatomic) IBOutlet UILabel *scanpointLabel;
@property (weak, nonatomic) IBOutlet UILabel *correspondingpairLabel;
@property (weak, nonatomic) IBOutlet UILabel *code;

@property (weak, nonatomic) IBOutlet UILabel *personalScanpointOrCorrespondingPairLabel;
@end
