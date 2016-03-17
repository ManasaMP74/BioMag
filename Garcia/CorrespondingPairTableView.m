#import "CorrespondingPairTableView.h"

@implementation CorrespondingPairTableView
{
    UIView *view;
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
}
    return self;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSArray *ar=_correspondingPairNameArray[0];
    return ar.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int i=[self getNumberOfRows:section];
    return i;
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
    NSString *str=[self nameForCell:indexPath];
     CGFloat labelHeight=[str boundingRectWithSize:(CGSize){280,CGFLOAT_MAX } options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont fontWithName:@"OpenSans" size:13]} context:nil].size.height;
    if (labelHeight>30) {
        return labelHeight+10;
    }
    else return 30;
}
-(NSString*)nameForCell:(NSIndexPath*)indexPath{
    NSString *str=@"";
    if (_correspondingPairNameArray.count>0) {
        NSArray *ar=_correspondingPairNameArray[0];
        NSDictionary *dict=ar[indexPath.section];
        if (indexPath.row==0) {
            str=dict[@"CorrespondingPairName"];
        }
        else  if (indexPath.row==1) str =dict[@"GermsName"];
        else  str=dict[@"Notes"];
    }
    return str;
}
-(int)getNumberOfRows:(int)section{
    int i=2;
    if (_correspondingPairNameArray.count>0) {
        NSArray *ar=_correspondingPairNameArray[0];
        NSDictionary *dict=ar[section];
        if (dict[@"Notes"]) {
            NSString *str=dict[@"Notes"];
            if (str.length>0) {
                  i=3;
            }
        }
    }
    return i;
}
@end
