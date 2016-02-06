#import <UIKit/UIKit.h>
@protocol selectedcell<NSObject>
-(void)selectedHeaderCell:(UITableViewCell*)cell;
@end
@interface HeaderTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *HeaderImageViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerImageViewWidth;
@property(weak,nonatomic)id<selectedcell>delegate;
@property (weak, nonatomic) IBOutlet UIButton *headerButton;
@end
