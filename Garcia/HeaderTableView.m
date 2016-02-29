#import "HeaderTableVIew.h"
#import "HeaderModelClass.h"
#import <MCLocalization/MCLocalization.h>
#import "HeaderModelClass.h"
#import "sittingModel.h"
#import "germsModel.h"
#import "ToxicDeficiencyDetailModel.h"
@implementation HeaderTableVIew
{
    UIView *view;
    NSMutableArray *selectedSectionNameArray,*allBiamagneticArray,*selectedToxicDeficiency;
    NSMutableArray *completeDetailArray;
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
        allBiamagneticArray= [[NSMutableArray alloc]init];
        completeDetailArray=[[NSMutableArray alloc]init];
        selectedToxicDeficiency=[[NSMutableArray alloc]init];
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
        NSMutableArray *ar=[self getCorrespondingData:indexPath];
        cell1.correspondingPairTableView.correspondingPairNameArray=[ar copy];
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
    NSString *str1=@"";
    NSString *str=selectedSectionNameArray[indexPath.section];
    if (completeDetailArray.count>0) {
        for (NSDictionary *dict in completeDetailArray) {
            if (dict[str]) {
                HeaderModelClass *model=dict[str];
                if (indexPath.row==0) {
                    str1=model.sectionName;
                }
                else{
                    str1=model.scanpointNameArray[indexPath.row-1];
                }
            }
        }
    }
        return str1;
}
-(NSMutableArray*)getCorrespondingData:(NSIndexPath*)indexPath{
    NSMutableArray *ar=[[NSMutableArray alloc]init];
    NSDictionary *d;
    NSString *str=selectedSectionNameArray[indexPath.section];
    if (completeDetailArray.count>0) {
        for (NSDictionary *dict in completeDetailArray) {
            if (dict[str]) {
                HeaderModelClass *model=dict[str];
             NSString  *str1=model.scanpointCodeArray[indexPath.row-1];
                if (model.correspondingPair.count>0) {
            for (NSDictionary *dic in model.correspondingPair) {
                if (dic[str1]) {
                 d =dic[str1];
                  }
                }
              }
            }
        }
    }
     [ar addObject:d];
    return ar;
}
-(int)getNumberOfScanpointRow:(int)section{
    int i=0;
    NSString *str=selectedSectionNameArray[section];
    if (completeDetailArray.count>0) {
        for (NSDictionary *dict in completeDetailArray) {
            if (dict[str]) {
                HeaderModelClass *model=dict[str];
                i=model.scanpointCodeArray.count;
            }
        }
    }
    return i;
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
     [completeDetailArray removeAllObjects];
    for (NSDictionary *dict in _model.anotomicalPointArray) {
        if (![selectedSectionNameArray containsObject:dict[@"SectionCode"]]) {
            if (dict[@"SectionCode"]!=nil) {
                [selectedSectionNameArray addObject:dict[@"SectionCode"]];
            }
        }
    }
    int i=0;

    while (i!=selectedSectionNameArray.count) {
        HeaderModelClass *headerModel=[[HeaderModelClass alloc]init];
        headerModel.scanpointNameArray=[[NSMutableArray alloc]init];
        headerModel.scanpointCodeArray=[[NSMutableArray alloc]init];
        headerModel.correspondingPair=[[NSMutableArray alloc]init];
        NSString *str=selectedSectionNameArray[i];
        for(NSDictionary *dict2 in _model.anotomicalPointArray){
            if ([dict2[@"SectionCode"] isEqual:str]) {
                headerModel.sectionCode=dict2[@"SectionCode"];
                
                sittingModel *m1=[[sittingModel alloc]init];
                if (_sittingArray.count>0) {
                    for (sittingModel *m in _sittingArray) {
                        if ([dict2[@"AnatomicalBiomagenticCode"] isEqualToString:m.anatomicalBiomagenticCode]) {
                            m1=m;
                            break;
                        }
                    }
                }
                
                //headerModel.sectionName=dict2[@"SectionName"];
                headerModel.sectionName=m1.sectionName;
                if (![headerModel.scanpointCodeArray containsObject:dict2[@"ScanPointCode"]]) {
                    [headerModel.scanpointCodeArray addObject:dict2[@"ScanPointCode"]];
                   // [headerModel.scanpointNameArray addObject:dict2[@"ScanPointName"]];
                     [headerModel.scanpointNameArray addObject:m1.scanPointName];
                }
                int j=0;
                while (j!=headerModel.scanpointCodeArray.count) {
                    NSDictionary *dic;
                    NSMutableArray *ar=[[NSMutableArray alloc]init];
                    NSString *str2=headerModel.scanpointCodeArray[j];
                    for(NSDictionary *dict2 in _model.anotomicalPointArray){
                    if ([dict2[@"ScanPointCode"] isEqual:str2]) {
                    NSMutableDictionary *correspondingDict=[[NSMutableDictionary alloc]init];
                    correspondingDict[@"GermsCode"]=dict2[@"GermsCode"];
                     
                        NSArray *ar1=[dict2[@"GermsCode"] componentsSeparatedByString:@","];
                        NSString *germstr=@"";
                        if (ar1.count>0) {
                            for (int i=0; i<ar1.count; i++) {
                                if (_germsArray.count>0) {
                                    for (germsModel *g in _germsArray) {
                                        if ([g.germsUserFriendlycode isEqualToString:ar1[i]]) {
                                            germstr=[germstr stringByAppendingString:g.germsName];
                                            if (i!=ar1.count-1) {
                                                germstr=[germstr stringByAppendingString:@","];
                                            }
                                            break;
                                        }
                                    }
                                }
                                
                            }
                        }
                        
                    correspondingDict[@"GermsName"]=germstr;
                    correspondingDict[@"CorrespondingPairName"]=m1.correspondingPairName;
                    correspondingDict[@"CorrespondingPairCode"]=dict2[@"CorrespondingPairCode"];
                    correspondingDict[@"Notes"]=dict2[@"Notes"];
                        [ar addObject:correspondingDict];
                    }
            }
                 dic =[NSDictionary dictionaryWithObject:ar forKey:str2];
                [headerModel.correspondingPair addObject:dic];
                    j++;
            }
        }
        }
        NSDictionary *sectionDict=[NSDictionary dictionaryWithObject:headerModel forKey:str];
        [completeDetailArray addObject:sectionDict];
        i++;
    }
    
    if (_model.toxicDeficiency.length>0) {
        NSArray *ar=[_model.toxicDeficiency componentsSeparatedByString:@","];
        NSMutableArray *ar1=[[NSMutableArray alloc]init];
        for (NSString *str in ar) {
        NSArray *a = [str componentsSeparatedByString:@":"];
            [ar1 addObjectsFromArray:a];

        }
        for (int i=0; i<ar1.count-1;i++) {
            if (![selectedToxicDeficiency containsObject:ar1[i]]) {
                [selectedToxicDeficiency addObject:ar1[i]];
            }
            i++;
        }
        
//        int j=0;
//        while (j!=selectedToxicDeficiency.count) {
//            NSString  *selectedToxicType=selectedToxicDeficiency[j];
//            NSMutableArray *selectedToxicCode=[[NSMutableArray alloc]init];
//        for (int i=0; i<ar1.count-1; i++) {
//            if ([ar1[i] isEqual:selectedToxicType]) {
//                [selectedToxicCode addObject:ar1[i+1]];
//            }
//          }
//            
//            
//            NSDictionary *dict=[NSDictionary dictionaryWithObject:selectedToxicType forKey:<#(nonnull id<NSCopying>)#>]
//            j++;
//        }
        
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
