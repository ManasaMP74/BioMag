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
    NSMutableArray *sortedToxicArray;
    Postman *postman;
    AppDelegate *appdelegate;
    NSMutableArray *sortedArrayBeforeSearch;
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
       appdelegate=  [UIApplication sharedApplication].delegate;
        postman=[[Postman alloc]init];
        _toxicArray=[[NSMutableArray alloc]init];
        sortedToxicArray=[[NSMutableArray alloc]init];
    }
        return  self;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return sortedToxicArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ToxicDeficiencyCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        [[NSBundle mainBundle] loadNibNamed:@"ToxicDeficiencyCell" owner:self options:nil];
        cell=_customCell;
        _customCell=nil;
    }
    if (sortedToxicArray.count>0) {
        ToxicDeficiencyDetailModel *model=sortedToxicArray[indexPath.row];
        cell.label.text=model.toxicName;
    if (model.selected==YES) {
        cell.cellImageView.image=[UIImage imageNamed:@"Box2-Check.png"];
    }else cell.cellImageView.image=[UIImage imageNamed:@"Box2-Uncheck.png"];
    }
    tableView.tableFooterView=[UIView new];
    return cell;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row%2==0) {
        cell.backgroundColor=[UIColor colorWithRed:0.38 green:0.82 blue:0.961 alpha:1];
    }else{
        cell.backgroundColor=[UIColor colorWithRed:0.667 green:0.902 blue:0.976 alpha:1];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ToxicDeficiencyDetailModel *model=sortedToxicArray[indexPath.row];
    for (ToxicDeficiencyDetailModel *m in _toxicArray) {
        if ([model.toxicCode isEqualToString:m.toxicCode]) {
            if (m.selected==YES) {
                model.selected=NO;
                m.selected=NO;
            }
            else{
                model.selected=YES;
                m.selected=YES;
            }
        }
    }
    [_tableView reloadData];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35;
}
-(void)callSeed{
    //  if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
    //      //For Vzone API
    //      [self callApiToToxicDeficiency];
    //  }else{
    //      //For Material API
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
    //}
}
-(void)callApiToToxicDeficiency{
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    NSString *url=[NSString stringWithFormat:@"%@%@",baseUrl,toxicDeficiencyDetail];
        if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
             NSString *parameter=[NSString stringWithFormat:@"{\"request\":}}"];
            [postman post:url withParameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [MBProgressHUD hideHUDForView:self animated:NO];
                [self processToxicDeficiency:responseObject];
                [[SeedSyncer sharedSyncer]saveResponse:[operation responseString] forIdentity:url];
                NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                [userDefault setBool:NO forKey:@"toxicdeficiency_FLAG"];
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [MBProgressHUD hideHUDForView:self animated:NO];
                    NSString *str=[NSString stringWithFormat:@"%@",error];
                    [self showToastMessage:str];
            }];

        }else{
            [postman get:url withParameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  [MBProgressHUD hideHUDForView:self animated:NO];
                [self processToxicDeficiency:responseObject];
                [[SeedSyncer sharedSyncer]saveResponse:[operation responseString] forIdentity:url];
                NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                [userDefault setBool:NO forKey:@"toxicdeficiency_FLAG"];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [MBProgressHUD hideHUDForView:self animated:NO];
                NSString *str=[NSString stringWithFormat:@"%@",error];
                [self showToastMessage:str];

            }];
        }
}
-(void)processToxicDeficiency:(id)responseObject{
    [_toxicArray removeAllObjects];
    
    NSDictionary *dict;
    
    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
        //For Vzone API
        NSDictionary *responseDict1 = responseObject;
        dict  = responseDict1[@"aaData"];
        for (NSDictionary *dict1 in dict[@"GenericSearchViewModels"]) {
            if ([dict1[@"Status"] intValue]==1) {
                ToxicDeficiencyDetailModel *model=[[ToxicDeficiencyDetailModel alloc]init];
                model.toxicCode=dict1[@"Code"];
                model.toxicName=dict1[@"Name"];
                model.toxicId=dict1[@"Id"];
                model.selected=NO;
                model.toxicTypeCode=dict1[@"ToxicDeficiencyTypeCode"];
                [_toxicArray addObject:model];
            }
        }
    }else{
        //For Material API
        dict=responseObject;
        for (NSDictionary *dict1 in dict[@"ViewModels"]) {
            if ([dict1[@"Status"] intValue]==1) {
                ToxicDeficiencyDetailModel *model=[[ToxicDeficiencyDetailModel alloc]init];
                model.toxicCode=dict1[@"Code"];
                model.toxicName=dict1[@"Name"];
                model.toxicId=dict1[@"Id"];
                model.selected=NO;
                model.toxicTypeCode=dict1[@"ToxicDeficiencyTypeCode"];
                [_toxicArray addObject:model];
            }
        }
    }
    [self sortData];
}
-(void)sortData{
    sortedArrayBeforeSearch=[[NSMutableArray alloc]init];
    NSArray *selectedToxicArray=[_selectedToxicDeficiency componentsSeparatedByString:@","];
    for (NSString *str in selectedToxicArray) {
        if(![str isEqualToString:@""]){
            NSArray *ar1=[str componentsSeparatedByString:@":"];
            for (ToxicDeficiencyDetailModel *m in _toxicArray) {
                if ([m.toxicCode isEqualToString:ar1[1]] & [m.toxicTypeCode isEqualToString:ar1[0]]) {
                    m.selected=YES;
                }
            }
        }
    }
    [sortedToxicArray removeAllObjects];
    NSArray *ar=[_selectedToxicCode componentsSeparatedByString:@"$"];
    for (ToxicDeficiencyDetailModel *model in _toxicArray) {
        if ([ar[0] isEqualToString:model.toxicTypeCode]) {
            ToxicDeficiencyDetailModel *m=[[ToxicDeficiencyDetailModel alloc]init];
            m.toxicCode=model.toxicCode;
            m.toxicName=model.toxicName;
            m.toxicId=model.toxicId;
            m.selected=model.selected;
            m.toxicTypeCode=model.toxicTypeCode;
            [sortedToxicArray addObject:m];
        }
    }
      [sortedArrayBeforeSearch addObjectsFromArray:sortedToxicArray];
    if ([_isTreatmntCompleted intValue]==0) _tableView.userInteractionEnabled=YES;
    else _tableView.userInteractionEnabled=NO;
       [_tableView reloadData];
    [self layoutIfNeeded];
    [_tableView setContentOffset:CGPointZero animated:YES];
}
-(NSString*)getAllTheSelectedToxic{
    NSString *str=@"";
    for (ToxicDeficiencyDetailModel *model in _toxicArray) {
        if (model.selected==YES) {
            NSString *str1=[NSString stringWithFormat:@"%@:%@",model.toxicTypeCode,model.toxicCode];
            str1=[str1 stringByAppendingString:@","];
            str=[str stringByAppendingString:str1];
        }
    }
      return str;
}
//Toast Message
-(void)showToastMessage:(NSString*)msg{
    MBProgressHUD *hubHUD=[MBProgressHUD showHUDAddedTo:self animated:YES];
    hubHUD.mode=MBProgressHUDModeText;
    hubHUD.detailsLabelText=msg;
    hubHUD.detailsLabelFont=[UIFont systemFontOfSize:15];
    hubHUD.margin=20.f;
    hubHUD.yOffset=150.f;
    hubHUD.removeFromSuperViewOnHide = YES;
    [hubHUD hide:YES afterDelay:2];
}
-(void)toxicSearchData:(NSString*)searchText{
    [sortedToxicArray removeAllObjects];
    if (searchText.length>=3) {
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"toxicName CONTAINS[cd]%@",searchText];
        NSArray *ar=[sortedArrayBeforeSearch filteredArrayUsingPredicate:predicate];
        [sortedToxicArray addObjectsFromArray:ar];
    }else{
        [sortedToxicArray addObjectsFromArray:sortedArrayBeforeSearch];
    }
     [_tableView reloadData];
    [self layoutIfNeeded];
    [_tableView setContentOffset:CGPointZero animated:YES];
}
@end
