#import <UIKit/UIKit.h>
#import "ScanPointTableViewCell.h"
#import "HeaderTableViewCell.h"
#import "SittingModelClass.h"
@protocol selectedCellProtocol<NSObject>
-(void)selectedCell:(NSString*)selectedHeader;
-(void)deselectedCell:(NSString*)deselectedHeader;
@end
@interface HeaderTableVIew : UIView<UITableViewDataSource,UITableViewDelegate,selectedcell,selectedScanpoint>
@property (strong, nonatomic) IBOutlet ScanPointTableViewCell *scapointCell;
@property (strong, nonatomic) IBOutlet HeaderTableViewCell *headerCell;
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property(strong,nonatomic)SittingModelClass *model;
-(void)gettheSection;
-(float)getTHeHeightOfTableVIew;
@property(weak,nonatomic)id<selectedCellProtocol>delegate;
@end
