#import <UIKit/UIKit.h>
#import "AddSectionCell.h"
//#import "SectionModelOne.h"
@interface AddSection : UIView <UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *sectionHeaderLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) IBOutlet AddSectionCell *addsectionCell;
@property (strong, nonatomic) NSArray *allSections,*allScanPointsArray;
-(void)alphaViewInitialize;


@end
