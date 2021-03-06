#import <UIKit/UIKit.h>
#import "ShowCriticalInfoListModel.h"
#import "VMEnvironment.h"
@protocol DeleteCriticalImageProtocol<NSObject>
@optional
-(void)callSearchApiAfterAddNewCriticalInfo;
@end
@interface CriticalTreatmentInfoViewController : UIViewController

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionviewHeight;
@property(strong,nonatomic)NSArray *addedcriticalArray;
@property(strong,nonatomic)NSString *summary;
@property(strong,nonatomic)NSString *descriptionvalue;
@property(strong,nonatomic)ShowCriticalInfoListModel *criticalInfoModel;
@property (weak, nonatomic) id <DeleteCriticalImageProtocol>delegate;

@property(strong,nonatomic)NSString *differOfAddOrEdit;
@end
