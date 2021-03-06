#import <UIKit/UIKit.h>
#import "SymptomTagCustomCollectionViewCell.h"
#import "searchPatientModel.h"
#import "VMEnvironment.h"
@protocol addsymptom<NSObject>
-(void)addsymptom:(NSArray*)array;
@end
@interface AddSymptom : UIView<deleteCell,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
@property (strong, nonatomic) IBOutlet UITextField *symptomTf;
@property(weak,nonatomic)id<addsymptom>delegate;
-(void)alphaViewInitialize;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeight;
@property(strong,nonatomic)searchPatientModel *searchModel;
@property (strong, nonatomic) IBOutlet UIButton *addButton;
@property (strong, nonatomic) IBOutlet UITableView *allTaglistTableView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *allTagListTableViewHeight;
@property(assign,nonatomic)CGFloat heightOfView;
@property (weak, nonatomic) IBOutlet UILabel *symptomsLabel;

@property (strong, nonatomic)NSArray *completeSymptomTagDetailArray;
@end
