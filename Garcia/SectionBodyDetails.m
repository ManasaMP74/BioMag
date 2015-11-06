#import "SectionBodyDetails.h"
#import "Constant.h"
#import "AppDelegate.h"
#import "DetailsSection.h"
#import "AddSection.h"
#import "PartModel.h"
#import "SettingView.h"

@implementation SectionBodyDetails

    {
        UIView *view;
        UIControl  *alphaView;
        Constant *constant;
        NSArray *sectionArray,*sectionDetail;
        AddSection *addSectionObj;
         SectionBodyDetails *sectonBodyObject;
        NSInteger selectedIndex;
        NSIndexPath *selectedIndexPath;
        NSString *str;
        BOOL isClick;
        NSMutableArray *selectedIndexPathArray;
        NSInteger selRow,nextFlag,childSelRow;
        NSMutableArray *theSelIndex,*cellSelected,*theRetainedArray;
        
    }

-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    self->cellSelected = [NSMutableArray array];
    self->theRetainedArray =[NSMutableArray array];
    theSelIndex=[[NSMutableArray alloc] init];
    selRow=0;
    nextFlag=0;
    childSelRow=0;
    view = [[[NSBundle mainBundle]loadNibNamed:@"SectionBodyDetails" owner:self options:nil]lastObject];
    [self initializeView];
    [self addSubview:view];
    view.frame=self.bounds;
    return self;
}

-(void)alphaViewInitialize{
    view.hidden=NO;
    self->cellSelected = [NSMutableArray array];
    self->theRetainedArray =[NSMutableArray array];
    theSelIndex=[[NSMutableArray alloc] init];
    _saveLabel.text=@"Save";
    if (self.tableview) {
        [self.tableview reloadData];
    }

    if (alphaView == nil)
    {
        alphaView = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
        alphaView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];        [alphaView addSubview:view];
    }
    selectedIndexPathArray=[[NSMutableArray alloc]init];
    str=@"Head";
    if ([str isEqual:@"Head"])
    
    {
    view.center = alphaView.center;
    AppDelegate *appDel = [UIApplication sharedApplication].delegate;
    [alphaView addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    self.sectionHeaderLabel.text =_selectedSection.title;
        [_tableview reloadData];
    [appDel.window addSubview:alphaView];
}
    else{
        
        view.center = alphaView.center;
        AppDelegate *appDel = [UIApplication sharedApplication].delegate;
    [alphaView addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        self.sectionHeaderLabel.text =_partModelObj.title;
        [appDel.window addSubview:alphaView];
    }
    _tableViewHeight.constant=_tableview.contentSize.height;
    CGRect frame=view.frame;
    frame.size.height=_tableview.contentSize.height+146;
    view.frame=frame;
}
-(void)initializeView
{
    constant=[[Constant alloc]init];
    view.layer.cornerRadius = 10;
    view.layer.masksToBounds  = YES;
}
-(void) setListingElements:(NSArray *)listingElements
{
    _listingElements = listingElements;
    [self.tableview reloadData];
}
-(void)setTitle:(NSString *)title{
    _title = title;
    self.sectionHeaderLabel.text = title;
    
    
}
- (void)setShowBodyPartLabel:(BOOL)showBodyPartLabel
{
    _showBodyPartLabel = showBodyPartLabel;
    self.bodyPartHeaderlabel.hidden=!showBodyPartLabel;

}
-(void)hide{
    
    self.mNxtbtn.hidden=FALSE;
    nextFlag-=1;
    if (nextFlag<=0) {
        if (nextFlag<=0) {
            if ([str isEqual:@"Correspond"]) {
                [self removeChildTable];
                str=@"Head";
                _sectionHeaderLabel.text=_title;
                _correspondPointLabel.hidden=YES;
                _bodyPartHeight.constant=0;
                [_tableview reloadData];
            }
            else{
                [self CallHideView];
                [alphaView removeFromSuperview];
            }
            return;
        }
        nextFlag=1;
    }
    
    if (theSelIndex.count>0) {
        if (theSelIndex.count>=nextFlag) {
            selRow=nextFlag-1;
            [self createChildTable];
        }
    }
}
- (IBAction)previous:(id)sender {
    
   self.mNxtbtn.hidden=FALSE;
   nextFlag-=1;
    if (nextFlag<=0) {
        if (nextFlag<=0) {
            if ([str isEqual:@"Correspond"]) {
                [self removeChildTable];
                str=@"Head";
                _sectionHeaderLabel.text=_title;
                _correspondPointLabel.hidden=YES;
                _bodyPartHeight.constant=0;
                [_tableview reloadData];
            }
            else{
                [self CallHideView];
                [alphaView removeFromSuperview];
            }
            return;
        }
        nextFlag=1;
    }
    
    if (theSelIndex.count>0) {
        if (theSelIndex.count>=nextFlag) {
            selRow=nextFlag-1;
            [self createChildTable];
        }
    }
}
-(void)removeChildTable
{
    if (self.ChildTableView) {
        [self.ChildTableView removeFromSuperview];
        self.ChildTableView=nil;
    }
    
   
}
- (BOOL)validateConditions
{
    if (theSelIndex.count == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please Select atleast one field" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        
        return NO;
    }
    return YES;
}
- (IBAction)next:(id)sender {
    
    self.mPrevBtn.hidden=FALSE;
    if (theSelIndex.count>nextFlag) {
        nextFlag+=1;
    }
    if(theSelIndex.count==nextFlag){
        self.mNxtbtn.hidden=TRUE;
        _saveLabel.text=@"Done";
        
    }
    if ([str isEqual:@"Head"]) {
        if ([self validateConditions])
        {
            nextFlag=1;
            self.mNxtbtn.hidden=FALSE;
            if(theSelIndex.count==nextFlag){
                self.mNxtbtn.hidden=TRUE;
                _saveLabel.text=@"Done";
            }

            [self setTitle:_sectionHeaderLabel.text];
            _sectionHeaderLabel.text=_title;
            self.sectionHeaderLabel.text =_partModelObj.title;
            _bodyPartHeight.constant=17;
            str=@"Correspond";
            [_tableview reloadData];
        }
        else
        {
            self.mNxtbtn.hidden=FALSE;
        }
        
    }
    
    if (theSelIndex.count>0) {
        if (theSelIndex.count>=nextFlag) {
            selRow=nextFlag-1;
            [self createChildTable];
        }
        
    }
}

-(void)createChildTable
{
    if (self.ChildTableView) {
        [self.ChildTableView removeFromSuperview];
        self.ChildTableView=nil;
    }
    self.ChildTableView=[[UITableView alloc]initWithFrame:self.tableview.bounds];
    self.ChildTableView.dataSource=self;
    self.ChildTableView.delegate=self;
    [self.tableview addSubview:self.ChildTableView];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:self.tableview]) {
         return self.selectedSection.allParts.count;
    }
    
    PartModel *part=nil;
    if (selRow>theSelIndex.count) {
        part = self.selectedSection.allParts[selRow];
    }
    else
    {
        part = theSelIndex[selRow];
    }
    
    
