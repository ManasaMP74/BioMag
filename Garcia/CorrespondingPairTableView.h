#import <UIKit/UIKit.h>
#import "CorrespondingPairTableViewCell.h"
@interface CorrespondingPairTableView : UIView
@property (strong, nonatomic) IBOutlet CorrespondingPairTableViewCell *customCell;
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property(strong,nonatomic)NSArray *correspondingPairNameArray;
@property(strong,nonatomic)NSString *selectedScanpoint;
@end
