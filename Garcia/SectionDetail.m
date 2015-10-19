#import "SectionDetail.h"
#import "Constant.h"
#import "AppDelegate.h"
@implementation SectionDetail
{
    UIView *view;
    UIControl  *alphaView;
    Constant *constant;
    NSArray *sectionArray;
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
    AppDelegate *appDel = [UIApplication sharedApplication].delegate;
    [alphaView addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [appDel.window addSubview:alphaView];
    sectionArray=@[@"Eye",@"Ear",@"Neck"];
}
-(void)hide{
    [alphaView removeFromSuperview];
}
-(void)initializeView
{
    constant=[[Constant alloc]init];
    view.layer.cornerRadius = 10;
    view.layer.masksToBounds  = YES;
    [constant setFontForHeaders:_sectionDetailHeadLabel];
}
- (IBAction)previous:(id)sender {
    [alphaView removeFromSuperview];
}
- (IBAction)next:(id)sender {
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return sectionArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SectionDetailCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        [[NSBundle mainBundle]loadNibNamed:@"SectionDetailCell" owner:self options:nil];
        cell=_sectionDetailCell;
        _sectionDetailCell=nil;
    }
    [constant setFontForLabel:cell.sectionDetailLabel];
    cell.sectionDetailLabel.text=sectionArray[indexPath.row];
    return cell;
}
@end
