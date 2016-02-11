#import <UIKit/UIKit.h>
#import "lagModel.h"
@protocol selectedObjectInPop<NSObject>
-(void)selectedObject:(lagModel*)model;
-(void)selectedSlideOutObject:(NSString *)name;
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
