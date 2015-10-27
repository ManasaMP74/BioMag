#import <UIKit/UIKit.h>

@interface PatientSheetViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIScrollView *scrollview;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeight;
@property (strong, nonatomic) IBOutlet UIButton *treatmentButton;
@end
