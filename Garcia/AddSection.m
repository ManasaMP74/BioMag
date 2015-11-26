#import "AddSection.h"
#import "Constant.h"
#import "AppDelegate.h"
#import "HexColors.h"
#import "SectionBodyDetails.h"
#import "SectionModel.h"
#import "ScanPointModel.h"

@implementation AddSection
{
    UIView *view;
    UIControl  *alphaView;
    Constant *constantobj;
    SectionBodyDetails *sectonBodyObject;
    NSInteger selectedIndex;
    NSIndexPath *selectedIndexPath;
    
}
-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
     sectonBodyObject.bodyPartHeaderlabel.hidden=YES;
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
    view.hidden=NO;
    sectonBodyObject.bodyPartHeaderlabel.hidden=YES;
    view.center = alphaView.center;
    AppDelegate *appDel = [UIApplication sharedApplication].delegate;
    [alphaView addTarget:self action:@selector(previous:) forControlEvents:UIControlEventTouchUpInside];
    [appDel.window addSubview:alphaView];
    if (_tableview.contentSize.height<146) {
            _tableViewHeight.constant=_tableview.contentSize.height;
    }
    else _tableViewHeight.constant=146;
    CGRect frame=view.frame;
    frame.size.height=_tableViewHeight.constant+146;
    view.frame=frame;

}
-(void)initializeView
{
    constantobj=[[Constant alloc]init];
    view.layer.cornerRadius = 10;
    view.layer.masksToBounds  = YES;
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
    [constantobj setFontForLabel:cell.sectionLabel];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    sectonBodyObject.bodyPartHeaderlabel.hidden=YES;
    if (sectonBodyObject==nil)
        sectonBodyObject=[[SectionBodyDetails alloc]initWithFrame:CGRectMake(134,439,view.frame.size.width, 416)];
    ScanPointModel *model=_allSections[indexPath.row];
   // sectonBodyObject.selectedSection =model;
       [sectonBodyObject alphaViewInitialize];
       sectonBodyObject.delegate=self;
    view.hidden=YES;
    sectonBodyObject.showBodyPartLabel = NO;
    
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor=[UIColor colorWithHexString:@"#eeeeee"];
}
-(void)HideofSectionDetail:(BOOL)status{
    view.hidden=NO;
}
-(void)hideAllView{
    [alphaView removeFromSuperview];
    [self.delegate hideAllView];
}
@end;
