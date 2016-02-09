#import <UIKit/UIKit.h>
#import "CorrespondingPairTableView.h"
@protocol selectedScanpoint<NSObject>
-(void)selectedScanPoint:(UITableViewCell*)cell;
@end
@interface ScanPointTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *scanpointLabel;
@property (weak, nonatomic) IBOutlet UIImageView *scanpointImageView;
@property (weak, nonatomic) IBOutlet UIButton *scanpointCell;
@property(weak,nonatomic)id<selectedScanpoint>delegate;
@property (weak, nonatomic) IBOutlet CorrespondingPairTableView *correspondingPairTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *correspondingViewHeight;
@end
