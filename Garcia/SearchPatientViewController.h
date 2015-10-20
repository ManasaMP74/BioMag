#import <UIKit/UIKit.h>
@protocol sendPatientDetailtoContainerVC<NSObject>
-(void)sendData:(NSString*)str;
@end
@interface SearchPatientViewController : UIViewController
@property(weak,nonatomic)id<sendPatientDetailtoContainerVC>delegate;
@end
