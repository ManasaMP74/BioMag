#import <UIKit/UIKit.h>
#import "CorrespondingPointView.h"
@protocol selectedScanPoint<NSObject>
-(void)selectedScanPoint:(UITableViewCell*)cell;
@end
@interface ScanPoinTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *scanpointLabel;
@property (strong, nonatomic) IBOutlet UIButton *sacnPointImageView;
@property(weak,nonatomic)id<selectedScanPoint>delegate;
@property (strong, nonatomic) IBOutlet CorrespondingPointView *correspondingView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *correspondingViewHeight;
@property (strong, nonatomic) IBOutlet UIButton *tapOnButton;
@end