return part.allScanPoints.count;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    DetailsSection *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        [[NSBundle mainBundle]loadNibNamed:@"DetailsSection" owner:self options:nil];
        cell = self.detailsSectionCell;
    }
    if ([tableView isEqual:self.tableview]) {
        
        if ([self->cellSelected containsObject:indexPath]){
            cell.DetailSectionImageView.image=[UIImage imageNamed:@"Box1-Check"];
        }
        else{
            cell.DetailSectionImageView.image=[UIImage imageNamed:@"Box1-Uncheck"];
        }
        
       PartModel *part = self.selectedSection.allParts[indexPath.row];
        cell.sectionLabel.text = part.title;
        tableView.separatorStyle=0;
        return cell;
     }
   
    else{
        
        PartModel *part=nil;
        if (selRow>theSelIndex.count) {
             part = self.selectedSection.allParts[selRow];
        }
        else
        {
             part = theSelIndex[selRow];
        }
       
        
        cell.sectionLabel.text = [part.allScanPoints objectAtIndex:indexPath.row];
        
        self.sectionHeaderLabel.text =part.title;
        
        if ([self->theRetainedArray containsObject:[part.allScanPoints objectAtIndex:indexPath.row]]){
            cell.DetailSectionImageView.image=[UIImage imageNamed:@"Box1-Check"];
        }
        else{
            cell.DetailSectionImageView.image=[UIImage imageNamed:@"Box1-Uncheck"];
        }
        
    }
    self.bodyPartHeaderlabel.hidden=YES;
    tableView.separatorStyle=0;
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    
    if ([self.tableview isEqual:tableView])
    {
        
            selRow=indexPath.row;
            
            PartModel *part = self.selectedSection.allParts[selRow];
            selectedIndexPath = indexPath;
            if ([self->cellSelected containsObject:indexPath]){
                [self->cellSelected removeObject:indexPath];
                if ([theSelIndex containsObject:part]) {
                
                [theSelIndex removeObject:part];
                }
            }
            else{
                [self->cellSelected addObject:indexPath];
                if (![theSelIndex containsObject:part]) {
                   [theSelIndex addObject:part];
                   
                }
            }
            NSLog(@"the Sel array is %@",theSelIndex);
        }
        
    else
        {
            childSelRow=indexPath.row;
            PartModel *part=nil;
            if (selRow>theSelIndex.count) {
                part = self.selectedSection.allParts[selRow];
            }
            else
            {
                part = theSelIndex[selRow];
            }
            
            if ([theRetainedArray containsObject:[part.allScanPoints objectAtIndex:childSelRow]]) {
                [theRetainedArray removeObject:[part.allScanPoints objectAtIndex:childSelRow]];
            }
            else
            {
                [theRetainedArray addObject:[part.allScanPoints objectAtIndex:childSelRow]];
            }
             NSLog(@"the childSel array is %@",theRetainedArray);
            
        }
            [tableView reloadData];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor=[UIColor whiteColor];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 33;
}
- (IBAction)saveAndDone:(id)sender {
    if ([_saveLabel.text isEqualToString:@"Done"]) {
        [alphaView removeFromSuperview];
        [self.delegate hideAllView];
    }
}
-(void)CallHideView{
    [self.delegate HideofSectionDetail:NO];
}
@end
