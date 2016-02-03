#import <UIKit/UIKit.h>
#import "SectionXibTableViewCell.h"
#import "sittingModel.h"
@protocol getSectionNameProtocol<NSObject>
-(void)getSectionName:(NSString*)str withIndex:(NSIndexPath*)index withCellIndex:(int)i;
@end
@interface SectionXibView : UIView<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet SectionXibTableViewCell *sectionXibCell;
@property(weak,nonatomic)id<getSectionNameProtocol>delegateForGetName;
-(CGFloat)getHeightOfView;
-(void)reloadData:(NSArray*)array withIndex:(int)i;
@end
