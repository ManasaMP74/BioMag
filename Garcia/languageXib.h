#import <UIKit/UIKit.h>
#import "LanguageTableViewCell.h"

@interface LanguageXib : uivi<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
-(void)alphaViewInitialize;
@property (strong, nonatomic) IBOutlet LanguageTableViewCell *customCell;
@end
