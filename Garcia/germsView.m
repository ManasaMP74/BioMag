#import "germsView.h"
#import "Constant.h"
#import "AppDelegate.h"
#import "Postman.h"
#import "PostmanConstant.h"
#import "MBProgressHUD.h"
#import "germsModel.h"
#import "SeedSyncer.h"
#import <MCLocalization/MCLocalization.h>
@implementation germsView
{
    UIView *view;
    UIControl  *alphaView;
    NSMutableArray *germsArray,*selectedIndex,*selectedGerms,*authorArray;
    Constant *constant;
    Postman *postman;
    NSString *alert,*alertOK,*symbolRequiredStr,*nameRequiredStr,*bothDataRequired;
}
-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    view=[[[NSBundle mainBundle]loadNibNamed:@"germsView" owner:self options:nil]lastObject];
    [self initializeView];
    view.frame=self.bounds;
    constant=[[Constant alloc]init];
    postman=[[Postman alloc]init];
    if ([_differenceStringBetweenAuthorAndGerms isEqualToString:@"germs"]) {
        germsArray=[[NSMutableArray alloc]init];
        selectedIndex=[[NSMutableArray alloc]init];
        selectedGerms=[[NSMutableArray alloc]init];
    }else{
        authorArray=[[NSMutableArray alloc]init];
    }
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
    postman=[[Postman alloc]init];
}
-(void)alphaViewInitialize{
    if (alphaView == nil)
    {
        alphaView = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
        alphaView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
        [alphaView addSubview:view];
    }
    [self localization];
    _codeFullNameTF.text=@"";
    _codeSymbolTF.text=@"";
    AppDelegate *appDel = [UIApplication sharedApplication].delegate;
    [appDel.window addSubview:alphaView];
    [self changeTheNewGermAppearence:YES withHeight:0];
    [constant SetBorderForTextField:_codeSymbolTF];
    [constant SetBorderForTextField:_codeFullNameTF];
    [constant spaceAtTheBeginigOfTextField:_codeSymbolTF];
    [constant spaceAtTheBeginigOfTextField:_codeFullNameTF];
    [alphaView addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    if ([_differenceStringBetweenAuthorAndGerms isEqualToString:@"germs"]) {
        [selectedIndex removeAllObjects];
        [selectedGerms removeAllObjects];
        if (_completeGermsArray.count>0) {
            [germsArray addObjectsFromArray:_completeGermsArray];
            [self displayTheSelectedGerms];
        }else [self callSeed];
    }else{
        if (_completeAuthorArray.count>0) {
            [authorArray removeAllObjects];
            [authorArray addObjectsFromArray:_completeAuthorArray];
            [_tableView reloadData];
            [view layoutIfNeeded];
            [self heightOfView:130];
        }else [self callSeedForAuthor];
    }
    view.center = alphaView.center;
}

-(void)hide{
    [alphaView removeFromSuperview];
}
- (IBAction)add:(id)sender {
    [alphaView endEditing:YES];
    if (![_codeFullNameTF.text isEqualToString:@""] & ![_codeSymbolTF.text isEqualToString:@""]) {
        if ([_differenceStringBetweenAuthorAndGerms isEqualToString:@"germs"]) {
            [self callApiToAddGerm];
        }else{
            [self callApiForAddAuthor];
        }
    }else if ([_codeFullNameTF.text isEqualToString:@""] & [_codeSymbolTF.text isEqualToString:@""]) {
        [self showToastMessage:bothDataRequired];
    }else if ([_codeFullNameTF.text isEqualToString:@""]){
        [self showToastMessage:nameRequiredStr];
    }else{
        [self showToastMessage:symbolRequiredStr];
    }
}
- (IBAction)saveCode:(id)sender {
    [alphaView removeFromSuperview];
    [alphaView endEditing:YES];
    [self.delegateForGerms germsData:selectedGerms];
}
- (IBAction)addNewGerm:(id)sender {
    [alphaView endEditing:YES];
    if (_germNewAddButton.hidden) {
        _codeFullNameTF.text=@"";
        _codeSymbolTF.text=@"";
        [self changeTheNewGermAppearence:NO withHeight:43];
        [self heightOfView:200];
    }else{
        [self changeTheNewGermAppearence:YES withHeight:0];
        [self heightOfView:130];
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([_differenceStringBetweenAuthorAndGerms isEqualToString:@"germs"]) {
        return germsArray.count;
    }else return authorArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GermsTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        [[NSBundle mainBundle] loadNibNamed:@"GermsCell" owner:self options:nil];
        cell=_customCell;
        _customCell=nil;
    }
    if ([_differenceStringBetweenAuthorAndGerms isEqualToString:@"germs"]) {
        if (germsArray.count>0) {
            [self hideCellView:cell withStatus:NO];
            germsModel *model=germsArray[indexPath.row];
            cell.label.text=[NSString stringWithFormat:@"%@",model.germsUserFriendlycode];
            cell.labelTwo.text=[NSString stringWithFormat:@"%@",model.germsName];
            
            if ([selectedIndex containsObject:indexPath]) {
                cell.cellImageView.image=[UIImage imageNamed:@"Box1-Check.png"];
            }else cell.cellImageView.image=[UIImage imageNamed:@"Box1-Uncheck.png"];
        }
    }else{
        [self hideCellView:cell withStatus:YES];
        if (authorArray.count>0) {
            CompleteAuthorModel *model=authorArray[indexPath.row];
            cell.authorNameLabel.text=model.name;
        }
    }
    return cell;
}
-(void)hideCellView:(GermsTableViewCell*)cell withStatus:(BOOL)status{
    cell.cellImageView.hidden=status;
    cell.label.hidden=status;
    cell.labelTwo.hidden=status;
    if (status) {
        cell.authorNameLabel.hidden=NO;
    }else  cell.authorNameLabel.hidden=YES;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor=[UIColor clearColor];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_differenceStringBetweenAuthorAndGerms isEqualToString:@"germs"]) {
        germsModel *model=germsArray[indexPath.row];
        if ([selectedIndex containsObject:indexPath]) {
            [selectedIndex removeObject:indexPath];
            [selectedGerms removeObject:model];
            [_tableView reloadData];
        }
        else{
            [selectedIndex addObject:indexPath];
            [selectedGerms addObject:model];
            [_tableView reloadData];
        }
    }else{
        CompleteAuthorModel *model=authorArray[indexPath.row];
        [self.delegateForGerms passAuthorData:model];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35;
}
-(void)callSeed{
    //    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
    //        //For Vzone API
    //        [self callApiToGetGerms];
    //    }else {
    //        //For Material API
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([userDefault boolForKey:@"germs_FLAG"]) {
        [self callApiToGetGerms];
    }
    else{
        NSString *url=[NSString stringWithFormat:@"%@%@",baseUrl,germsUrl];
        [[SeedSyncer sharedSyncer]getResponseFor:url completionHandler:^(BOOL success, id response) {
            if (success) {
                [self processGerms:response];
            }
            else{
                [self callApiToGetGerms];
            }
        }];
    }
    // }
}
-(void)callApiToGetGerms{
    NSString *url=[NSString stringWithFormat:@"%@%@",baseUrl,germsUrl];
    [MBProgressHUD showHUDAddedTo:alphaView animated:YES];
    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
        NSString *parameter=[NSString stringWithFormat:@"{\"request\":}}"];
        [postman post:url withParameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [MBProgressHUD hideHUDForView:alphaView animated:NO];
            [self processGerms:responseObject];
            [[SeedSyncer sharedSyncer]saveResponse:[operation responseString] forIdentity:url];
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setBool:NO forKey:@"germs_FLAG"];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideHUDForView:alphaView animated:NO];
            NSString *str=[NSString stringWithFormat:@"%@",error];
            [self showToastMessage:str];
        }];
    }else {
        [postman get:url withParameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [MBProgressHUD hideHUDForView:alphaView animated:NO];
            [self processGerms:responseObject];
            [[SeedSyncer sharedSyncer]saveResponse:[operation responseString] forIdentity:url];
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setBool:NO forKey:@"germs_FLAG"];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideHUDForView:alphaView animated:NO];
            NSString *str=[NSString stringWithFormat:@"%@",error];
            [self showToastMessage:str];
        }];
    }
}
-(void)processGerms:(id)responseObject{
    
    NSDictionary *dict;
    
    [germsArray removeAllObjects];
    [selectedIndex removeAllObjects];
    [selectedGerms removeAllObjects];
    
    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
        //For Vzone API
        NSDictionary *responseDict1 = responseObject;
        dict  = responseDict1[@"aaData"];
    }else{
        //For Material API
        dict=responseObject;
    }
    
    for (NSDictionary *dict1 in dict[@"GenericSearchViewModels"]) {
        if ([dict1[@"Status"] intValue]==1) {
            germsModel *model=[[germsModel alloc]init];
            model.germsCode=dict1[@"Code"];
            model.germsName=dict1[@"Name"];
            model.germsId=dict1[@"Id"];
            if (dict1[@"UserfriendlyCode"]!=[NSNull null]) {
                model.germsUserFriendlycode=dict1[@"UserfriendlyCode"];
            }else model.germsUserFriendlycode=model.germsName;
            [germsArray addObject:model];
        }
    }
    [self displayTheSelectedGerms];
}
-(void)displayTheSelectedGerms{
    [_tableView reloadData];
    NSArray *ar=[_fromParentViewGermsString componentsSeparatedByString:@" "];
    for (NSString *str in ar) {
        for (int i=0; i<germsArray.count; i++) {
            germsModel *model=germsArray[i];
            if ([str isEqualToString:model.germsUserFriendlycode]) {
                [self tableView:_tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                break;
            }
        }
    }
    [self heightOfView:130];
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
-(void)callApiToAddGerm{
    NSString *url=[NSString stringWithFormat:@"%@%@/0",baseUrl,addGermsUrl];
    NSString *parameter;
    NSUserDefaults *defaultvalue=[NSUserDefaults standardUserDefaults];
    int userIdInteger=[[defaultvalue valueForKey:@"Id"]intValue];
    
    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
        //Parameter for Vzone Api
        
        parameter =[NSString stringWithFormat:@"{\"request\":{\"Name\":\"%@\",\"UserfriendlyCode\":\"%@\",\"UserID\":%d,\"Status\":true,\"MethodType\":\"POST\"}}",_codeFullNameTF.text,_codeSymbolTF.text,userIdInteger];
    }else{
        //Parameter For Material Api
        parameter =[NSString stringWithFormat:@" {\"Name\":\"%@\",\"UserfriendlyCode\":\"%@\",\"UserID\":%d,\"Status\":true,\"MethodType\":\"POST\"}",_codeFullNameTF.text,_codeSymbolTF.text,userIdInteger];
    }
    
    [MBProgressHUD showHUDAddedTo:alphaView animated:YES];
    [postman post:url withParameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideAllHUDsForView:alphaView animated:NO];
        [self processToAddGerms:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:alphaView animated:NO];
        NSString *str=[NSString stringWithFormat:@"%@",error];
        [self showToastMessage:str];
    }];
}
-(void)processToAddGerms:(id)responseObject{
    NSDictionary *dict;
    NSDictionary *dict1=responseObject;
    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
        dict =dict1[@"aaData"];
    }else dict=responseObject;
    if ([dict[@"Success"]intValue]==1) {
        [self callApiToGetGerms];
        [self changeTheNewGermAppearence:YES withHeight:0];
        [self heightOfView:130];
        
    }else{
        [self showToastMessage:dict[@"Message"]];
        //        UIAlertView *alert1=[[UIAlertView alloc]initWithTitle:alert message:dict[@"Message"] delegate:nil cancelButtonTitle:alertOK otherButtonTitles:nil,nil];
        //        [alert1 show];
    }
}
-(void)localization{
    alert=[MCLocalization stringForKey:@"Alert!"];
    alertOK=[MCLocalization stringForKey:@"AlertOK"];
     _codeFullNameTF.attributedPlaceholder=[constant textFieldPlaceHolderText:[MCLocalization stringForKey:@"Name"]];
     nameRequiredStr= [MCLocalization stringForKey:@"Name is required"];
    if ([_differenceStringBetweenAuthorAndGerms isEqualToString:@"germs"]) {
        _codeSymbolTF.attributedPlaceholder=[constant textFieldPlaceHolderText:[MCLocalization stringForKey:@"Symbol"]];
        _codesLabel.text=[MCLocalization stringForKey:@"Codes"];
        symbolRequiredStr= [MCLocalization stringForKey:@"Symbol is required"];
        bothDataRequired=[MCLocalization stringForKey:@"Symbol and Name are required"];
    }else{
        _codeSymbolTF.attributedPlaceholder=[constant textFieldPlaceHolderText:[MCLocalization stringForKey:@"Initials"]];
        _codesLabel.text=[MCLocalization stringForKey:@"Author"];
        symbolRequiredStr= [MCLocalization stringForKey:@"Initials is required"];
        bothDataRequired=[MCLocalization stringForKey:@"Initials and Name are required"];
    }
}
-(void)showToastMessage:(NSString*)msg{
    MBProgressHUD *hubHUD=[MBProgressHUD showHUDAddedTo:alphaView animated:YES];
    hubHUD.mode=MBProgressHUDModeText;
    if (msg.length>0) {
        hubHUD.detailsLabelText=msg;
    }
    hubHUD.detailsLabelFont=[UIFont systemFontOfSize:15];
    hubHUD.margin=20.f;
    hubHUD.yOffset=150.f;
    hubHUD.removeFromSuperViewOnHide = YES;
    [hubHUD hide:YES afterDelay:2];
    
}
-(void)callApiForAddAuthor{
    NSString *url=[NSString stringWithFormat:@"%@%@",baseUrl,saveAuthor];
    NSString *parameter;
    NSUserDefaults *defaultvalue=[NSUserDefaults standardUserDefaults];
    int userIdInteger=[[defaultvalue valueForKey:@"Id"]intValue];
    
    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
        //Parameter for Vzone Api
        
        parameter =[NSString stringWithFormat:@"{\"request\":{\"Id\":0,\"Name\":\"%@\",\"Initials\":\"%@\",\"Status\":true,\"UserID\":%d,\"MethodType\":\"POST\"}}",_codeFullNameTF.text,_codeSymbolTF.text,userIdInteger];
    }else{
        //Parameter For Material Api
        parameter =[NSString stringWithFormat:@"{\"request\":{\"Id\":0,\"Name\":\"%@\",\"Initials\":\"%@\",\"Status\":true,\"UserID\":%d,\"MethodType\":\"POST\"}}",_codeFullNameTF.text,_codeSymbolTF.text,userIdInteger];
    }
    
    [MBProgressHUD showHUDAddedTo:alphaView animated:YES];
    [postman post:url withParameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideAllHUDsForView:alphaView animated:NO];
        [self processAddAuthor:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:alphaView animated:NO];
        NSString *str=[NSString stringWithFormat:@"%@",error];
        [self showToastMessage:str];
    }];
}
-(void)processAddAuthor:(id)responseObject{
    NSDictionary *dict;
    NSDictionary *dict1=responseObject;
    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
        dict =dict1[@"aaData"];
    }else dict=responseObject;
    if ([dict[@"Success"]intValue]==1) {
        [self callApiToGetGerms];
        [self changeTheNewGermAppearence:YES withHeight:0];
        [self heightOfView:130];
        
    }else{
        [self showToastMessage:dict[@"Message"]];
    }
}
-(void)callSeedForAuthor{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([userDefault boolForKey:@"author_FLAG"]) {
        [self callApiToGetAuthor];
    }
    else{
        NSString *url=[NSString stringWithFormat:@"%@%@",baseUrl,getAllAuthor];
        [[SeedSyncer sharedSyncer]getResponseFor:url completionHandler:^(BOOL success, id response) {
            if (success) {
                [self processAuthor:response];
            }
            else{
                [self callApiToGetAuthor];
            }
        }];
    }
}
-(void)callApiToGetAuthor{
    [MBProgressHUD showHUDAddedTo:view animated:NO];
    NSString *url=[NSString stringWithFormat:@"%@%@",baseUrl,getAllAuthor];
    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
        NSString *parameter=[NSString stringWithFormat:@"{\"request\":}}"];
        [postman post:url withParameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self processAuthor:responseObject];
            [[SeedSyncer sharedSyncer]saveResponse:[operation responseString] forIdentity:url];
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setBool:NO forKey:@"author_FLAG"];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self callApiToGetAuthor];
            NSString *str=[NSString stringWithFormat:@"%@",error];
            [self showToastMessage:str];
        }];
    }
}
-(void)processAuthor:(id)responseObject{
    [MBProgressHUD hideAllHUDsForView:view animated:YES];
    
    NSDictionary *dict;
    [authorArray removeAllObjects];
    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
        //For Vzone API
        NSDictionary *responseDict1 = responseObject;
        dict  = responseDict1[@"aaData"];
    }else{
        //For Material API
        dict=responseObject;
    }
    for (NSDictionary *dict1 in dict[@"GenericSearchViewModels"]) {
        if ([dict1[@"Status"] intValue]==1) {
            CompleteAuthorModel *model=[[CompleteAuthorModel alloc]init];
            model.code=dict1[@"Code"];
            model.name=dict1[@"Name"];
            model.idValue=dict1[@"Id"];
            [authorArray addObject:model];
        }
    }
    [_tableView reloadData];
    [view layoutIfNeeded];
    [self heightOfView:130];
}

@end
