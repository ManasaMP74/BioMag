#import "CorrespondingPointView.h"
#import "AppDelegate.h"
@implementation CorrespondingPointView
{
    UIView *view;
    UIControl *alphaView;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])){
        UIView *subView = [[[NSBundle mainBundle] loadNibNamed:@"CorrespondingPointView"
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
//        [_correspondingTableView registerNib:[UINib nibWithNibName:@"CorrespondingPointCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        [_correspondingTableView reloadData];
    }
    
    return self;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     return _correspondingPointArray.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   CorrespondingPointCell  *cell = (CorrespondingPointCell *)[tableView dequeueReusableCellWithIdentifier:@"cell2"];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"CorrespondingPointCell" owner:self options:nil];
        cell = _correspondingCell;
        _correspondingCell = nil;
    }
        cell.correspondingLabel.text=_correspondingPointArray[indexPath.row];
       return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
return 20;
}
-(float)corespondingCellHeight
{
    return _correspondingTableView.contentSize.height;
}
@end
