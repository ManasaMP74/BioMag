#import <UIKit/UIKit.h>
#if !defined(MAX)
#define MAX(A,B)((A) > (B) ? (A) : (B))
#endif



@interface PatientSheetViewController : UIViewController<UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollview;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeight;
@property (strong, nonatomic) IBOutlet UIButton *treatmentButton;
@property (strong, nonatomic) IBOutlet UIView *patientLabelView;
@property (strong, nonatomic) IBOutlet UIView *medicalHistoryLabelView;
@property (strong, nonatomic) IBOutlet UIView *diagnosisLabelView;
@property (strong, nonatomic) IBOutlet UIView *settingLabelView;
@property (strong, nonatomic) IBOutlet UIView *uploadLabelView;
@property (strong, nonatomic) IBOutlet UIView *symptomLabelView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *sittingCollectionViewWidth;
@property (strong, nonatomic) IBOutlet UIView *treatmentClosureLabelView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *sittingcollectionViewHeight;
@property (strong, nonatomic) IBOutlet UIButton *takePic;
@property (strong, nonatomic) IBOutlet UIButton *album;
@property(strong,nonatomic)NSString *TitleName;
@property (strong, nonatomic) IBOutlet UICollectionView *uploadCollectionView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *uploadCollectionViewHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *uploadCollectionViewWidth;
@end
