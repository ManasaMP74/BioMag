#import <UIKit/UIKit.h>
#import "ShowCriticalInfoListModel.h"
@interface ShowDetailOfCriticalInfoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionviewHeight;
@property(strong,nonatomic)ShowCriticalInfoListModel *criticalInfoModel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *summaryTVHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *desTVHeight;

@end
