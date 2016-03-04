#import "EditDrProfileViewController.h"
#import "PlaceholderTextView.h"
#import "Constant.h"
#import <MCLocalization/MCLocalization.h>
@interface EditDrProfileViewController ()
@property (strong, nonatomic) IBOutlet UITextField *nameTF;
@property (strong, nonatomic) IBOutlet UITextField *genderTF;
@property (strong, nonatomic) IBOutlet UITextField *yearOfExpTF;
@property (strong, nonatomic) IBOutlet UITextField *dateOfBirthTF;
@property (strong, nonatomic) IBOutlet UITextField *mobileNoTF;
@property (strong, nonatomic) IBOutlet UITextField *emailTF;
@property (strong, nonatomic) IBOutlet UITableView *gendertableview;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIImageView *drImageView;
@property (strong, nonatomic) IBOutlet PlaceholderTextView *certificateTextView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *genderTvHeight;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearOfExpLabel;
@property (weak, nonatomic) IBOutlet UILabel *dobLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobNumbLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *certificateLabel;
@end

@implementation EditDrProfileViewController
{
    Constant *constant;
    NSDateFormatter *formatter;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    formatter=[[NSDateFormatter alloc]init];
    constant=[[Constant alloc]init];
    [self textFieldLayer];
    [self setFont];
    [self textFieldLayer];
    [self setDefault];
    [self navigationItemMethod];
    [self localize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
//set layesr for TextField and placeHolder
-(void)textFieldLayer{
    //       _patientImageView.layer.cornerRadius=_patientImageView.frame.size.width/2;
    //    _patientImageView.clipsToBounds=YES;
    
    [constant spaceAtTheBeginigOfTextField:_genderTF];
    [constant spaceAtTheBeginigOfTextField:_emailTF];
    [constant spaceAtTheBeginigOfTextField:_nameTF];
    [constant spaceAtTheBeginigOfTextField:_yearOfExpTF];
    [constant spaceAtTheBeginigOfTextField:_dateOfBirthTF];
    [constant spaceAtTheBeginigOfTextField:_mobileNoTF];
    [constant SetBorderForTextField:_genderTF];
    [constant SetBorderForTextField:_mobileNoTF];
    [constant SetBorderForTextField:_yearOfExpTF];
    [constant SetBorderForTextField:_emailTF];
    [constant SetBorderForTextview:_certificateTextView];
    [constant SetBorderForTextField:_nameTF];
    [constant SetBorderForTextField:_dateOfBirthTF];
    [constant setFontFortextField:_nameTF];
    [constant setFontFortextField:_genderTF];
    [constant setFontFortextField:_emailTF];
    [constant setFontFortextField:_yearOfExpTF];
    [constant setFontFortextField:_dateOfBirthTF];
    [constant setFontFortextField:_mobileNoTF];
    _certificateTextView.textContainerInset = UIEdgeInsetsMake(10, 5, 10, 10);
}
//setfont for label
-(void)setFont{
    [constant setFontForLabel:_genderLabel];
    [constant setFontForLabel:_nameLabel];
    [constant setFontForLabel:_yearOfExpLabel];
    [constant setFontForLabel:_dobLabel];
    [constant setFontForLabel:_certificateLabel];
    [constant setFontForLabel:_emailLabel];
    [constant setFontForLabel:_mobNumbLabel];
}
-(void)navigationItemMethod{
    self.navigationItem.hidesBackButton=YES;
    UIImage* image = [UIImage imageNamed:@"Back button.png"];
    CGRect frameimg1 = CGRectMake(100, 0, image.size.width+30, image.size.height);
    UIButton *button=[[UIButton alloc]initWithFrame:frameimg1];
    [button setImage:image forState:UIControlStateNormal];
    UIBarButtonItem *barItem=[[UIBarButtonItem alloc]initWithCustomView:button];
    UIBarButtonItem *negativeSpace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpace.width=-25;
    self.navigationItem.leftBarButtonItems=@[negativeSpace,barItem];
    [button addTarget:self action:@selector(popView) forControlEvents:UIControlEventTouchUpInside];
}
-(void)popView{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setDefault{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSArray *doctorDetail=[defaults valueForKey:@"DoctorDetail"];
    _nameTF.text=doctorDetail[0];
    NSArray *ar=[doctorDetail[1] componentsSeparatedByString:@"T"];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date=[formatter dateFromString:ar[0]];
    [formatter setDateFormat:@"dd-MMM-yyyy"];
    NSString *str=[formatter stringFromDate:date];
    _dateOfBirthTF.text=str;
    _emailTF.text=doctorDetail[2];
    _yearOfExpTF.text=doctorDetail[4];
    _certificateTextView.text=doctorDetail[5];
    _mobileNoTF.text=doctorDetail[3];
    _genderTF.text=doctorDetail[6];

}

-(void)localize{
    _nameTF.attributedPlaceholder=[constant textFieldPlaceHolderText:[MCLocalization stringForKey:@"Name"]];
    _emailTF.attributedPlaceholder=[constant textFieldPlaceHolderText:[MCLocalization stringForKey:@"EmailLabel"]];
    _genderTF.attributedPlaceholder=[constant textFieldPlaceHolderText:[MCLocalization stringForKey:@"GenderLabel"]];
    _mobileNoTF.attributedPlaceholder=[constant textFieldPlaceHolderText:[MCLocalization stringForKey:@"MobileLabel"]];
    _yearOfExpTF.attributedPlaceholder=[constant textFieldPlaceHolderText:@"Year Of Experience"];
    _dateOfBirthTF.attributedPlaceholder=[constant textFieldPlaceHolderText:[MCLocalization stringForKey:@"DateOfBirthLabel"]];
    _certificateTextView.placeholder=@"Certificates";
    self.title=[MCLocalization stringForKey:@"Edit"];
    [_cancelBtn setTitle:[MCLocalization stringForKey:@"Cancel"] forState:normal];
    [_saveBtn setTitle:[MCLocalization stringForKey:@"Save"] forState:normal];
    [self.nameLabel setAttributedText:[constant setColoredLabelandStar:[MCLocalization stringForKey:@"Name"]]];
    [self.genderLabel setAttributedText:[constant setColoredLabelandStar:[MCLocalization stringForKey:@"GenderLabel"]]];
    [self.yearOfExpLabel setAttributedText:[constant setColoredLabelandStar:@"Year Of Experience"]];
    [self.dobLabel setAttributedText:[constant setColoredLabelandStar:[MCLocalization stringForKey:@"DateOfBirthLabel"]]];
    [self.mobNumbLabel setAttributedText:[constant setColoredLabelandStar:[MCLocalization stringForKey:@"MobileLabel"]]];
    [self.emailLabel setAttributedText:[constant setColoredLabelandStar:[MCLocalization stringForKey:@"EmailLabel"]]];
   [self.certificateLabel setAttributedText:[constant setColoredLabelandStar:@"Certificates"]];
}
- (IBAction)gender:(id)sender {

}
- (IBAction)dateOfBirth:(id)sender {
}

@end
