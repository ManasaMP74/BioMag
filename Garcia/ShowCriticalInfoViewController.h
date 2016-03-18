#import <UIKit/UIKit.h>

@interface ShowCriticalInfoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property(strong,nonatomic)NSArray *CriticalInfoArray;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableviewHeight;
@end
