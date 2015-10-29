#import <UIKit/UIKit.h>
#import "HeaderTableView.h"
@interface SittingCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *visitLabel;
@property (strong, nonatomic) IBOutlet UILabel *sittingLabel;
@property (strong, nonatomic) IBOutlet UILabel *visitDateLabel;
@property (strong, nonatomic) IBOutlet UITableView *headTableView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *headTableViewHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *headerViewHeight;
@property (strong, nonatomic) IBOutlet HeaderTableView *headerView;
@end
