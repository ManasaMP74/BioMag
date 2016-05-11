#import <UIKit/UIKit.h>

@interface AddAnatomicalPointCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *sectionLabel;
@property (weak, nonatomic) IBOutlet UILabel *scanpointLabel;
@property (weak, nonatomic) IBOutlet UILabel *correspondingpairLabel;
@property (weak, nonatomic) IBOutlet UILabel *code;

@property (weak, nonatomic) IBOutlet UILabel *personalScanpointOrCorrespondingPairLabel;
@property (weak, nonatomic) IBOutlet UILabel *personalScanpointOrCorrespondingPairSortLabel;
@property (weak, nonatomic) IBOutlet UILabel *personalScanpointOrCorrespondingPairLocLabel;
@end
