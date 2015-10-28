#import <UIKit/UIKit.h>
@protocol getTableViewHeight<NSObject>
-(void)HeaderTableViewHeight;
@end
@interface CollectionViewTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *headLabel;
@property (strong, nonatomic) IBOutlet UILabel *scanPointLabel;
@property (strong, nonatomic) IBOutlet UIButton *headIncreaseButton;
@property (strong, nonatomic) IBOutlet UIButton *scanPointIncreaseButton;
@property (strong, nonatomic) IBOutlet UILabel *completedLabel;
@property (strong, nonatomic) IBOutlet UISwitch *completedSwitch;
@property (strong, nonatomic) IBOutlet UITableView *correspondingPointTableView;
@end
