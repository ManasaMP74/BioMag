#import <UIKit/UIKit.h>
#import "ScanPointCell.h"
@interface CorrespondPoint : UITableView
@property (strong, nonatomic) IBOutlet ScanPointCell *scanPointCell;
@property (strong, nonatomic) IBOutlet ScanPointView *scanPointTableView;

@end
