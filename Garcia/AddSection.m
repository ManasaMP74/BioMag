#import "AddSection.h"
#import "Constant.h"
#import "AppDelegate.h"
#import "HexColors.h"
#import "SectionBodyDetails.h"
#import "SectionModel.h"


@implementation AddSection
{
    UIView *view;
    UIControl  *alphaView;
    Constant *constant;

    SectionBodyDetails *sectonBodyObject;
    NSInteger selectedIndex;
    NSIndexPath *selectedIndexPath;

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
         alphaView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
        [alphaView addSubview:view];
    }
    view.hidden=NO;
    sectonBodyObject.bodyPartHeaderlabel.hidden=YES;
    view.center = alphaView.center;
    AppDelegate *appDel = [UIApplication sharedApplication].delegate;
    [alphaView addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [appDel.window addSubview:alphaView];
    _tableViewHeight.constant=_tableview.contentSize.height;
    CGRect frame=view.frame;
    frame.size.height=_tableview.contentSize.height+151;
    view.frame=frame;
}
-(void)initializeView
{
    constant=[[Constant alloc]init];
    view.layer.cornerRadius =3;
    view.layer.masksToBounds  = YES;
}
-(void)hide{
     [self.delegate HideSection:NO];
    [alphaView removeFromSuperview];
}
- (IBAction)previous:(id)sender {
    [self.delegate HideSection:NO];
    [alphaView removeFromSuperview];
}
- (IBAction)next:(id)sender {

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _allSections.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddSectionCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell==nil) {
        [[NSBundle mainBundle]loadNibNamed:@"AddSectionCell" owner:self options:nil];
        SectionModel *section = self.allSections[indexPath.row];
        cell = self.addsectionCell;
       cell.sectionLabel.text = section.title;
        
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor=[UIColor colorWithRed:0.933 green:0.933 blue:0.941 alpha:1];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    sectonBodyObject.bodyPartHeaderlabel.hidden=YES;
    if (sectonBodyObject==nil)
        sectonBodyObject=[[SectionBodyDetails alloc]initWithFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y,503, 413)];
    view.hidden=YES;
    sectonBodyObject.selectedSection = _allSections[indexPath.row];
   [sectonBodyObject alphaViewInitialize];
    sectonBodyObject.showBodyPartLabel = NO;
    sectonBodyObject.delegate=self;
}
-(void)HideofSectionDetail:(BOOL)status{
    view.hidden=NO;
}
-(void)hideAllView{
    [alphaView removeFromSuperview];
    [self.delegate hideAllView];
}
@end;
