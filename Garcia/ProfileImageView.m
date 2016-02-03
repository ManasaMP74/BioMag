#import "ProfileImageView.h"
#import "AppDelegate.h"
#import "PostmanConstant.h"
@implementation ProfileImageView
{
    UIView *view;
    UIControl  *alphaView;
    PostmanConstant *constant;
}
-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    view=[[[NSBundle mainBundle]loadNibNamed:@"ProfileImageView" owner:self options:nil]lastObject];
    [self initializeView];
    view.frame=self.bounds;
    [self addSubview:view];
    constant=[[PostmanConstant alloc]init];
    return self;
}
-(void)initializeView
{
    view.layer.cornerRadius = 10;
    view.layer.masksToBounds  = YES;
}
-(void)alphaViewInitialize{
    if (alphaView == nil)
    {
        alphaView = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
        alphaView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
        [alphaView addSubview:view];
    }
     view.center = alphaView.center;
    NSString *str=[NSString stringWithFormat:@"%@%@%@",baseUrl,expandProfileImage,_imageCode];
    [_profileImageView setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"patient.jpg"] ];
    AppDelegate *appDel = [UIApplication sharedApplication].delegate;
    [appDel.window addSubview:alphaView];
    [alphaView addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
}
-(void)hide{
    [alphaView removeFromSuperview];
}
@end
