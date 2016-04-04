#import <UIKit/UIKit.h>
#import "lagModel.h"
#import "VMEnvironment.h"
@protocol selectedObjectInPop<NSObject>
-(void)selectedObject:(int)row;
-(void)selectedSlideOutObject:(int)row;
@end
@interface PopOverViewController : UITableViewController
@property(weak,nonatomic)id <selectedObjectInPop>delegate;
-(float)getHeightOfTableView;
@property(strong,nonatomic)NSArray *lagArray;


@property(strong,nonatomic)NSString *buttonName;


//slideout
@property(strong,nonatomic)NSArray *slideoutNameArray;
@property(strong,nonatomic)NSArray *slideoutImageArray;
@end
