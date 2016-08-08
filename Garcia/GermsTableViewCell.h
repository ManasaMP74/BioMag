#import <UIKit/UIKit.h>

@interface GermsTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UIImageView *cellImageView;
@property (weak, nonatomic) IBOutlet UILabel *labelTwo;
@property (weak, nonatomic) IBOutlet UILabel *authorNameLabel;

@end
