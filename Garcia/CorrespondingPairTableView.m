#import "CorrespondingPairTableView.h"

@implementation CorrespondingPairTableView
{
    UIView *view;
    int numberOfRows;
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super initWithCoder:aDecoder]) {
        view=[[[NSBundle mainBundle]loadNibNamed:@"CorrespondingPairTableView" owner:self options:nil]objectAtIndex:0];
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
        numberOfRows=1;
}
    return self;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    [self getNumberOfRows];
        return numberOfRows;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        CorrespondingPairTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell==nil) {
            _customCell=[[[NSBundle mainBundle]loadNibNamed:@"CorrespondingPairTableViewCell" owner:self options:nil]lastObject];
            cell=_customCell;
            _customCell=nil;
        }
    cell.correspondingPairLabel.text=[self nameForCell:indexPath];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}
-(NSString*)nameForCell:(NSIndexPath*)indexPath{
    NSString *str=@"";
    if (_correspondingPairNameArray.count>0) {
        for (NSDictionary *dict in _correspondingPairNameArray) {
            NSArray *ar=dict[_selectedScanpoint];
            NSDictionary *dict1= ar[indexPath.row];
            str= [NSString stringWithFormat:@"%@ %@",dict1[@"CorrespondingPairName"],dict1[@"GermsName"]];
        }
    }
    return str;
}
-(void)getNumberOfRows{
    if (_correspondingPairNameArray.count>0) {
    for (NSDictionary *dict in _correspondingPairNameArray) {
        NSArray *ar=dict[_selectedScanpoint];
        numberOfRows=ar.count;
    }
}
}
@end
