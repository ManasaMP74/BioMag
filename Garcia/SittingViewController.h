#import <UIKit/UIKit.h>
#import "UIImageView+AFNetworking.h"
#import "ToxicDeficiencyDetailView.h"
#import "searchPatientModel.h"
#import "VMEnvironment.h"
#import "AddedSittingView.h"
#if !defined(MAX)
#define MAX(A,B)((A) > (B) ? (A) : (B))
#endif
@protocol increaseSittingCell<NSObject>
-(void)uploadImageAfterSaveInSitting:(NSString*)code;
-(void)loadTreatMentFromSittingPart:(NSString*)idvalue withTreatmentCode:(NSString*)treatmentCode;
@end
@interface SittingViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *addSymptom;
@property (strong, nonatomic) IBOutlet UIImageView *dateImageView;
@property (strong, nonatomic) IBOutlet UIButton *datePicButton;
@property (strong, nonatomic) IBOutlet UILabel *mobileValue;
@property (strong, nonatomic) IBOutlet UILabel *transfusionValue;
@property (strong, nonatomic) IBOutlet UILabel *emailValue;
@property (strong, nonatomic) IBOutlet UILabel *surgeriesValueLabel;
@property (strong, nonatomic) IBOutlet UITextField *priceTf;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *patienViewHeight;
@property (strong, nonatomic) IBOutlet UIImageView *expandPatientViewImageView;
@property (strong, nonatomic) IBOutlet UIView *patientDetailView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *emailValueHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *surgeriesValueHeight;
@property (strong, nonatomic) IBOutlet UIButton *previousBtn;
@property (strong, nonatomic) IBOutlet UIButton *saveBtn;
@property (strong, nonatomic) IBOutlet UIButton *nextBtn;
@property (strong, nonatomic) IBOutlet UIButton *visitDateButton;
@property (strong, nonatomic) IBOutlet UIButton *exit;
@property (weak, nonatomic) IBOutlet ToxicDeficiencyDetailView *toxicView;
@property (weak, nonatomic) IBOutlet UIView *scanPointHeaderView;
@property (weak, nonatomic) IBOutlet AddedSittingView *addedSittingView;

//Data from parentView;
@property(strong,nonatomic)NSString *SortType;
@property(strong,nonatomic)NSString *sectionName;
@property(strong,nonatomic)NSIndexPath *selectedIndexPathOfSectionInSlideOut;
@property(weak,nonatomic)id<increaseSittingCell>delegateForIncreasingSitting;
@property(strong,nonatomic)NSString *toxicDeficiencyString;
@property(strong,nonatomic)NSString *editOrAddSitting;
@property(strong,nonatomic)NSString *treatmentId;
@property(strong,nonatomic)searchPatientModel *searchModel;
@property(strong,nonatomic)NSString *isTreatmntCompleted;
@property(strong,nonatomic)NSString *sittingStringParameterFromParent;
@property(strong,nonatomic)NSDictionary *bioSittingDict;
@property(strong,nonatomic)NSArray *biomagneticAnotomicalPointArray;
@property(strong,nonatomic)NSString *sittingNumber;
@property(strong,nonatomic)NSArray *allAddedBiomagArray;
@property(strong,nonatomic)NSArray *allSymptomTagArray;
@property(strong,nonatomic)NSArray *completeSittingArray;






@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *interpretationLabel;
@property (weak, nonatomic) IBOutlet UILabel *scanpointLabel;
@property (weak, nonatomic) IBOutlet UILabel *CodeLabel;

@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *transfusion;
@property (weak, nonatomic) IBOutlet UILabel *chargeLabel;
@property (weak, nonatomic) IBOutlet UILabel *surgeriesLabel;
@property (weak, nonatomic) IBOutlet UILabel *correspondingPair;
@property (weak, nonatomic) IBOutlet UILabel *psychoemotionalLabel;



//get Data From SlideOut
-(void)sittingFromSlideOut;
-(void)addAnatomicalPointFromSlideout;
-(void)addSectionDataViewInSitting:(NSString *)differForView;
-(void)addedSittingPairViewData;
@end
