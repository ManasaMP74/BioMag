#import "HeaderTableView.h"
@implementation HeaderTableView
{
    NSMutableArray *sittingArray,*scanPointArray;
    NSIndexPath *selectedHeaderIndexPath,*selectedNote;
    NSMutableArray *selectedScanPointIndexPath;
    CGFloat correspondingViewHeight;
    NSMutableArray *selectedScanPoint;
    UITextView *textview;
    SittingModelClass *modelValue;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])){
        UIView *subView = [[[NSBundle mainBundle] loadNibNamed:@"HeaderTableView"
                                                         owner:self
                                                       options:nil] objectAtIndex:0];
        [self addSubview: subView];
        subView.translatesAutoresizingMaskIntoConstraints = NO;
        NSDictionary *views = NSDictionaryOfVariableBindings(subView);
        
        NSArray *constrains = [NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[subView]-(0)-|"
                                                                      options:kNilOptions
                                                                      metrics:nil
                                                                        views:views];
        [self addConstraints:constrains];
        
        constrains = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[subView]-(0)-|"
                                                             options:kNilOptions
                                                             metrics:nil
                                                               views:views];
        [self addConstraints:constrains];
        sittingArray=[[NSMutableArray alloc]init];
        scanPointArray=[[NSMutableArray alloc]init];
        sittingArray=[@[@"Head",@"Interval",@"Notes",@"Completed"]mutableCopy];
        scanPointArray=[@[@"Inter Ciliary",@"Eye",@"Thyroid"]mutableCopy];
        selectedHeaderIndexPath=nil;
        selectedScanPointIndexPath=[[NSMutableArray alloc]init];
        modelValue=[[SittingModelClass alloc]init];
        [_headerTableview reloadData];
    }
    return self;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (selectedHeaderIndexPath != nil) {
        if (selectedHeaderIndexPath.section == section) {
            return scanPointArray.count+1;
        }
        else
            return 1;
    }
    else
        return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return sittingArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        CollectionViewTableViewCell *cell = (CollectionViewTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"CollectionViewTableViewCell" owner:self options:nil];
            cell = _cell;
            _cell = nil;
        }
        cell.headLabel.text=sittingArray[indexPath.section];
        if (indexPath.section==sittingArray.count-1) {
            cell.userInteractionEnabled=NO;
            cell.headIncreaseButton.hidden=YES;
            cell.switchImageView.hidden=NO;
            cell.intervalLabel.hidden=YES;
        }
        else if (indexPath.section==sittingArray.count-3) {
            cell.userInteractionEnabled=NO;
            cell.headIncreaseButton.hidden=YES;
            cell.switchImageView.hidden=YES;
            cell.intervalLabel.hidden=NO;
        }
        else {
            cell.userInteractionEnabled=YES;
            cell.headIncreaseButton.hidden=NO;
            cell.switchImageView.hidden=YES;
            cell.intervalLabel.hidden=YES;
            if (indexPath.section==sittingArray.count-2) {
                if (textview==nil)
                    textview=[[UITextView alloc]initWithFrame:CGRectMake(cell.frame.origin.x+20, 42,cell.frame.size.width,85)];
                textview.layer.cornerRadius=5;
                textview.layer.borderColor=[UIColor colorWithRed:0.682 green:0.718 blue:0.729 alpha:0.6].CGColor;
                textview.layer.borderWidth=1;
                textview.backgroundColor=[UIColor colorWithRed:0.933 green:0.933 blue:0.94 alpha:1];
                textview.text=@"Doctor will add note";
                textview.textContainerInset = UIEdgeInsetsMake(10, 10,10, 10);
                textview.textColor=[UIColor lightGrayColor];
                textview.font=[UIFont fontWithName:@"OpenSansRegular" size:12];
                [cell addSubview:textview];
                if (selectedNote!=nil) {
                    textview.hidden=NO;
                }
                else{
                    textview.userInteractionEnabled=NO;
                    textview.hidden=YES;
                }
            }
        }
        return cell;
    }
    else{
        ScanPoinTableViewCell *cell = (ScanPoinTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell1"];
        if (cell == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"ScanPointTableViewCell" owner:self options:nil];
            cell = _scanPointCell;
            _scanPointCell = nil;
        }
        cell.scanpointLabel.text=scanPointArray[indexPath.row-1];
        cell.delegate=self;
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor=[UIColor colorWithRed:0.839 green:0.847 blue:0.94 alpha:1];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (selectedScanPointIndexPath.count>0) {
        if ([selectedScanPointIndexPath containsObject:indexPath]) {
            return correspondingViewHeight+32;
        }
        else if (selectedNote != nil){
            if (selectedNote.section == indexPath.section) {
                return 150;
            }
            else return 32;
        }
        else
            return 32;
    }
    else if (selectedNote != nil) {
        if (selectedNote.section == indexPath.section) {
            return 150;
        }
        else
            return 32;
    }
    
    else
        return 32;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        CollectionViewTableViewCell *cell = (CollectionViewTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        if ([cell.headIncreaseButton.currentBackgroundImage isEqual:[UIImage imageNamed:@"Button-Collapse"]]) {
            [self ChangeIncreaseDecreaseButtonImage:cell];
            if (indexPath.section==sittingArray.count-2) {
                selectedNote=indexPath;
                [tableView reloadData];
                CGRect frame=_headerTableview.frame;
                frame.size.height=_headerTableview.contentSize.height;
                _headerTableview.frame=frame;
                [self.delegate increaseHeadCellHeight:_headerTableview.contentSize.height withSelectedScanPoint:selectedScanPointIndexPath withHeader:selectedHeaderIndexPath withNoteHeader:indexPath];
            }
            else if (indexPath.section<sittingArray.count-3) {
                selectedHeaderIndexPath=indexPath;
                [tableView reloadData];
                CGRect frame=_headerTableview.frame;
                frame.size.height=_headerTableview.contentSize.height;
                _headerTableview.frame=frame;
                [self.delegate increaseHeadCellHeight:_headerTableview.contentSize.height withSelectedScanPoint:selectedScanPointIndexPath withHeader:indexPath withNoteHeader:selectedNote];
            }
        }
        else{
            [self ChangeIncreaseDecreaseButtonImage:cell];
            if (indexPath.section==sittingArray.count-2) {
                selectedNote=nil;
                [tableView reloadData];
                CGRect frame=_headerTableview.frame;
                frame.size.height=_headerTableview.contentSize.height;
                _headerTableview.frame=frame;
                [self.delegate decreaseHeadCellHeight:_headerTableview.contentSize.height withSelectedScanPoint:selectedScanPointIndexPath withHeader:selectedHeaderIndexPath withNoteHeader:selectedNote];
            }
            else if (indexPath.section<sittingArray.count-3) {
                selectedHeaderIndexPath=nil;
                [selectedScanPointIndexPath removeAllObjects];
                [tableView reloadData];
                CGRect frame=_headerTableview.frame;
                frame.size.height=_headerTableview.contentSize.height;
                _headerTableview.frame=frame;
                [self.delegate decreaseHeadCellHeight:_headerTableview.contentSize.height withSelectedScanPoint:nil withHeader:nil withNoteHeader:selectedNote];
            }
        }
    }
}
//ScanPoint Delegate Method
-(void)selectedScanPoint:(UITableViewCell *)cell{
    ScanPoinTableViewCell *scanCell=(ScanPoinTableViewCell*)cell;
    NSIndexPath *indexPath=[_headerTableview indexPathForCell:scanCell];
    if ([scanCell.sacnPointImageView.currentBackgroundImage isEqual:[UIImage imageNamed:@"Button-Collapse"]]) {
        [self ChangeIncreaseDecreaseButtonImage1:scanCell];
        [selectedScanPointIndexPath addObject:indexPath];
        if (indexPath.row==1) {
            scanCell.correspondingView.correspondingPointArray=@[@"Medulla Oblongata", @"Kidney",@"Sacrum"];
        }
        else if (indexPath.row==2){
            scanCell.correspondingView.correspondingPointArray=@[@"Eye Optic Nerve", @"Opposite Eye",@"Cerebellum"];
        }
        else scanCell.correspondingView.correspondingPointArray=@[@"Cheekbone", @"Liver",@"Adrenal Glands"];
        [scanCell.correspondingView.correspondingTableView reloadData];
        correspondingViewHeight = [scanCell.correspondingView corespondingCellHeight];
        scanCell.correspondingView.hidden = NO;
        scanCell.correspondingViewHeight.constant=correspondingViewHeight;
        [_headerTableview reloadData];
        CGRect frame=_headerTableview.frame;
        frame.size.height=_headerTableview.contentSize.height;
        _headerTableview.frame=frame;
        [self.delegate increaseHeadCellHeight:_headerTableview.contentSize.height withSelectedScanPoint:selectedScanPointIndexPath withHeader:[NSIndexPath indexPathForRow:0 inSection:0] withNoteHeader:selectedNote];
    }
    else{
        [self ChangeIncreaseDecreaseButtonImage1:scanCell];
        [selectedScanPointIndexPath removeObject: indexPath];
        scanCell.correspondingView.hidden=YES;
        scanCell.correspondingViewHeight.constant=0;
        [_headerTableview reloadData];
        CGRect frame=_headerTableview.frame;
        frame.size.height=_headerTableview.contentSize.height;
        _headerTableview.frame=frame;
        [self.delegate decreaseHeadCellHeight:_headerTableview.contentSize.height withSelectedScanPoint:selectedScanPointIndexPath withHeader:[NSIndexPath indexPathForRow:0 inSection:0] withNoteHeader:selectedNote];
    }
}
//Change the Header image
-(void)ChangeIncreaseDecreaseButtonImage:(CollectionViewTableViewCell*)cell{
    if ([cell.headIncreaseButton.currentBackgroundImage isEqual:[UIImage imageNamed:@"Button-Collapse"]]) {
        [cell.headIncreaseButton setBackgroundImage:[UIImage imageNamed:@"Button-Expand"] forState:UIControlStateNormal];
        
    }
    else  if ([cell.headIncreaseButton.currentBackgroundImage isEqual:[UIImage imageNamed:@"Button-Expand"]]) {
        [cell.headIncreaseButton setBackgroundImage:[UIImage imageNamed:@"Button-Collapse"] forState:UIControlStateNormal];
    }
}
//Change the ScanPoint image
-(void)ChangeIncreaseDecreaseButtonImage1:(ScanPoinTableViewCell*)cell{
    if ([cell.sacnPointImageView.currentBackgroundImage isEqual:[UIImage imageNamed:@"Button-Collapse"]]) {
        [cell.sacnPointImageView setBackgroundImage:[UIImage imageNamed:@"Button-Expand"] forState:UIControlStateNormal];
        
    }
    else  if ([cell.sacnPointImageView.currentBackgroundImage isEqual:[UIImage imageNamed:@"Button-Expand"]]) {
        [cell.sacnPointImageView setBackgroundImage:[UIImage imageNamed:@"Button-Collapse"] forState:UIControlStateNormal];
    }
}
-(float)increaseHeaderinHeaderTV :(SittingModelClass*)model
{
    if (model.selectedHeader) {
    if (model.noteIndex !=nil) {
            selectedNote=model.noteIndex;
            CollectionViewTableViewCell *cell = (CollectionViewTableViewCell *)[_headerTableview cellForRowAtIndexPath:model.noteIndex];
            [cell.headIncreaseButton setBackgroundImage:[UIImage imageNamed:@"Button-Expand"] forState:UIControlStateNormal];
    }
    else{
     selectedNote=model.noteIndex;
        CollectionViewTableViewCell *cell = (CollectionViewTableViewCell *)[_headerTableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
        [cell.headIncreaseButton setBackgroundImage:[UIImage imageNamed:@"Button-Collapse"] forState:UIControlStateNormal];

    }
    if (model.headerIndex!=nil) {
            selectedHeaderIndexPath=model.headerIndex;
            CollectionViewTableViewCell *cell = (CollectionViewTableViewCell *)[_headerTableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            [cell.headIncreaseButton setBackgroundImage:[UIImage imageNamed:@"Button-Expand"] forState:UIControlStateNormal];
            selectedScanPointIndexPath=[model.selectedScanPointIndexpath mutableCopy];
            [self getSelectedScanPoint:selectedScanPointIndexPath];
        }
    }
    else{
        selectedHeaderIndexPath=nil;
        selectedScanPoint=nil;
        selectedNote=nil;
        CollectionViewTableViewCell *cell = (CollectionViewTableViewCell *)[_headerTableview cellForRowAtIndexPath:model.noteIndex];
        [cell.headIncreaseButton setBackgroundImage:[UIImage imageNamed:@"Button-Collapse"] forState:UIControlStateNormal];
        CollectionViewTableViewCell *cell1 = (CollectionViewTableViewCell *)[_headerTableview cellForRowAtIndexPath:model.headerIndex];
        [cell1.headIncreaseButton setBackgroundImage:[UIImage imageNamed:@"Button-Collapse"] forState:UIControlStateNormal];
        [self notSelectedScanPoint:scanPointArray];
    }
    [_headerTableview reloadData];
    CGRect frame=_headerTableview.frame;
    frame.size.height=_headerTableview.contentSize.height;
    _headerTableview.frame=frame;
    return _headerTableview.contentSize.height;
}
-(float)decreaseHeaderinHeaderTV :(SittingModelClass*)model
{
    if (model.selectedHeader) {
        if (model.headerIndex!=nil) {
            selectedHeaderIndexPath=model.headerIndex;
            selectedScanPointIndexPath=[model.selectedScanPointIndexpath mutableCopy];
            CollectionViewTableViewCell *cell = (CollectionViewTableViewCell *)[_headerTableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            [cell.headIncreaseButton setBackgroundImage:[UIImage imageNamed:@"Button-Expand"] forState:UIControlStateNormal];
            [self getSelectedScanPoint:selectedScanPointIndexPath];
        }
        if (model.noteIndex !=nil) {
            selectedNote=model.noteIndex;
            CollectionViewTableViewCell *cell = (CollectionViewTableViewCell *)[_headerTableview cellForRowAtIndexPath:model.noteIndex];
            [cell.headIncreaseButton setBackgroundImage:[UIImage imageNamed:@"Button-Expand"] forState:UIControlStateNormal];
            [self getSelectedScanPoint:selectedScanPointIndexPath];
        }
    }
    else{
        selectedHeaderIndexPath=nil;
        selectedScanPoint=nil;
        if (model.noteIndex!=nil) {
            selectedNote=model.noteIndex;
            CollectionViewTableViewCell *cell = (CollectionViewTableViewCell *)[_headerTableview cellForRowAtIndexPath:selectedNote];
            [cell.headIncreaseButton setBackgroundImage:[UIImage imageNamed:@"Button-Expand"] forState:UIControlStateNormal];
        }
        else {
            selectedNote=nil;
            CollectionViewTableViewCell *cell1 = (CollectionViewTableViewCell *)[_headerTableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
            [cell1.headIncreaseButton setBackgroundImage:[UIImage imageNamed:@"Button-Collapse"] forState:UIControlStateNormal];
        }
        CollectionViewTableViewCell *cell = (CollectionViewTableViewCell *)[_headerTableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [cell.headIncreaseButton setBackgroundImage:[UIImage imageNamed:@"Button-Collapse"] forState:UIControlStateNormal];
        [self notSelectedScanPoint:scanPointArray];
    }
    CGRect frame=_headerTableview.frame;
    frame.size.height=model.height;
    _headerTableview.frame=frame;
    return _headerTableview.contentSize.height;

}
-(void)getSelectedScanPoint:(NSMutableArray*)selectedScanpointArray{
    [_headerTableview reloadData];
    if (selectedScanpointArray.count>0) {
        for (NSIndexPath *i in selectedScanpointArray) {
        ScanPoinTableViewCell *scanCell=(ScanPoinTableViewCell*)[_headerTableview cellForRowAtIndexPath:i];
           
            [scanCell.sacnPointImageView setBackgroundImage:[UIImage imageNamed:@"Button-Expand"] forState:UIControlStateNormal];
            if (i.row==1) {
                scanCell.correspondingView.correspondingPointArray=@[@"Medulla Oblongata", @"Kidney",@"Sacrum"];
            }
            else if (i.row==2){
                scanCell.correspondingView.correspondingPointArray=@[@"Eye Optic Nerve", @"Opposite Eye",@"Cerebellum"];
            }
            else scanCell.correspondingView.correspondingPointArray=@[@"Cheekbone", @"Liver",@"Adrenal Glands"];
            [scanCell.correspondingView.correspondingTableView reloadData];
            correspondingViewHeight = [scanCell.correspondingView corespondingCellHeight];
            scanCell.correspondingView.hidden = NO;
            scanCell.correspondingViewHeight.constant=correspondingViewHeight;
            [_headerTableview reloadData];
        }
    }
    else{
        [self notSelectedScanPoint:scanPointArray];
    }

}
-(void)notSelectedScanPoint:(NSMutableArray*)ar{
    for (int i=1; i<=ar.count;i++) {
        ScanPoinTableViewCell *scanCell=(ScanPoinTableViewCell*)[_headerTableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        [scanCell.sacnPointImageView setBackgroundImage:[UIImage imageNamed:@"Button-Collapse"] forState:UIControlStateNormal];
        scanCell.correspondingView.correspondingPointArray=nil;
        [scanCell.correspondingView.correspondingTableView reloadData];
        correspondingViewHeight = [scanCell.correspondingView corespondingCellHeight];
        scanCell.correspondingView.hidden = NO;
        scanCell.correspondingViewHeight.constant=correspondingViewHeight;
        [_headerTableview reloadData];
    }
}
@end
