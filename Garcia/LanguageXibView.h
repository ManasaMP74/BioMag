#import <UIKit/UIKit.h>
#import "LanguageTableViewCell.h"
@interface LanguageXibView : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableview;
-(void)alphaViewInitialize;
@property (strong, nonatomic) IBOutlet LanguageTableViewCell *customCell;
@end
