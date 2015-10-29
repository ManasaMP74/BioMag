#import <UIKit/UIKit.h>
#import "ScanPointView.h"
@protocol getTableViewHeight<NSObject>
-(void)HeaderTableViewHeight:(UIImage*)image;
@end
@interface CollectionViewTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *headLabel;
@property (strong, nonatomic) IBOutlet UIButton *headIncreaseButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *scanPointViewHeight;
@property (strong, nonatomic) IBOutlet ScanPointView *scanPointView;
@property(weak,nonatomic)id<getTableViewHeight>delegate;
@property (strong, nonatomic) IBOutlet ScanPointView *view;
@end
