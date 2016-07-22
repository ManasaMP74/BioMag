#import <UIKit/UIKit.h>
@protocol selectedToxicCellProtocol<NSObject>
@optional
-(void)selectedToxicCell:(UITableViewCell*)cell;
-(void)completedSittingByTapOnSwitch;
@end
@interface ToxicTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *switchImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewWidth;
@property (weak, nonatomic) IBOutlet UILabel *priceValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *headingLabel;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UISwitch *completedOrNotSwitch;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainButtonTrailing;

@property(weak,nonatomic)id<selectedToxicCellProtocol>delegate;
@end
