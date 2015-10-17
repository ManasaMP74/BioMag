#import "PatientSheetViewController.h"
#import "Constant.h"
#import "PatientSheetTableViewCell.h"
@interface PatientSheetViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *genderLabel;
@property (strong, nonatomic) IBOutlet UILabel *martiralStatus;
@property (strong, nonatomic) IBOutlet UILabel *dobLabel;
@property (strong, nonatomic) IBOutlet UILabel *ageLabel;
@property (strong, nonatomic) IBOutlet UILabel *genderValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *mariedValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *dobValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *ageValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *emailLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UILabel *emailValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *patientDetailLabel;
@property (strong, nonatomic) IBOutlet UILabel *medicalHistoryLabel;
@property (strong, nonatomic) IBOutlet UITextView *medicalHistoryTextView;
@property (strong, nonatomic) IBOutlet UIButton *uploadButton;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;
@property (strong, nonatomic) IBOutlet UITableView *MedicaltableView;
@property (strong, nonatomic) IBOutlet UITableView *diagnosisTableView;
@property (strong, nonatomic) IBOutlet UILabel *diagnosisLabel;
@property (strong, nonatomic) IBOutlet UILabel *settingLabel;
@property (strong, nonatomic) IBOutlet UILabel *uploadLabel;
@property (strong, nonatomic) IBOutlet UILabel *symptomtagLabel;
@property (strong, nonatomic) IBOutlet UITextField *treatmentNameTF;
@property (strong, nonatomic) IBOutlet UILabel *treatmentEnclosure;
@property (strong, nonatomic) IBOutlet UITextField *symptomtagTF;
@property (strong, nonatomic) IBOutlet UITextView *treatmentEncloserTextView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *medicalHistoryViewHeight;
@property (strong, nonatomic) IBOutlet UIView *medicalHistoryView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *diagnosisViewHeight;
@property (strong, nonatomic) IBOutlet UIView *diagnosisView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *settingViewHeight;
@property (strong, nonatomic) IBOutlet UIButton *increasePatientViewButton;
@property (strong, nonatomic) IBOutlet UIButton *increaseMedicalViewButton;
@property (strong, nonatomic) IBOutlet UIButton *increaseDiagnosisViewButton;
@property (strong, nonatomic) IBOutlet UIButton *increasesettingViewButton;
@property (strong, nonatomic) IBOutlet UIButton *increaseUploadViewButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *uploadViewHeigh;
@property (strong, nonatomic) IBOutlet UIView *uploadView;
@property (strong, nonatomic) IBOutlet UIButton *increaseSymptomViewButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *symptomViewHeight;
@property (strong, nonatomic) IBOutlet UIView *symptomView;
@property (strong, nonatomic) IBOutlet UIView *settingView;
@property (strong, nonatomic) IBOutlet UIButton *increaseTreatmentViewButton;
@property (strong, nonatomic) IBOutlet UITextView *diagnosisTextView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *treatmentCloserViewHeight;
@property (strong, nonatomic) IBOutlet UIView *treatmentclosureView;
@end

@implementation PatientSheetViewController
{
    Constant *constant;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    constant=[[Constant alloc]init];
    [self defaultValue];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}
