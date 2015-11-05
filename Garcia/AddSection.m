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


//- (id)initWithCoder:(NSCoder *)aDecoder
//{
//    if ((self = [super initWithCoder:aDecoder])){
//        view = [[[NSBundle mainBundle] loadNibNamed:@"AddSection"
//                                                         owner:self
//                                                       options:nil] objectAtIndex:0];
//        [self addSubview: view];
//        view.translatesAutoresizingMaskIntoConstraints = NO;
//        NSDictionary *views = NSDictionaryOfVariableBindings(view);
//        
//        NSArray *constrains = [NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[subView]-(0)-|"
//                                                                      options:kNilOptions
//                                                                      metrics:nil
//                                                                        views:views];
//        [self addConstraints:constrains];
//        
//        constrains = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[subView]-(0)-|"
//                                                             options:kNilOptions
//                                                             metrics:nil
//                                                               views:views];
//        [self addConstraints:constrains];
//        sectionArray=[[NSMutableArray alloc]init];
//        sectionArray=[@[@"Head",@"Arm",@"Leg"]mutableCopy];
//       selectedIndexPath=nil;
//       [self.tableview reloadData];
//    }
//    return self;
//}
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
   
}
-(void)hide{
    [alphaView removeFromSuperview];
}
-(void)initializeView
{
    constant=[[Constant alloc]init];
    view.layer.cornerRadius = 10;
    view.layer.masksToBounds  = YES;
//     sectionArray=[[NSMutableArray alloc]init];
//    sectionArray=[@[@"Head",@"Arm",@"Leg"]mutableCopy];
   
   
    [constant setFontForHeaders:_sectionHeaderLabel];
}
- (IBAction)previous:(id)sender {
    
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
    
//     sectonBodyObject.bodyPartHeaderlabel.hidden=YES;
//    [constant setFontForLabel:cell.sectionLabel];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    sectonBodyObject.bodyPartHeaderlabel.hidden=YES;
    
    if (sectonBodyObject==nil)
        sectonBodyObject=[[SectionBodyDetails alloc]initWithFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y-50,503, 413)];

    sectonBodyObject.selectedSection = _allSections[indexPath.row];
//    sectonBodyObject.partModelObj=_allSections[indexPath.row];
//    sectonBodyObject.selectedSection=
//    sectonBodyObject.showBodyPartLabel = NO;

   [sectonBodyObject alphaViewInitialize];
    sectonBodyObject.showBodyPartLabel = NO;
    
    
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor=[UIColor colorWithHexString:@"#eeeeee"];
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if ([selectedIndexPath isEqual:indexPath]) {
//        //  CollectionViewTableViewCell *cell = (CollectionViewTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
//        //        cell.scanPointView.hidden=NO;
//        //        cell.scanPointViewHeight.constant=cell.scanPointView.scanPointTableView.contentSize.height;
//        //        return cell.scanPointView.scanPointTableView.contentSize.height+37;
//        return 100;
//    }
//    else {
//        //        CollectionViewTableViewCell *cell = (CollectionViewTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
//        //        cell.scanPointView.hidden=YES;
//        //        cell.scanPointViewHeight.constant=0;
//        return 24;
//    }
//}
@end;
