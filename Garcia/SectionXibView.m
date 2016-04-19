#import "SectionXibView.h"
#import "ToxicDeficiency.h"
@implementation SectionXibView
{
    NSMutableArray *allSectionNameArray;
    int selectedRow;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])){
        UIView *subView = [[[NSBundle mainBundle] loadNibNamed:@"SectionXib"
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
        allSectionNameArray=[[NSMutableArray alloc]init];
    }
    return self;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return allSectionNameArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SectionXibTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        [[NSBundle mainBundle] loadNibNamed:@"SctionXibCell" owner:self options:nil];
        cell=_sectionXibCell;
        _sectionXibCell=nil;
    }
    NSArray *ar;
    if (selectedRow==2) {
      ar=[allSectionNameArray[indexPath.row] componentsSeparatedByString:@"$"];
        cell.label.text=ar[0];
    }else{
        ToxicDeficiency *model=allSectionNameArray[indexPath.row];
     cell.label.text=model.name;
    }
       _tableView.tableFooterView=[UIView new];
    return cell;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor=[UIColor clearColor];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (selectedRow==2) {
          [self.delegateForGetName getSectionName:allSectionNameArray[indexPath.row] withIndex:indexPath withCellIndex:selectedRow];
    }
    else if (selectedRow==3) {
    ToxicDeficiency *model=allSectionNameArray[indexPath.row];
    NSString *str=  [NSString stringWithFormat:@"%@$%@",model.code,model.name];
     [self.delegateForGetName getSectionName:str withIndex:indexPath withCellIndex:selectedRow];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35;
}
-(CGFloat)getHeightOfView{
    return _tableView.contentSize.height;
}
-(void)reloadData:(NSMutableArray*)array withIndex:(int)i{
    selectedRow=i;
    [allSectionNameArray removeAllObjects];
    [allSectionNameArray addObjectsFromArray:array];
    [_tableView reloadData];
}
@end