- (IBAction)increaseViewHeightOfPatientView:(id)sender {

}
- (IBAction)upload:(id)sender {
    if ([_increaseUploadViewButton.backgroundColor isEqual:[UIColor grayColor]]) {
        _uploadView.hidden=NO;
        _uploadViewHeigh.constant=99;
        [self setButtonColor:_increaseUploadViewButton];
    }
    else{
        _diagnosisView.hidden=YES;
        _diagnosisViewHeight.constant=0;
        [self setButtonColor:_increaseUploadViewButton];
    }
}
- (IBAction)saveMedicalHistory:(id)sender {

}
- (IBAction)increaseDiagnosisView:(id)sender {
    if ([_increaseDiagnosisViewButton.backgroundColor isEqual:[UIColor grayColor]]) {
        _diagnosisView.hidden=NO;
        _diagnosisViewHeight.constant=250;
        [self setButtonColor:_increaseDiagnosisViewButton];
    }
    else{
        _diagnosisView.hidden=YES;
        _diagnosisViewHeight.constant=0;
        [self setButtonColor:_increaseDiagnosisViewButton];
    }
}
- (IBAction)recordMedicalHistory:(id)sender {
}
- (IBAction)increaseViewHeightOfMedicalHistort:(id)sender {
    if ([_increaseMedicalViewButton.backgroundColor isEqual:[UIColor grayColor]]) {
        _medicalHistoryView.hidden=NO;
        _medicalHistoryViewHeight.constant=250;
        [self setButtonColor:_increaseMedicalViewButton];
    }
    else{
        _medicalHistoryView.hidden=YES;
        _medicalHistoryViewHeight.constant=0;
        [self setButtonColor:_increaseMedicalViewButton];
    }
}
- (IBAction)saveDiagnosisTextViewValue:(id)sender {
}
- (IBAction)increaseSettingView:(id)sender {
    if ([_increasesettingViewButton.backgroundColor isEqual:[UIColor grayColor]]) {
        _settingView.hidden=NO;
        _settingViewHeight.constant=111;
        [self setButtonColor:_increasesettingViewButton];
    }
    else{
        _settingView.hidden=YES;
        _settingViewHeight.constant=0;
        [self setButtonColor:_increasesettingViewButton];
    }
}
- (IBAction)buttonSetting:(id)sender {
}
- (IBAction)saveTreatmentEncloser:(id)sender {
}
- (IBAction)closeTreatmentEncloser:(id)sender {
}
- (IBAction)increaseTreatmentEncloser:(id)sender {
    if ([_increaseTreatmentViewButton.backgroundColor isEqual:[UIColor grayColor]]) {
        _treatmentclosureView.hidden=NO;
        _treatmentCloserViewHeight.constant=99;
        [self setButtonColor:_increaseTreatmentViewButton];
    }
    else{
        _treatmentclosureView.hidden=YES;
        _treatmentCloserViewHeight.constant=0;
        [self setButtonColor:_increaseTreatmentViewButton];
    }
}
- (IBAction)increaseSymptomView:(id)sender {
    if ([_increaseSymptomViewButton.backgroundColor isEqual:[UIColor grayColor]]) {
        _symptomView.hidden=NO;
        _symptomViewHeight.constant=250;
        [self setButtonColor:_increaseSymptomViewButton];
    }
    else{
        _symptomView.hidden=YES;
        _symptomViewHeight.constant=0;
        [self setButtonColor:_increaseSymptomViewButton];
    }
}
- (IBAction)increaseuploadView:(id)sender {
    if ([_increaseUploadViewButton.backgroundColor isEqual:[UIColor grayColor]]) {
        _uploadView.hidden=NO;
        _uploadViewHeigh.constant=250;
        [self setButtonColor:_increaseUploadViewButton];
    }
    else{
        _uploadView.hidden=YES;
        _uploadViewHeigh.constant=0;
        [self setButtonColor:_increaseUploadViewButton];
    }
}
-(void)setButtonColor:(UIButton*)btn{
    if ([btn.backgroundColor isEqual:[UIColor blackColor]]) {
        btn.backgroundColor=[UIColor grayColor];
    }
  else  if ([btn.backgroundColor isEqual:[UIColor grayColor]]) {
        btn.backgroundColor=[UIColor blackColor];
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PatientSheetTableViewCell *cell;
    if (indexPath.row==0) {
        cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    }
   else cell=[tableView dequeueReusableCellWithIdentifier:@"cell1"];
    [constant setFontForLabel:cell.dateLabel];
     [constant setFontForLabel:cell.time];
     [constant setFontForLabel:cell.messageLabel];
     [constant setFontForLabel:cell.timeValueLabel];
     [constant setFontForLabel:cell.dateValueLabel];
     [constant setFontForLabel:cell.messageValueLabel];
    return cell;
}
-(void)defaultValue{
    [constant SetBorderForTextField:_symptomtagTF];
    [constant spaceAtTheBeginigOfTextField:_symptomtagTF];
    _medicalHistoryView.hidden=YES;
    _medicalHistoryViewHeight.constant=0;
    _diagnosisView.hidden=YES;
    _diagnosisViewHeight.constant=0;
    _uploadView.hidden=YES;
    _uploadViewHeigh.constant=0;
    _treatmentclosureView.hidden=YES;
    _treatmentCloserViewHeight.constant=0;
    _symptomView.hidden=YES;
    _symptomViewHeight.constant=0;
    _settingView.hidden=YES;
    _settingViewHeight.constant=0;
    _increaseDiagnosisViewButton.backgroundColor=[UIColor grayColor];
    _increaseMedicalViewButton.backgroundColor=[UIColor grayColor];
    _increasePatientViewButton.backgroundColor=[UIColor grayColor];
    _increasesettingViewButton.backgroundColor=[UIColor grayColor];
    _increaseSymptomViewButton.backgroundColor=[UIColor grayColor];
    _increaseTreatmentViewButton.backgroundColor=[UIColor grayColor];
    _increaseUploadViewButton.backgroundColor=[UIColor grayColor];
    [constant setFontForLabel:_genderLabel];
    [constant setFontForLabel:_emailLabel];
    [constant setFontForLabel:_addressLabel];
    [constant setFontForLabel:_ageLabel];
    [constant setFontForLabel:_dobLabel];
    [constant setFontForLabel:_martiralStatus];
    [constant setFontForLabel:_genderValueLabel];
    [constant setFontForLabel:_emailValueLabel];
    [constant setFontForLabel:_addressValueLabel];
    [constant setFontForLabel:_ageValueLabel];
    [constant setFontForLabel:_dobValueLabel];
    [constant setFontForLabel:_mariedValueLabel];
    _treatmentNameTF.attributedPlaceholder=[constant textFieldPlaceHolderText:@"Treatment Name"];
    [constant spaceAtTheBeginigOfTextField:_treatmentNameTF];
    [constant SetBorderForTextview:_treatmentEncloserTextView];
    [constant SetBorderForTextview:_medicalHistoryTextView];
    [constant SetBorderForTextview:_diagnosisTextView];
}
@end
