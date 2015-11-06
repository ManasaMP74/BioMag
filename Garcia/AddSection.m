#import "AddSection.h"
#import "Constant.h"
#import "AppDelegate.h"
#import "HexColors.h"
#import "SectionBodyDetails.h"


@implementation AddSection
{
    UIView *view;
    UIControl  *alphaView;
    Constant *constant;
    NSArray *sectionArray;
    SectionBodyDetails *sectonBodyObject;
}
-(id)initWithFrame:(CGRect)frame
{
     sectonBodyObject.bodyPartHeaderlabel.hidden=YES;
    self=[super initWithFrame:frame];
    view=[[[NSBundle mainBundle]loadNibNamed:@"AddSection" owner:self options:nil]lastObject];
    [self initializeView];
    [self addSubview:view];
    view.frame=self.bounds;
    return self;
}
-(void)alphaViewInitialize{
    if (alphaView == nil)
    {
        alphaView = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
        alphaView.backgroundColor = [UIColor clearColor];
        [alphaView addSubview:view];
    }
    sectonBodyObject.bodyPartHeaderlabel.hidden=YES;
    view.center = alphaView.center;
    AppDelegate *appDel = [UIApplication sharedApplication].delegate;
    [alphaView addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [appDel.window addSubview:alphaView];
    sectionArray=@[@"Head",@"Arm",@"Leg"];
}
-(void)hide{
    [alphaView removeFromSuperview];
}
-(void)initializeView
{
    constant=[[Constant alloc]init];
    view.layer.cornerRadius = 10;
    view.layer.masksToBounds  = YES;
    [constant setFontForHeaders:_sectionHeaderLabel];
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
    AddSectionCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell==nil) {
        [[NSBundle mainBundle]loadNibNamed:@"AddSectionCell" owner:self options:nil];
        cell=_addsectionCell;
        _addsectionCell=nil;
    }
     sectonBodyObject.bodyPartHeaderlabel.hidden=YES;
    [constant setFontForLabel:cell.sectionLabel];
    cell.sectionLabel.text=sectionArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    sectonBodyObject.bodyPartHeaderlabel.hidden=YES;
    
    if (sectonBodyObject==nil)
        sectonBodyObject=[[SectionBodyDetails alloc]initWithFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y-50,503, 413)];
   [sectonBodyObject alphaViewInitialize];
    sectonBodyObject.showBodyPartLabel = NO;
    
    
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor=[UIColor lightGrayColor];
}
@end
