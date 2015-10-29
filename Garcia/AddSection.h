#import <UIKit/UIKit.h>
#import "AddSectionCell.h"
@interface AddSection : UIView <UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *sectionHeaderLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) IBOutlet AddSectionCell *addsectionCell;
-(void)alphaViewInitialize;
@end
