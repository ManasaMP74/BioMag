#import "HeaderTableVIew.h"
#import "HeaderModelClass.h"
#import <MCLocalization/MCLocalization.h>
@implementation HeaderTableVIew
{
    UIView *view;
    NSMutableArray *selectedSectionNameArray,*allBiamagneticArray,*completeDetailOfSectionArray,*selectedScanpointNameArray,*correspondingPairArray,*completeCorrespondingArray;
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super initWithCoder:aDecoder]) {
        view=[[[NSBundle mainBundle]loadNibNamed:@"HeaderTableVIew" owner:self options:nil]objectAtIndex:0];
        [self addSubview:view];
        view.translatesAutoresizingMaskIntoConstraints=NO;
        NSDictionary *subview=NSDictionaryOfVariableBindings(view);
        NSArray *constraints=[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[view]-(0)-|" options:kNilOptions metrics:nil views:subview];
        [self addConstraints:constraints];
        constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[view]-(0)-|"
                                                              options:kNilOptions
                                                              metrics:nil
                                                                views:subview];
        [self addConstraints:constraints];
        selectedSectionNameArray= [[NSMutableArray alloc]init];
        completeDetailOfSectionArray=[[NSMutableArray alloc]init];
        allBiamagneticArray= [[NSMutableArray alloc]init];
        selectedScanpointNameArray= [[NSMutableArray alloc]init];
        correspondingPairArray =[[NSMutableArray alloc]init];
        completeCorrespondingArray=[[NSMutableArray alloc]init];
    }
    return self;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int row=1;
    if (_model.selectedHeaderIndexpath.count>0) {
        if (section<selectedSectionNameArray.count-2) {
            for (NSString *str in _model.selectedHeaderIndexpath) {
                NSArray *ar=[str componentsSeparatedByString:@"-"];
                if (section==[ar[1] integerValue]) {
                    int i=[self getNumberOfScanpointRow:section];
                    row=i+1;
                }
            }
        }
    }
    return row;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return selectedSectionNameArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        HeaderTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell==nil) {
            _headerCell=[[[NSBundle mainBundle]loadNibNamed:@"HeaderTableViewCell" owner:self options:nil]lastObject];
            cell=_headerCell;
            _headerCell=nil;
        }
        cell.delegate=self;
        if (indexPath.section<selectedSectionNameArray.count-2) {
            cell.headerLabel.text=[self nameForCell:indexPath];
        }else  cell.headerLabel.text=selectedSectionNameArray[indexPath.section];
        
        if (indexPath.section==selectedSectionNameArray.count-1) {
            cell.headerImageView.hidden=NO;
            cell.priceLabel.hidden=YES;
            cell.headerImageViewWidth.constant=35;
            cell.HeaderImageViewHeight.constant=15;
            cell.headerButton.userInteractionEnabled=NO;
            if ([_model.completed intValue]==0) {
                cell.headerImageView.image=[UIImage imageNamed:@"Button-off"];
            }else  cell.headerImageView.image=[UIImage imageNamed:@"Button-on"];
        }else if (indexPath.section==selectedSectionNameArray.count-2) {
            cell.headerImageView.hidden=YES;
            cell.priceLabel.hidden=NO;
            cell.headerButton.userInteractionEnabled=NO;
            cell.priceLabel.text=_model.price;
            
        }else{
            cell.headerButton.userInteractionEnabled=YES;
            cell.headerImageView.hidden=NO;
            cell.priceLabel.hidden=YES;
            cell.HeaderImageViewHeight.constant=18;
            cell.headerImageViewWidth.constant=18;
            if (_model.selectedHeaderIndexpath.count>0) {
                for (NSString *i in _model.selectedHeaderIndexpath) {
                    if ([i isEqual:[NSString stringWithFormat:@"%ld-%ld",(long)indexPath.row,(long)indexPath.section]]) {
                        cell.headerImageView.image=[UIImage imageNamed:@"Button-Collapse"];
                    }else  cell.headerImageView.image=[UIImage imageNamed:@"Button-Expand"];
                    break;
                }
            }else  cell.headerImageView.image=[UIImage imageNamed:@"Button-Expand"];
        }
        return cell;
    }else{
        ScanPointTableViewCell *cell1=[tableView dequeueReusableCellWithIdentifier:@"cell1"];
        if (cell1==nil) {
            _scapointCell=[[[NSBundle mainBundle]loadNibNamed:@"ScanPointTableViewCell" owner:self options:nil]objectAtIndex:0];
            cell1=_scapointCell;
            _scapointCell=nil;
        }
        cell1.delegate=self;
        cell1.scanpointLabel.text=[self nameForCell:indexPath];
        cell1.correspondingPairTableView.correspondingPairNameArray=completeCorrespondingArray;
        cell1.correspondingPairTableView.selectedScanpoint=selectedScanpointNameArray[indexPath.row-1];
        [cell1.correspondingPairTableView.tableview reloadData];
        if (_model.selectedHeaderIndexpath.count>0) {
            cell1.scanpointImageView.image=[UIImage imageNamed:@"Button-Expand"];
            for (NSString *i in _model.selectedHeaderIndexpath) {
                if ([i isEqual:[NSString stringWithFormat:@"%ld-%ld",(long)indexPath.row,(long)indexPath.section]]) {
                    cell1.scanpointImageView.image=[UIImage imageNamed:@"Button-Collapse"];
                    cell1.correspondingViewHeight.constant=cell1.correspondingPairTableView.tableview.contentSize.height;
                }
            }
        }else
        {
            cell1.correspondingViewHeight.constant=0;
            cell1.scanpointImageView.image=[UIImage imageNamed:@"Button-Expand"];
            cell1.correspondingViewHeight.constant=0;
        }
        
        return cell1;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height=30;
    if (indexPath.row==0) {
        return 30;
    }else {
        for (NSString *i in _model.selectedHeaderIndexpath) {
            if ([i isEqual:[NSString stringWithFormat:@"%ld-%ld",(long)indexPath.row,(long)indexPath.section]]) {
//                NSArray *ar=[i componentsSeparatedByString:@"-"];
//                int height1=[ar[0] intValue];
//                height=[_model.correspondingPairHeight[height1] floatValue]+30;
                for (NSDictionary *dict in _model.correspondingPairHeight) {
                    if (dict[i]) {
                          height=[dict[i] floatValue]+30;
                        break;
                    }
                }
                
            }
        }
        return height;
    }
}
-(NSString*)nameForCell:(NSIndexPath*)indexPath{
    NSString *str1;
    NSString *str=selectedSectionNameArray[indexPath.section];
    if (completeDetailOfSectionArray.count>0) {
        NSDictionary *dict=completeDetailOfSectionArray[0];
        NSArray *ar=dict[str];
        if (indexPath.row==0) {
            NSDictionary *dict1=ar[indexPath.row];
            str1= dict1[@"SectionName"];
        }else{
            NSDictionary *dict1=ar[indexPath.row-1];
            str1= dict1[@"ScanPointName"];
        }
    }
    return str1;
}
-(int)getNumberOfScanpointRow:(int)section{
    NSArray *ar;
    NSString *str=selectedSectionNameArray[section];
    if (completeDetailOfSectionArray.count>0) {
        NSDictionary *dict=completeDetailOfSectionArray[0];
       ar =dict[str];
    }
    return ar.count;
}
-(void)selectedHeaderCell:(UITableViewCell *)cell{
    HeaderTableViewCell *cell1=(HeaderTableViewCell*)cell;
    NSIndexPath *indexPath=[self.tableview indexPathForCell:cell1];
    NSString *str=[NSString stringWithFormat:@"%ld-%ld",(long)indexPath.row,(long)indexPath.section];
    if (![_model.selectedHeaderIndexpath containsObject:str]) {
        [self.delegate selectedCell:str withCorrespondingHeight:0];
    }else[self.delegate deselectedCell:str withCorrespondingHeight:0];
}
-(void)selectedScanPoint:(UITableViewCell *)cell{
    ScanPointTableViewCell *cell1=(ScanPointTableViewCell*)cell;
    NSIndexPath *indexPath=[self.tableview indexPathForCell:cell1];
    NSString *selectedIndex=[NSString stringWithFormat:@"%ld-%ld",(long)indexPath.row,(long)indexPath.section];
    if (![_model.selectedHeaderIndexpath containsObject:selectedIndex]) {
        [self.delegate selectedCell:selectedIndex withCorrespondingHeight:cell1.correspondingPairTableView.tableview.contentSize.height];
    }else{
        [self.delegate deselectedCell:selectedIndex withCorrespondingHeight:0];
    }
}
-(void)gettheSection{
    [selectedSectionNameArray removeAllObjects];
    [selectedScanpointNameArray removeAllObjects];
    [completeDetailOfSectionArray removeAllObjects];
    [completeCorrespondingArray removeAllObjects];
    for (NSDictionary *dict in _model.anotomicalPointArray) {
        if (![selectedSectionNameArray containsObject:dict[@"SectionCode"]]) {
            if (dict[@"SectionCode"]!=nil) {
                [selectedSectionNameArray addObject:dict[@"SectionCode"]];
            }
        }
        if (![selectedScanpointNameArray containsObject:dict[@"ScanPointCode"]]) {
            if (dict[@"ScanPointCode"]!=nil) {
                [selectedScanpointNameArray addObject:dict[@"ScanPointCode"]];
            }
        }
    }
    int i=0;
    NSMutableDictionary *dict2=[[NSMutableDictionary alloc]init];
    while (i!=selectedSectionNameArray.count) {
        NSString *str=selectedSectionNameArray[i];
        NSMutableArray *ar=[[NSMutableArray alloc]init];
        for(NSDictionary *dict1 in _model.anotomicalPointArray){
            if ([dict1[@"SectionCode"] isEqual:str]) {
                [ar addObject:dict1];
            }
        }
        dict2[str]=ar;
        i++;
    }
    if (dict2.count!=0) {
        [completeDetailOfSectionArray addObject:dict2];
    }
    i=0;
    NSMutableDictionary *scandict=[[NSMutableDictionary alloc]init];
    while (i!=selectedScanpointNameArray.count) {
        NSString *str1=selectedScanpointNameArray[i];
        NSMutableArray *ar=[[NSMutableArray alloc]init];
        for(NSDictionary *dict1 in _model.anotomicalPointArray){
            if ([dict1[@"ScanPointCode"] isEqual:str1]) {
                [ar addObject:dict1];
            }
        }
        scandict[str1]=ar;
        i++;
    }
    if (scandict.count!=0) {
     [completeCorrespondingArray addObject:scandict];
    }
    [selectedSectionNameArray addObject:[MCLocalization stringForKey:@"Price"]];
    [selectedSectionNameArray addObject:[MCLocalization stringForKey:@"Completed"]];
    
}
-(float)getTHeHeightOfTableVIew{
    [_tableview reloadData];
    CGRect frame=_tableview.frame;
    frame.size.height=_tableview.contentSize.height;
    _tableview.frame=frame;
    return _tableview.contentSize.height;
}
@end
