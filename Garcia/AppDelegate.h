//
//  AppDelegate.h
//  Garcia
//
//  Created by manasap on 16/10/15.
//  Copyright (c) 2015 manasap. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "searchPatientModel.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//pass Data to reveal Vc
@property(strong,nonatomic)NSDictionary *treatmentDict;
@property(strong,nonatomic)searchPatientModel *model;
@end

