#import "SettingView.h"
#import "Constant.h"
#import "AppDelegate.h"
#import "AddSection.h"
#import "HexColors.h"
@implementation SettingView
{
    UIView *view;
    UIControl  *alphaView;
    Constant *constant;
    AddSection *addsection;
}
-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    view=[[[NSBundle mainBundle]loadNibNamed:@"SettingView" owner:self options:nil]lastObject];
    [self initializeView];
    [self addSubview:view];
    view.frame=self.bounds;
    return self;
}
-(void)alphaViewInitialize{
    if (alphaView == nil)
    {
        alphaView = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
        alphaView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
        [alphaView addSubview:view];
    }
    view.center = alphaView.center;
    self.settingHeaderLabel.textColor=[UIColor colorWithHexString:@"#FFFFFF"];
    self.visitLabel.textColor=[UIColor colorWithHexString:@"#063B4F"];
    self.intervalLabel.textColor=[UIColor colorWithHexString:@"#063B4F"];
     self.notesLabel.textColor=[UIColor colorWithHexString:@"#063B4F"];
     self.completedLabel.textColor=[UIColor colorWithHexString:@"#063B4F"];
     self.sectionLabel.textColor=[UIColor colorWithHexString:@"#063B4F"];
     self.saveLabel.textColor=[UIColor colorWithHexString:@"#FFFFFF"];
    self.AddButton.backgroundColor=[UIColor colorWithHexString:@"#9295CA"];
    self.SaveBtnClicked.backgroundColor=[UIColor colorWithHexString:@"#9295CA"];
    [self.AddButton setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    
    AppDelegate *appDel = [UIApplication sharedApplication].delegate;
    [alphaView addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [appDel.window addSubview:alphaView];
}
-(void)hide{
    [alphaView removeFromSuperview];
}
-(void)initializeView
{
    constant=[[Constant alloc]init];
    view.layer.cornerRadius = 10;
    view.layer.masksToBounds  = YES;
    [constant spaceAtTheBeginigOfTextField:_visitTF];
    [constant spaceAtTheBeginigOfTextField:_intervalTF];
    [constant setFontForbutton:_AddButton];
    [constant setFontFortextField:_visitTF];
    [constant setFontFortextField:_intervalTF];
    [constant setFontForHeaders:_settingHeaderLabel];
    [constant setFontForLabel:_sectionLabel];
    [constant setFontForLabel:_visitLabel];
    [constant setFontForLabel:_intervalLabel];
    [constant setFontForLabel:_completedLabel];
}
- (IBAction)add:(id)sender {
    if (addsection==nil)
        addsection=[[AddSection alloc]initWithFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y-50,503, 413)];
    [addsection alphaViewInitialize];
}
- (IBAction)completed:(id)sender {
}
@end
