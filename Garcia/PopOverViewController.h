#import <UIKit/UIKit.h>
@protocol selectedObjectInPop<NSObject>
-(void)selectedObject;
@end
@interface PopOverViewController : UITableViewController
@property(weak,nonatomic)id <selectedObjectInPop>delegate;
-(float)getHeightOfTableView;
@end
