#import <UIKit/UIKit.h>
#import "VMEnvironment.h"
@interface ShowCriticalInfoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property(strong,nonatomic)NSArray *CriticalInfoArray;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *addCriticalInfo;
@property (weak, nonatomic) IBOutlet UIButton *criticalInfoLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionviewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *summaryTVHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *desTVHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailViewHeight;

@end
