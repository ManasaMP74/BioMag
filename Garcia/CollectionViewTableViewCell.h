#import <UIKit/UIKit.h>
#import "HeaderTableViewModelClass.h"
@protocol getTableViewHeight<NSObject>
-(void)HeaderTableViewHeight:(UIImage*)image;
@end
@interface CollectionViewTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *headLabel;
@property (strong, nonatomic) IBOutlet UIButton *headIncreaseButton;
@property(weak,nonatomic)id<getTableViewHeight>delegate;
@property (strong, nonatomic) IBOutlet UILabel *intervalLabel;
@property (strong, nonatomic) IBOutlet UIImageView *switchImageView;
@property(strong,nonatomic)HeaderTableViewModelClass *headerModel;
@end
