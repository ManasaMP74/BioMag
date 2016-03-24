#import "DrProfileViewController.h"
#import "Constant.h"
#import <MCLocalization/MCLocalization.h>
#import "EditDrProfileViewController.h"
#import "DrProfilModel.h"
#import "UIImageView+AFNetworking.h"
#import "UIImageView+clearCachImage.h"
#import "PostmanConstant.h"
@interface DrProfileViewController ()<editSuccess>
@property (weak, nonatomic) IBOutlet UIView *profileView;

@end

@implementation DrProfileViewController
{
    Constant *constant;
    NSDateFormatter *formatter;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self navigationItemMethod];
      [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background-Image-1.jpg"]]];
   constant=[[Constant alloc]init];
    formatter=[[NSDateFormatter alloc]init];
    [self setFont];
    [self localize];
    [self setDefault];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}
-(void)navigationItemMethod{
    _profileView.layer.cornerRadius=5;
    self.title=@"Practitioner Profile";
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
-(void)setFont{
    [constant setColorForLabel:_dobLabel];
    [constant setColorForLabel:_emailLabel];
    [constant setColorForLabel:_mobileLabel];
    [constant setColorForLabel:_certificateLabel];
    [constant setColorForLabel:_yearOfExperienceLabel];
    [constant setFontForLabel:_emailValueLabel];
    [constant setFontForLabel:_mobileValueLabel];
    [constant setFontForLabel:_yearOfExpValueLabel];
    [constant setFontForLabel:_certificateValueLabel];
    [constant setFontForLabel:_dobValueLabel];
}
-(void)setDefault{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSData *doctorDetail=[defaults valueForKey:@"DoctorDetail"];
    DrProfilModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:doctorDetail];
    _nameValueLabel.text=model.name;
    NSArray *ar=[model.DOB componentsSeparatedByString:@"T"];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date=[formatter dateFromString:ar[0]];
    [formatter setDateFormat:@"dd-MMM-yyyy"];
    NSString *str=[formatter stringFromDate:date];
    _dobValueLabel.text=str;
    _emailValueLabel.text=model.email;
    _yearOfExpValueLabel.text=model.experience;
    _certificateValueLabel.text=model.certificate;
    _mobileValueLabel.text=model.ContactNo;
    if (model.storageId.length==0) {
        _doctorImage.image=[UIImage imageNamed:@"Doctor-Image"];
    }else{
        
        NSString *strimageUrl;
        if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
            strimageUrl = [NSString stringWithFormat:@"%@%@%@/%@",baseUrlAws,dbName,model.storageId,model.fileName];
            
        }else
        {
            strimageUrl = [NSString stringWithFormat:@"%@%@%@",baseUrl,getProfile,model.storageId];
            
        }
        [_doctorImage setImageWithURL:[NSURL URLWithString:strimageUrl] placeholderImage:[UIImage imageNamed:@"Doctor-Image"]];
    }
}
-(void)localize{
    _dobLabel.text=[MCLocalization stringForKey:@"DateOfBirthLabel"];
    _mobileLabel.text=[MCLocalization stringForKey:@"MobileLabel"];
    _emailLabel.text=[MCLocalization stringForKey:@"EmailLabel"];
    _certificateLabel.text=@"Certificate";
    _yearOfExpValueLabel.text=@"Year Of Experience";
}
-(void)editedSuccessfully{
    [self setDefault];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    EditDrProfileViewController *edit=segue.destinationViewController;
    edit.delegate=self;
}
@end
