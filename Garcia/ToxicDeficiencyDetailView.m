#import "ToxicDeficiencyDetailView.h"
#import "AppDelegate.h"
#import "Postman.h"
#import "PostmanConstant.h"
#import "MBProgressHUD.h"
#import "ToxicDeficiencyDetailModel.h"
#import "SeedSyncer.h"
#import "AppDelegate.h"

@implementation ToxicDeficiencyDetailView
{
    NSMutableArray *toxicArray,*selectedIndex,*selectedGerms;
    Postman *postman;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])){
        UIView *subView = [[[NSBundle mainBundle] loadNibNamed:@"ToxicDeficiencyView" owner:self options:nil] objectAtIndex:0];
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
        AppDelegate *appdelegate=[UIApplication sharedApplication].delegate;
        postman=[[Postman alloc]init];
        toxicArray=[[NSMutableArray alloc]init];
        selectedIndex=[[NSMutableArray alloc]init];
        selectedGerms=[[NSMutableArray alloc]init];
         [self callSeed];
        if ([appdelegate.isTreatmntCompleted intValue]==0) _tableView.userInteractionEnabled=YES;
        else _tableView.userInteractionEnabled=NO;
    }
        return  self;
}
-(void)callSeed{
    [[SeedSyncer sharedSyncer] callSeedAPI:^(BOOL success) {
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        if ([userDefault boolForKey:@"toxicdeficiency_FLAG"]) {
            [self callApiToToxicDeficiency];
        }
        else{
           NSString *url=[NSString stringWithFormat:@"%@%@",baseUrl,toxicDeficiencyDetail];
            [[SeedSyncer sharedSyncer]getResponseFor:url completionHandler:^(BOOL success, id response) {
                if (success) {
                    [self processToxicDeficiency:response];
                }
                else{
                    [self callApiToToxicDeficiency];
                }
            }];
        }
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return toxicArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ToxicDeficiencyCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        [[NSBundle mainBundle] loadNibNamed:@"ToxicDeficiencyCell" owner:self options:nil];
        cell=_customCell;
        _customCell=nil;
    }
    if (toxicArray.count>0) {
        ToxicDeficiencyDetailModel *model=toxicArray[indexPath.row];
        cell.label.text=model.toxicName;
    }
    if ([selectedIndex containsObject:indexPath]) {
        cell.cellImageView.image=[UIImage imageNamed:@"Box1-Check.png"];
    }else cell.cellImageView.image=[UIImage imageNamed:@"Box1-Uncheck.png"];
    tableView.tableFooterView=[UIView new];
    return cell;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
     cell.backgroundColor=[UIColor colorWithRed:0.38 green:0.82 blue:0.961 alpha:1];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ToxicDeficiencyDetailModel *model=toxicArray[indexPath.row];
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
-(void)callApiToToxicDeficiency{
    NSString *url=[NSString stringWithFormat:@"%@%@",baseUrl,toxicDeficiencyDetail];
    [postman get:url withParameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processToxicDeficiency:responseObject];
        [[SeedSyncer sharedSyncer]saveResponse:[operation responseString] forIdentity:url];
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setBool:NO forKey:@"toxicdeficiency_FLAG"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}
-(void)processToxicDeficiency:(id)responseObject{
    NSDictionary *dict=responseObject;
    NSArray *ar=[_selectedToxicCode componentsSeparatedByString:@"$"];
    for (NSDictionary *dict1 in dict[@"ViewModels"]) {
        if ([dict1[@"Status"] intValue]==1) {
            if ([ar[0] isEqualToString:dict1[@"ToxicDeficiencyTypeCode"]]) {
            ToxicDeficiencyDetailModel *model=[[ToxicDeficiencyDetailModel alloc]init];
            model.toxicCode=dict1[@"Code"];
            model.toxicName=dict1[@"Name"];
            model.toxicId=dict1[@"Id"];
            [toxicArray addObject:model];
            }
        }
    }
        [_tableView reloadData];
}
@end
