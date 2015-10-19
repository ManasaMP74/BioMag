#import "PatientSheetViewController.h"
#import "Constant.h"
#import "PatientSheetTableViewCell.h"
#import "SettingView.h"
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
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *increasePatientViewHeight;
@property (strong, nonatomic) IBOutlet UIView *symptomView;
@property (strong, nonatomic) IBOutlet UIView *settingView;
@property (strong, nonatomic) IBOutlet UIButton *increaseTreatmentViewButton;
@property (strong, nonatomic) IBOutlet UITextView *diagnosisTextView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *treatmentCloserViewHeight;
@property (strong, nonatomic) IBOutlet UIView *treatmentclosureView;
@property (strong, nonatomic) IBOutlet UIView *increasePatientView;
@end

@implementation PatientSheetViewController
{
    Constant *constant;
    SettingView *setingView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    constant=[[Constant alloc]init];
    [self defaultValue];
self.title=@"Patient Sheet";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
//increase the View Height of patient view



- (IBAction)increaseViewHeightOfPatientView:(id)sender {
    if ([_increasePatientViewButton.currentImage isEqual:[UIImage imageNamed:@"Button-Collapse"]]) {
        _increasePatientView.hidden=NO;
        _increasePatientViewHeight.constant=110;
        [self ChangeIncreaseDecreaseButtonImage:_increasePatientViewButton];
    }
    else{
        _increasePatientView.hidden=YES;
        _increasePatientViewHeight.constant=0;
        [self ChangeIncreaseDecreaseButtonImage:_increasePatientViewButton];
    }
}
//increase the View Height of upload view
- (IBAction)upload:(id)sender {
    if ([_increaseUploadViewButton.currentImage isEqual:[UIImage imageNamed:@"Button-Collapse"]]) {
        _uploadView.hidden=NO;
        _uploadViewHeigh.constant=99;
        [self ChangeIncreaseDecreaseButtonImage:_increaseUploadViewButton];
    }
    else{
        _diagnosisView.hidden=YES;
        _diagnosisViewHeight.constant=0;
        [self ChangeIncreaseDecreaseButtonImage:_increaseUploadViewButton];
    }
}
- (IBAction)saveMedicalHistory:(id)sender {

}
//increase the View Height of Daignosis view
- (IBAction)increaseDiagnosisView:(id)sender {
    if ([_increaseDiagnosisViewButton.currentImage isEqual:[UIImage imageNamed:@"Button-Collapse"]]) {
        _diagnosisView.hidden=NO;
        _diagnosisViewHeight.constant=250;
        [self ChangeIncreaseDecreaseButtonImage:_increaseDiagnosisViewButton];
    }
    else{
        _diagnosisView.hidden=YES;
        _diagnosisViewHeight.constant=0;
        [self ChangeIncreaseDecreaseButtonImage:_increaseDiagnosisViewButton];
    }
}
- (IBAction)recordMedicalHistory:(id)sender {
}
//increase the View Height of medical History view
- (IBAction)increaseViewHeightOfMedicalHistort:(id)sender {
    if ([_increaseMedicalViewButton.currentImage isEqual:[UIImage imageNamed:@"Button-Collapse"]]) {
        _medicalHistoryView.hidden=NO;
        _medicalHistoryViewHeight.constant=250;
        [self ChangeIncreaseDecreaseButtonImage:_increaseMedicalViewButton];
    }
    else{
        _medicalHistoryView.hidden=YES;
        _medicalHistoryViewHeight.constant=0;
        [self ChangeIncreaseDecreaseButtonImage:_increaseMedicalViewButton];
    }
}
- (IBAction)saveDiagnosisTextViewValue:(id)sender {
}
//increase the View Height of setting view
- (IBAction)increaseSettingView:(id)sender {
    if ([_increasesettingViewButton.currentImage isEqual:[UIImage imageNamed:@"Button-Collapse"]]) {
        _settingView.hidden=NO;
        _settingViewHeight.constant=111;
        [self ChangeIncreaseDecreaseButtonImage:_increasesettingViewButton];
    }
    else{
        _settingView.hidden=YES;
        _settingViewHeight.constant=0;
        [self ChangeIncreaseDecreaseButtonImage:_increasesettingViewButton];
    }
}
//setting Button
- (IBAction)buttonSetting:(id)sender {
if(setingView==nil)
    setingView=[[SettingView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x-50, 500,311, 222)];
    [setingView alphaViewInitialize];
}
- (IBAction)saveTreatmentEncloser:(id)sender {
}
- (IBAction)closeTreatmentEncloser:(id)sender {
}
//increase the View Height of treatment enclosure view
- (IBAction)increaseTreatmentEncloser:(id)sender {
    if ([_increaseTreatmentViewButton.currentImage isEqual:[UIImage imageNamed:@"Button-Collapse"]]) {
        _treatmentclosureView.hidden=NO;
        _treatmentCloserViewHeight.constant=120;
        [self ChangeIncreaseDecreaseButtonImage:_increaseTreatmentViewButton];
    }
    else{
        _treatmentclosureView.hidden=YES;
        _treatmentCloserViewHeight.constant=0;
        [self ChangeIncreaseDecreaseButtonImage:_increaseTreatmentViewButton];
    }
}
//increase the View Height of symptoms view
- (IBAction)increaseSymptomView:(id)sender {
    if ([_increaseSymptomViewButton.currentImage isEqual:[UIImage imageNamed:@"Button-Collapse"]]) {
        _symptomView.hidden=NO;
        _symptomViewHeight.constant=250;
        [self ChangeIncreaseDecreaseButtonImage:_increaseSymptomViewButton];
    }
    else{
        _symptomView.hidden=YES;
        _symptomViewHeight.constant=0;
        [self ChangeIncreaseDecreaseButtonImage:_increaseSymptomViewButton];
    }
}
//increase the View Height of patient view
- (IBAction)increaseuploadView:(id)sender {
    if ([_increaseUploadViewButton.currentImage isEqual:[UIImage imageNamed:@"Button-Collapse"]]) {
        _uploadView.hidden=NO;
        _uploadViewHeigh.constant=250;
        [self ChangeIncreaseDecreaseButtonImage:_increaseUploadViewButton];
    }
    else{
        _uploadView.hidden=YES;
        _uploadViewHeigh.constant=0;
        [self ChangeIncreaseDecreaseButtonImage:_increaseUploadViewButton];
    }
}
//set button color
-(void)ChangeIncreaseDecreaseButtonImage:(UIButton*)btn{
    if ([btn.currentImage isEqual:[UIImage imageNamed:@"Button-Collapse"]]) {
        [btn setImage:[UIImage imageNamed:@"Button-Expand"] forState:normal];
    }
  else  if ([btn.currentImage isEqual:[UIImage imageNamed:@"Button-Expand"]]) {
      [btn setImage:[UIImage imageNamed:@"Button-Collapse"] forState:normal];
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
//tableview Datasource method
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
//default values
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
    _increasePatientViewHeight.constant=0;
    _increasePatientView.hidden=YES;
    [_increasePatientViewButton setImage:[UIImage imageNamed:@"Button-Collapse"] forState:normal];
    [_increaseDiagnosisViewButton setImage:[UIImage imageNamed:@"Button-Collapse"] forState:normal];
    [_increaseMedicalViewButton setImage:[UIImage imageNamed:@"Button-Collapse"] forState:normal];
    [_increasePatientViewButton setImage:[UIImage imageNamed:@"Button-Collapse"] forState:normal];
    [_increasesettingViewButton setImage:[UIImage imageNamed:@"Button-Collapse"] forState:normal];
    [_increaseSymptomViewButton setImage:[UIImage imageNamed:@"Button-Collapse"] forState:normal];
    [_increaseTreatmentViewButton setImage:[UIImage imageNamed:@"Button-Collapse"] forState:normal];
    [_increaseUploadViewButton setImage:[UIImage imageNamed:@"Button-Collapse"] forState:normal];
    [constant setFontForLabel:_nameLabel];
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
