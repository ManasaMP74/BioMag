#import <UIKit/UIKit.h>
#import "UIImageView+AFNetworking.h"
#import "ToxicDeficiencyDetailView.h"
#if !defined(MAX)
#define MAX(A,B)((A) > (B) ? (A) : (B))
#endif
@protocol increaseSittingCell<NSObject>
-(void)uploadImageAfterSaveInSitting:(NSString*)code;
-(void)loadTreatMentFromSittingPart:(NSString*)idvalue;
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
@property (weak, nonatomic) IBOutlet UIButton *saveToxicDeficiency;
@property (weak, nonatomic) IBOutlet ToxicDeficiencyDetailView *toxicView;
@property (weak, nonatomic) IBOutlet UIView *scanPointHeaderView;

//Data from parentView;
@property(strong,nonatomic)NSString *SortType;
@property(strong,nonatomic)NSString *sectionName;
@property(strong,nonatomic)NSIndexPath *selectedIndexPathOfSectionInSlideOut;
@property(weak,nonatomic)id<increaseSittingCell>delegateForIncreasingSitting;
@property(strong,nonatomic)NSString *toxicDeficiencyString;
@property(strong,nonatomic)NSString *editOrAddSitting;
@end
