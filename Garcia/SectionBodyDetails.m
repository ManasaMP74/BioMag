//
//  SectionBodyDetails.m
//  Garcia
//
//  Created by Vmoksha on 27/10/15.
//  Copyright (c) 2015 manasap. All rights reserved.
//

#import "SectionBodyDetails.h"
#import "Constant.h"
#import "AppDelegate.h"
#import "DetailsSection.h"
#import "AddSection.h"

@implementation SectionBodyDetails

    {
        UIView *view;
        UIControl  *alphaView;
        Constant *constant;
        NSArray *sectionArray;
        AddSection *addSectionObj;
         SectionBodyDetails *sectonBodyObject;
        NSInteger selectedIndex;
        NSIndexPath *selectedIndexPath;
    }


-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
//    self.showBodyPartLabel=YES;
    view = [[[NSBundle mainBundle]loadNibNamed:@"SectionBodyDetails" owner:self options:nil]lastObject];
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
    
//    if (self.showBodyPartLabel==NO) {
//        self.bodyPartHeaderlabel.hidden=YES;
//        self.showBodyPartLabel=YES;
//    }
//    else{
//        
//        self.bodyPartHeaderlabel.hidden=NO;
//        self.showBodyPartLabel=NO;
//        
//    }
    
    
   
    view.center = alphaView.center;
    AppDelegate *appDel = [UIApplication sharedApplication].delegate;
    [alphaView addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
   
    [appDel.window addSubview:alphaView];
    sectionArray=@[@"Eye",@"Ear",@"Neck"];
}



- (void)setShowBodyPartLabel:(BOOL)showBodyPartLabel
{
    _showBodyPartLabel = showBodyPartLabel;
    self.bodyPartHeaderlabel.hidden=!showBodyPartLabel;

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
    
    if (sectonBodyObject==nil)
        sectonBodyObject=[[SectionBodyDetails alloc]initWithFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y-50,503, 413)];
     self.sectionHeaderLabel.text=@"header Scan Point";
    [sectonBodyObject alphaViewInitialize];
    
    
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return sectionArray.count;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    DetailsSection *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        
        
        [[NSBundle mainBundle]loadNibNamed:@"DetailsSection" owner:self options:nil];
        cell=_detailsSectionCell;
        _detailsSectionCell=nil;
        
        
    }
    
    [constant setFontForLabel:cell.sectionLabel];
    cell.sectionLabel.text=sectionArray[indexPath.row];
    NSLog(@"the section label is %@",cell.sectionLabel.text);
    
    if ([selectedIndexPath isEqual:indexPath])
    {
        cell.DetailSectionImageView.image=[UIImage imageNamed:@"Box1-Check"];
    }
//    else if (![selectedIndexPath isEqual:indexPath])
//    {
//        cell.DetailSectionImageView.image=[UIImage imageNamed:@"Box1-Uncheck"];
//        
//    }
    
    
    self.bodyPartHeaderlabel.hidden=YES;
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    self.showBodyPartLabel=YES;
    
////    if (self.showBodyPartLabel==YES) {
//        if (sectonBodyObject==nil)
//            sectonBodyObject=[[SectionBodyDetails alloc]initWithFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y-50,503, 413)];
//    
//        sectonBodyObject.sectionHeaderLabel.text = [sectionArray objectAtIndex:indexPath.row];
//        [sectonBodyObject alphaViewInitialize];
//
//        sectonBodyObject.showBodyPartLabel = YES;
//        NSLog(@"the section top label is %@",sectonBodyObject.sectionHeaderLabel.text);
//    }
    
    
    
    
    NSLog(@"%ld cell tapped", (long)indexPath.row);
    
    if ([self.tableview isEqual:tableView])
    {
        selectedIndexPath = indexPath;
        [tableView reloadData];
    }
        
    
    
    
    
    
    
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor=[UIColor lightGrayColor];
}


@end
