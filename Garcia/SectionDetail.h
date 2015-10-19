#import <UIKit/UIKit.h>
#import "SectionDetailCell.h"
@interface SectionDetail : UIView
@property (strong, nonatomic) IBOutlet SectionDetailCell *sectionDetailCell;
@property (strong, nonatomic) IBOutlet UILabel *sectionDetailHeadLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableview;

@end
