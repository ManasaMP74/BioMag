#import <UIKit/UIKit.h>
@protocol selectedScanpoint<NSObject>
-(void)selectedScanPoint:(UITableViewCell*)cell;
@end
@interface ScanPointTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *scanpointLabel;
@property (weak, nonatomic) IBOutlet UIImageView *scanpointImageView;
@property (weak, nonatomic) IBOutlet UIButton *scanpointCell;
@property(weak,nonatomic)id<selectedScanpoint>delegate;
@end
