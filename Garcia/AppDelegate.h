//
//  AppDelegate.h
//  Garcia
//
//  Created by manasap on 16/10/15.
//  Copyright (c) 2015 manasap. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "searchPatientModel.h"
#import "PatientDetailModel.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//pass Data to reveal Vc
@property(strong,nonatomic)NSDictionary *treatmentDict;
@property(strong,nonatomic)NSString *treatmentId;
@property(strong,nonatomic)searchPatientModel *model;
@property(strong,nonatomic)NSString *isTreatmntCompleted;
@property(strong,nonatomic)NSString *sittingString;
@property(strong,nonatomic)NSMutableArray *completeDetailToDrArray,*allsectionNameArray,*symptomTagArray;
@property(strong,nonatomic)NSDictionary *bioSittingDict;
@property(strong,nonatomic)NSString *sittingNumber;
@property(strong,nonatomic)NSArray *biomagneticAnotomicalPointArray;
@end