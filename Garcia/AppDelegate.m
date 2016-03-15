//
//  AppDelegate.m
//  Garcia
//
//  Created by manasap on 16/10/15.
//  Copyright (c) 2015 manasap. All rights reserved.
//

#import "AppDelegate.h"
#import <MCLocalization/MCLocalization.h>
#import "ContainerViewController.h"
#import "LanguageChanger.h"
#import "MBProgressHUD.h"
#import "SeedSyncer.h"
@interface AppDelegate ()<languageChangeForDelegat>
@end

@implementation AppDelegate
{
    LanguageChanger *langchanger;
    BOOL appIsLaunched;

}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[UINavigationBar appearance]setBarTintColor:[UIColor colorWithRed:0 green:0.71 blue:0.93 alpha:1]];
    [[UINavigationBar appearance]setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:1 green:1 blue:1 alpha:1],NSForegroundColorAttributeName,[UIFont fontWithName:@"OpenSans-Bold" size:22],NSFontAttributeName, nil]];
    appIsLaunched=YES;
   langchanger=[[LanguageChanger alloc]init];
    NSUserDefaults *userdefault=[NSUserDefaults standardUserDefaults];
    
    BOOL status=[userdefault boolForKey:@"rememberMe"];
    if (status) {
        [langchanger readingLanguageFromDocument];
        UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UINavigationController *navController = (UINavigationController *)self.window.rootViewController;
        ContainerViewController *container=[storyBoard instantiateViewControllerWithIdentifier:@"ContainerViewController"];
        [navController setViewControllers:@[container]];
    [[SeedSyncer sharedSyncer] callSeedAPI:^(BOOL success) {
            if (success) {
                [self languageChanger];
            }
            else{

            }
        }];
    }
    
    return YES;
}
-(void)languageChanger{
    [MBProgressHUD showHUDAddedTo:self.window animated:YES];
    [langchanger callApiForUILabelLanguage];
    langchanger.delegate=self;
}
-(void)languageChangeDelegate:(int)str{
     [MBProgressHUD hideHUDForView:self.window animated:YES];
    if (str!=0) {
       
    }
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {

    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    if (!appIsLaunched) {
    [[SeedSyncer sharedSyncer] callSeedAPI:^(BOOL success) {
        if (success) {
         [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:NO];
        }
        else{
            
        }
    }];
    }
    appIsLaunched=NO;
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
@end
