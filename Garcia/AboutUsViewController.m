#import "AboutUsViewController.h"
#import "Postman.h"
#import "PostmanConstant.h"
#import "MBProgressHUD.h"
#import <MCLocalization/MCLocalization.h>
@interface AboutUsViewController ()
@property (weak, nonatomic) IBOutlet UITextView *aboutTextView;
@property (weak, nonatomic) IBOutlet UIView *aboutView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textviewHeight;

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _aboutTextView.text=@"";
     _aboutTextView.textContainerInset = UIEdgeInsetsMake(0,0,0, 0);
    _aboutView.layer.cornerRadius=5;
    _aboutTextView.layer.cornerRadius=5;
    self.title=[MCLocalization stringForKey:@"About App"];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background-Image-1.jpg"]]];
    UIImage* image = [UIImage imageNamed:@"Back button.png"];
    CGRect frameimg1 = CGRectMake(100, 0, image.size.width+30, image.size.height);
    UIButton *button=[[UIButton alloc]initWithFrame:frameimg1];
    [button setImage:image forState:UIControlStateNormal];
    UIBarButtonItem *barItem=[[UIBarButtonItem alloc]initWithCustomView:button];
    UIBarButtonItem *negativeSpace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpace.width=-25;
    self.navigationItem.leftBarButtonItems=@[barItem];
    [button addTarget:self action:@selector(popView) forControlEvents:UIControlEventTouchUpInside];
    [self callApi];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)popView{

    [self.navigationController popViewControllerAnimated:YES];
}
-(void)callApi{
    Postman *postman=[[Postman alloc]init];
    NSString *url=[NSString stringWithFormat:@"%@%@",baseUrl,aboutUs];
    NSString *parameter=[NSString stringWithFormat:@"{\"request\":\{\"EntityCode\":\"%@\",\"Name\":\"\"}}",aboutUsCode];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [postman post:url withParameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self process:responseObject];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];

}
-(void)process:(id)responseObject{
    NSDictionary *dict;
    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
        NSDictionary *dict1=responseObject;
        dict=dict1[@"aaData"];
    }
    NSArray *configurationArray=dict[@"Configurations"];
    for (NSDictionary *dict1 in configurationArray) {
            CGFloat i=self.view.frame.size.width-30;
            NSString *str=dict1[@"ValueFrom"];
            CGFloat labelHeight=[str boundingRectWithSize:(CGSize){i,CGFLOAT_MAX }
                                                                                          options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont fontWithName:@"OpenSans-Semibold" size:14]} context:nil].size.height;
            _viewHeight.constant=labelHeight+10;
            _textviewHeight.constant=labelHeight;
           
            _aboutTextView.text=str;
        }
}
@end
