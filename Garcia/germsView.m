#import "germsView.h"
#import "Constant.h"
#import "AppDelegate.h"
#import "Postman.h"
#import "PostmanConstant.h"
#import "MBProgressHUD.h"
#import "germsModel.h"
@implementation germsView
{
    UIView *view;
    UIControl  *alphaView;
    NSMutableArray *germsArray,*selectedIndex,*selectedGerms;
    Constant *constant;
    Postman *postman;
}
-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    view=[[[NSBundle mainBundle]loadNibNamed:@"germsView" owner:self options:nil]lastObject];
    [self initializeView];
    view.frame=self.bounds;
    constant=[[Constant alloc]init];
    postman=[[Postman alloc]init];
     germsArray=[[NSMutableArray alloc]init];
    selectedIndex=[[NSMutableArray alloc]init];
     selectedGerms=[[NSMutableArray alloc]init];
     [self addSubview:view];
    return self;
}
-(void)initializeView
{
    view.layer.cornerRadius = 10;
    view.layer.masksToBounds  = YES;
    [constant SetBorderForTextField:_codeSymbolTF];
     [constant SetBorderForTextField:_codeFullNameTF];
    [constant spaceAtTheBeginigOfTextField:_codeFullNameTF];
     [constant spaceAtTheBeginigOfTextField:_codeSymbolTF];
}
-(void)alphaViewInitialize{
    if (alphaView == nil)
    {
        alphaView = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
        alphaView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
        [alphaView addSubview:view];
    }
    _codeFullNameTF.text=@"";
    _codeSymbolTF.text=@"";
    AppDelegate *appDel = [UIApplication sharedApplication].delegate;
    [appDel.window addSubview:alphaView];
    [self changeTheNewGermAppearence:YES withHeight:0];
    [constant SetBorderForTextField:_codeSymbolTF];
    [constant SetBorderForTextField:_codeFullNameTF];
    _codeSymbolTF.attributedPlaceholder=[constant textFieldPlaceHolderText:@"Symbol"];
    _codeFullNameTF.attributedPlaceholder=[constant textFieldPlaceHolderText:@"Name"];
    [constant spaceAtTheBeginigOfTextField:_codeSymbolTF];
     [constant spaceAtTheBeginigOfTextField:_codeFullNameTF];
    [alphaView addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [selectedIndex removeAllObjects];
    [selectedGerms removeAllObjects];
    [germsArray removeAllObjects];
    [self callApiToGetGerms];
    view.center = alphaView.center;
    
}
-(void)hide{
    [alphaView removeFromSuperview];
}
- (IBAction)add:(id)sender {
    [self changeTheNewGermAppearence:YES withHeight:0];
    [self heightOfView:106];
}
- (IBAction)saveCode:(id)sender {
    [alphaView removeFromSuperview];
         [self.delegateForGerms germsData:selectedGerms];
}
- (IBAction)addNewGerm:(id)sender {
    _codeFullNameTF.text=@"";
    _codeSymbolTF.text=@"";
    [self changeTheNewGermAppearence:NO withHeight:43];
    [self heightOfView:166];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return germsArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GermsTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        [[NSBundle mainBundle] loadNibNamed:@"GermsCell" owner:self options:nil];
        cell=_customCell;
        _customCell=nil;
    }
    if (germsArray.count>0) {
        germsModel *model=germsArray[indexPath.row];
        cell.label.text=model.germsName;
    }
    if ([selectedIndex containsObject:indexPath]) {
        cell.cellImageView.image=[UIImage imageNamed:@"Box1-Check.png"];
    }else cell.cellImageView.image=[UIImage imageNamed:@"Box1-Uncheck.png"];
        return cell;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor=[UIColor clearColor];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    germsModel *model=germsArray[indexPath.row];
    if ([selectedIndex containsObject:indexPath]) {
        [selectedIndex removeObject:indexPath];
        [selectedGerms removeObject:model];
    }
    else{
        [selectedIndex addObject:indexPath];
         [selectedGerms addObject:model];
    }
    [_tableView reloadData];

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35;
}
-(void)callApiToGetGerms{
    NSString *url=[NSString stringWithFormat:@"%@%@",baseUrl,germsUrl];
    [postman get:url withParameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processGerms:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}
-(void)processGerms:(id)responseObject{
    NSDictionary *dict=responseObject;
    for (NSDictionary *dict1 in dict[@"GenericSearchViewModels"]) {
        if ([dict1[@"Status"] intValue]==1) {
            germsModel *model=[[germsModel alloc]init];
            model.germsCode=dict1[@"Code"];
            model.germsName=dict1[@"Name"];
            model.germsId=dict1[@"Id"];
            [germsArray addObject:model];
        }
    }
    [_tableView reloadData];
    NSArray *ar=[_fromParentViewGermsString componentsSeparatedByString:@","];
    for (NSString *str in ar) {
        for (int i=0; i<germsArray.count; i++) {
            germsModel *model=germsArray[i];
            if ([str isEqualToString:model.germsName]) {
                [self tableView:_tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            }
        }
        }
        [self heightOfView:106];
}
-(void)heightOfView:(CGFloat)height{
    CGRect frame=view.frame;
    if (_tableView.contentSize.height+height<_heightOfSuperView-450) {
         _tableviewHeight.constant=_tableView.contentSize.height;
        frame.size.height=_tableView.contentSize.height+height;
    }else{
        _tableviewHeight.constant=_heightOfSuperView-height-480;
        frame.size.height=_heightOfSuperView-450;
    }
    self.frame=frame;
    view.frame=self.bounds;
    AppDelegate *appDel = [UIApplication sharedApplication].delegate;
    view.center = appDel.window.center;
}
-(void)changeTheNewGermAppearence:(BOOL)status withHeight:(CGFloat)height{
    _germNewAddButton.hidden=status;
    _germNewAddView.hidden=status;
    _heightOfNewGermView.constant=height;
}
@end
