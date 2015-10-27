#import <UIKit/UIKit.h>

@interface PatientSheetViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIScrollView *scrollview;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeight;
@property (strong, nonatomic) IBOutlet UIButton *treatmentButton;
@property (strong, nonatomic) IBOutlet UIView *patientLabelView;
@property (strong, nonatomic) IBOutlet UIView *medicalHistoryLabelView;
@property (strong, nonatomic) IBOutlet UIView *diagnosisLabelView;
@property (strong, nonatomic) IBOutlet UIView *settingLabelView;
@property (strong, nonatomic) IBOutlet UIView *uploadLabelView;
@property (strong, nonatomic) IBOutlet UIView *symptomLabelView;
@property (strong, nonatomic) IBOutlet UIView *treatmentClosureLabelView;
@end
