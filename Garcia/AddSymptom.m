#import "AddSymptom.h"
#import "AppDelegate.h"
#import "Constant.h"
#import "SymptomTagModel.h"
#import "MBProgressHUD.h"
#import "Postman.h"
#import "PostmanConstant.h"
#import "SeedSyncer.h"
#import <MCLocalization/MCLocalization.h>
#import<AFNetworking/AFNetworking.h>

@implementation AddSymptom
{
    UIView *view;
    UIControl  *alphaView;
    NSMutableArray *symptomTagArray,*allTagListArray,*filterdTagListArray;
    Constant *constant;
    Postman *postman;
    AppDelegate *appDel;
}
-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    view=[[[NSBundle mainBundle]loadNibNamed:@"AddSymptom" owner:self options:nil]lastObject];
    [self initializeView];
    [self addSubview:view];
    view.frame=self.bounds;
    constant=[[Constant alloc]init];
    postman=[[Postman alloc]init];
    filterdTagListArray=[[NSMutableArray alloc]init];
    symptomTagArray=[[NSMutableArray alloc]init];
    [self callSeed];
    return self;
}
-(void)initializeView
{
    view.layer.cornerRadius = 10;
    view.layer.masksToBounds  = YES;
    _symptomTf.layer.borderWidth=1;
    _symptomTf.layer.borderColor=[UIColor blackColor].CGColor;
    _symptomTf.layer.cornerRadius=5;
}
-(void)alphaViewInitialize{
    if (alphaView == nil)
    {
        alphaView = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
        alphaView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
        [alphaView addSubview:view];
    }
    _symptomsLabel.text=[MCLocalization stringForKey:@"Symptoms"];
    [_addButton setTitle:[MCLocalization stringForKey:@"Add"] forState:normal];
    _collectionViewHeight.constant=0;
    _collectionView.hidden=YES;
    _symptomTf.text=@"";
    appDel = [UIApplication sharedApplication].delegate;
    [self heightOfView:132];
    _allTaglistTableView.hidden=YES;
    _allTagListTableViewHeight.constant=0;
    [self.collectionView registerNib:[UINib nibWithNibName:@"SymptomTagCustomeCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    [constant SetBorderForTextField:_symptomTf];
    [_symptomTf addTarget:self action:@selector(tagTextFieldChange) forControlEvents:UIControlEventEditingChanged];
    _symptomTf.attributedPlaceholder=[constant textFieldPlaceHolderText:[MCLocalization stringForKey:@"Enter Symptom Tag"]];
    [constant spaceAtTheBeginigOfTextField:_symptomTf];
    [alphaView addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [appDel.window addSubview:alphaView];
    [symptomTagArray removeAllObjects];
    if (appDel.symptomTagArray.count>0) {
        [symptomTagArray addObjectsFromArray:appDel.symptomTagArray];
        if (symptomTagArray.count>0) {
            [self heightOfView:182];
        }else  [self heightOfView:132];
        _collectionViewHeight.constant=37;
        _collectionView.hidden=NO;
        [_collectionView reloadData];
    }
}
-(void)hide{
    [alphaView removeFromSuperview];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return symptomTagArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SymptomTagCustomCollectionViewCell *cell =(SymptomTagCustomCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    SymptomTagModel *m=symptomTagArray[indexPath.row];
    cell.label.text=m.tagName;
    cell.delegate=self;
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    SymptomTagModel *m=symptomTagArray[indexPath.row];
    CGFloat width =  [m.tagName boundingRectWithSize:(CGSizeMake(NSIntegerMax, 40)) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont fontWithName:@"OpenSans" size:12]} context:nil].size.width;
    return CGSizeMake(width+30,40);
}
-(void)deleteCell:(UICollectionViewCell *)cell{
    SymptomTagCustomCollectionViewCell *cell1=(SymptomTagCustomCollectionViewCell*)cell;
    NSIndexPath *indexPath=[_collectionView indexPathForCell:cell1];
    [symptomTagArray removeObjectAtIndex:indexPath.row];
    if (symptomTagArray.count>0) {
        [self heightOfView:182];
    }else  [self heightOfView:132];
    [self.delegate addsymptom:symptomTagArray];
    [_collectionView reloadData];
}
- (IBAction)localAdd:(id)sender {
    if (![_symptomTf.text isEqual:@""]) {
        NSString *str=[self checkThatAddedSymptomTagIsthereOrNot];
        if (str.length==0) {
             [self callAPIforAddSymptomTag];
        }
    }
}
//tag textfield change
-(void)tagTextFieldChange{
    
    [filterdTagListArray removeAllObjects];
    
    if (allTagListArray.count>0) {
        
        NSMutableArray *ar=[[NSMutableArray alloc]init];
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"self CONTAINS[cd]%@",_symptomTf.text];
        for (SymptomTagModel *model in allTagListArray) {
            [ar addObject:model.tagName];
        }
        NSArray *array= [ar filteredArrayUsingPredicate:predicate];
        for (NSString *str in array) {
            for (SymptomTagModel *model in allTagListArray) {
                if ([model.tagName isEqualToString:str]) {
                    [filterdTagListArray addObject:model];
                }
            }
        }
        if (filterdTagListArray.count>0) {
            _allTaglistTableView.hidden=NO;
            _allTaglistTableView.layer.cornerRadius=5;
            _allTaglistTableView.layer.borderWidth=1;
            _allTaglistTableView.layer.borderColor=[UIColor lightGrayColor].CGColor;
            _allTagListTableViewHeight.constant=10;
            [_allTaglistTableView reloadData];
            if (_allTaglistTableView.contentSize.height>self.heightOfView-270) {
                _allTagListTableViewHeight.constant=self.heightOfView-270;
            }else _allTagListTableViewHeight.constant=_allTaglistTableView.contentSize.height;
            if (symptomTagArray.count>0) {
                [self heightOfView:182+_allTagListTableViewHeight.constant];
            }else  [self heightOfView:132+_allTagListTableViewHeight.constant];
        }
        else{
            _allTaglistTableView.hidden=YES;
            _allTagListTableViewHeight.constant=0;
            if (symptomTagArray.count>0) {
                [self heightOfView:182];
            }else  [self heightOfView:132];
        }
    }
}
//call seed
-(void)callSeed{
    //    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
    //
    //            //For Vzone Api
    //        [self callApiTogetSymptomTag];
    //    }
    //      else{
    //        //for Material API
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([userDefault boolForKey:@"symptomtag_FLAG"]) {
        [self callApiTogetSymptomTag];
    }
    else{
        NSString *url=[NSString stringWithFormat:@"%@%@",baseUrl,getSymptomTag];
        [[SeedSyncer sharedSyncer]getResponseFor:url completionHandler:^(BOOL success, id response) {
            if (success) {
                [self processResponseObjectOfGetAllTag:response];
            }
            else{
                [self callApiTogetSymptomTag];
            }
        }];
    }
    //  }
}
//get symptom tag
-(void)callApiTogetSymptomTag{
    NSString *url=[NSString stringWithFormat:@"%@%@",baseUrl,getSymptomTag];
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
        NSString *parameter=[NSString stringWithFormat:@"{\"request\":{}}"];
        [postman post:url withParameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self processResponseObjectOfGetAllTag:responseObject];
            [[SeedSyncer sharedSyncer]saveResponse:[operation responseString] forIdentity:url];
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setBool:NO forKey:@"symptomtag_FLAG"];
            [MBProgressHUD hideHUDForView:self animated:YES];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideHUDForView:self animated:YES];
        }];
    }else{
        [postman get:url withParameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self processResponseObjectOfGetAllTag:responseObject];
            [[SeedSyncer sharedSyncer]saveResponse:[operation responseString] forIdentity:url];
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setBool:NO forKey:@"symptomtag_FLAG"];
            [MBProgressHUD hideHUDForView:self animated:YES];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideHUDForView:self animated:YES];
        }];
    }
}
//process get tag
-(void)processResponseObjectOfGetAllTag:(id)responseObject{
    allTagListArray=[[NSMutableArray alloc]init];
    NSDictionary *dict;
    
    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
        //For Vzone API
        NSDictionary *responseDict1 = responseObject;
        dict  = responseDict1[@"aaData"];
    }else{
        //For Material API
        dict=responseObject;
    }
    
    for (NSDictionary *dict1 in dict[@"GenericSearchViewModels"]) {
        if ([dict1[@"Status"]intValue]==1) {
            SymptomTagModel *model=[[SymptomTagModel alloc]init];
            model.tagId=dict1[@"Id"];
            model.tagCode=dict1[@"Code"];
            model.tagName=dict1[@"Name"];
            [allTagListArray addObject:model];
        }
    }
    if (_symptomTf.text.length!=0) {
        [self checkThatAddedSymptomTagIsthereOrNot];
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return filterdTagListArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    SymptomTagModel *model=filterdTagListArray[indexPath.row];
    cell.textLabel.text=model.tagName;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SymptomTagModel *model=filterdTagListArray[indexPath.row];
    _symptomTf.text=model.tagName;
    _allTaglistTableView.hidden=YES;
    _allTagListTableViewHeight.constant=0;
    if (symptomTagArray.count>0) {
        [self heightOfView:182];
    }else  [self heightOfView:132];
}
-(void)heightOfView:(CGFloat)height{
    CGRect frame=self.frame;
    frame.size.height=height;
    self.frame=frame;
    view.frame=self.bounds;
    view.center = appDel.window.center;
}
-(NSString*)checkThatAddedSymptomTagIsthereOrNot{
    _collectionViewHeight.constant=37;
    _collectionView.hidden=NO;
    _allTaglistTableView.hidden=YES;
    NSString *str=@"";
    SymptomTagModel *model;
    for (SymptomTagModel *model1 in allTagListArray) {
        if ([model1.tagName isEqualToString:_symptomTf.text]) {
            str=@"done";
            model=model1;
        }
    }
    if ([str isEqualToString:@"done"]) {
        if (symptomTagArray.count>0) {
            NSMutableArray *ar=[[NSMutableArray alloc]init];
            for (SymptomTagModel *m in symptomTagArray) {
                [ar addObject:m.tagCode];
            }
            if (![ar containsObject:model.tagCode]) {
                [symptomTagArray addObject:model];
                [_collectionView reloadData];
                [self heightOfView:182];
                _symptomTf.text=@"";
                [self.delegate addsymptom:symptomTagArray];
            }else{
                str=@"alert";
                //                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert!" message:@"Symptom already exist" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                //                [alert show];
                [self showToastMessage:@"Symptom already exist"];
            }
        }
        else {
            [symptomTagArray addObject:model];
            [_collectionView reloadData];
            [self heightOfView:182];
            _symptomTf.text=@"";
            [self.delegate addsymptom:symptomTagArray];
        }
    }
    return str;
}
//Call api to add symptom tag
-(void)callAPIforAddSymptomTag{
        NSString *url=[NSString stringWithFormat:@"%@%@%@",baseUrl,addSymptomTag,_searchModel.Id];
        NSString *parameter;
        NSUserDefaults *standardDefault=[NSUserDefaults standardUserDefaults];
        NSString *languageCode= [standardDefault valueForKey:@"languageCode"];
        if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
            parameter =[NSString stringWithFormat:@"{\"request\":{\"Name\":\"%@\",\"Status\": true,\"UserID\": %@,\"MethodType\": \"POST\",\"LanguageCode\": \"%@\"}}",_symptomTf.text,_searchModel.Id,languageCode];
        }
        else{
            parameter =[NSString stringWithFormat:@"{\"Name\":\"%@\",\"Status\": true,\"UserID\": %@,\"MethodType\": \"POST\"}",_symptomTf.text,_searchModel.Id];
        }
        [MBProgressHUD showHUDAddedTo:alphaView animated:YES];
        
        [postman post:url withParameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [MBProgressHUD hideAllHUDsForView:alphaView animated:NO];
            [self processResponseObjectOfAddTag:responseObject];
            [self callApiTogetSymptomTag];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert!" message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alert show];
              [MBProgressHUD hideAllHUDsForView:alphaView animated:NO];
            NSString *str=[NSString stringWithFormat:@"%@",error];
            [self showToastMessage:str];
        }];
}
//process object
-(void)processResponseObjectOfAddTag:(id)responseObject{
    
    NSDictionary *dict;
    
    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
        //For Vzone API
        NSDictionary *responseDict1 = responseObject;
        dict  = responseDict1[@"aaData"];
    }else{
        //For Material API
        dict=responseObject;
    }
    
    if ([dict[@"Success"] intValue]==1) {
//        NSDictionary *dict1=dict[@"ViewModel"];
//        if (dict[@"ViewModel"]!=[NSNull null]) {
//        if ([dict1[@"Status"] intValue]==1) {
//            SymptomTagModel *model=[[SymptomTagModel alloc]init];
//            model.tagCode=dict1[@"Code"];
//            model.tagId=dict1[@"Id"];
//            model.tagName=dict1[@"Name"];
//            [symptomTagArray addObject:model];
//        }
//        [self.delegate addsymptom:symptomTagArray];
//        [_collectionView reloadData];
//        [self heightOfView:182];
//        _symptomTf.text=@"";
   // }
        [self callApiTogetSymptomTag];
    }
    else{
        [self showToastMessage:dict[@"Message"]];
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
@end
