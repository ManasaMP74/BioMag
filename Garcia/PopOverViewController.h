#import <UIKit/UIKit.h>
#import "lagModel.h"
@protocol selectedObjectInPop<NSObject>
-(void)selectedObject:(lagModel*)model;
@end
@interface PopOverViewController : UITableViewController
@property(weak,nonatomic)id <selectedObjectInPop>delegate;
-(float)getHeightOfTableView;
@property(strong,nonatomic)NSArray *lagArray;
@end
