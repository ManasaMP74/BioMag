#import <UIKit/UIKit.h>
#import "SymptomTagCustomCollectionViewCell.h"
@protocol addsymptom<NSObject>
-(void)addsymptom:(NSArray*)array;
@end
@interface AddSymptom : UIView<deleteCell,UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITextField *symptomTf;
@property(weak,nonatomic)id<addsymptom>delegate;
-(void)alphaViewInitialize;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeight;
@property (strong, nonatomic) IBOutlet UIButton *addButton;
@property (strong, nonatomic) IBOutlet UITableView *allTaglistTableView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *allTagListTableViewHeight;
@property(assign,nonatomic)CGFloat heightOfView;
@end
