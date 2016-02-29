#import <UIKit/UIKit.h>
#import "ScanPointTableViewCell.h"
#import "HeaderTableViewCell.h"
#import "SittingModelClass.h"
@protocol selectedCellProtocol<NSObject>
-(void)selectedCell:(NSString*)selectedHeader withCorrespondingHeight:(CGFloat)height;
-(void)deselectedCell:(NSString*)deselectedHeader withCorrespondingHeight:(CGFloat)height;
@end
@interface HeaderTableVIew : UIView<UITableViewDataSource,UITableViewDelegate,selectedcell,selectedScanpoint>
@property (strong, nonatomic) IBOutlet ScanPointTableViewCell *scapointCell;
@property (strong, nonatomic) IBOutlet HeaderTableViewCell *headerCell;
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property(strong,nonatomic)SittingModelClass *model;
-(void)gettheSection;
-(float)getTHeHeightOfTableVIew;


@property(strong,nonatomic)NSArray *toxicDeficiencyDetailArray;
@property(strong,nonatomic)NSArray *toxicDeficiencyTypeArray;
@property(strong,nonatomic)NSArray *sittingArray;
@property(strong,nonatomic)NSArray *germsArray;

@property(weak,nonatomic)id<selectedCellProtocol>delegate;
@end
