#import <UIKit/UIKit.h>
@protocol addedPatient<NSObject>
-(void)successfullyAdded;
@end
@interface AddPatientViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property(weak,nonatomic)id<addedPatient>delegate;
@end
