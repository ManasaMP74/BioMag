#import <UIKit/UIKit.h>
#import "SettingView.h"
#import "searchPatientModel.h"
#import "PatientDetailModel.h"
#import "UIImageView+AFNetworking.h"
#import "PatientTitleModel.h"
#if !defined(MAX)
#define MAX(A,B)((A) > (B) ? (A) : (B))
#endif
@protocol loadTreatmentDelegate <NSObject>
-(void)loadTreatment;
@end

@interface PatientSheetViewController : UIViewController<UITextViewDelegate,UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *emailIdHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *surGeriesHeight;
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
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *allTagListTableViewHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *sittingcollectionViewHeight;
@property (strong, nonatomic) IBOutlet UIButton *takePic;
@property (strong, nonatomic) IBOutlet UIButton *album;
@property(strong,nonatomic)PatientDetailModel *patientDetailModel;
@property(strong,nonatomic)PatientTitleModel *patientTitleModel;
@property (strong, nonatomic) IBOutlet UICollectionView *uploadCollectionView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *uploadCollectionViewHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *uploadCollectionViewWidth;
@property(strong,nonatomic)searchPatientModel *model;
@property (strong, nonatomic) IBOutlet UITableView *allTaglistTableView;
@property (strong, nonatomic) IBOutlet UILabel *diagnosisNoteLabel;
@property (strong, nonatomic) IBOutlet UILabel *medicalNoteLabel;
@property (strong, nonatomic) IBOutlet UILabel *addClosureNoteLabel;
@property (strong, nonatomic) IBOutlet UIButton *closeTreatmentClosure;
@property (strong, nonatomic) IBOutlet UIButton *saveTreatmentClosure;
@property (strong, nonatomic) IBOutlet UIButton *addDiagnosis;
@property (strong, nonatomic) IBOutlet UIButton *cancelMedical;
@property (strong, nonatomic) IBOutlet UIButton *addMedical;
@property (strong, nonatomic) IBOutlet UIButton *exit;

@property (strong, nonatomic) IBOutlet UIButton *addSittingButton;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *medicalTVHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *medicalTableHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *diagnosisTableHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *diagnosisTextViewHeight;

@property(strong,nonatomic)NSArray *toxicDeficiencyDetailArray;
@property(strong,nonatomic)NSArray *toxicDeficiencyTypeArray;
@property(strong,nonatomic)NSArray *sittingArray;

@property(weak,nonatomic)id<loadTreatmentDelegate>delegate;



@end
