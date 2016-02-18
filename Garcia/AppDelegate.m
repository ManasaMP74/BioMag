//
//  AppDelegate.m
//  Garcia
//
//  Created by manasap on 16/10/15.
//  Copyright (c) 2015 manasap. All rights reserved.
//

#import "AppDelegate.h"
#import <MCLocalization/MCLocalization.h>
#import "LanguageChanger.h"
#import "ContainerViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[UINavigationBar appearance]setBarTintColor:[UIColor colorWithRed:0 green:0.71 blue:0.93 alpha:1]];
    [[UINavigationBar appearance]setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:1 green:1 blue:1 alpha:1],NSForegroundColorAttributeName,[UIFont fontWithName:@"OpenSans" size:20],NSFontAttributeName, nil]];

    
// Localization

    LanguageChanger *lang=[[LanguageChanger alloc]init];
    NSUserDefaults *userdefault=[NSUserDefaults standardUserDefaults];
    NSString *str=[userdefault valueForKey:@"languageCode"];
    if (str==nil) {
      [userdefault setValue:@"en" forKey:@"languageCode"];
    }
    [lang callApiForLanguage];
//    NSString *userName=[userdefault valueForKey:@"userName"];
//    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    if (![userName isEqualToString:@""]) {
//        UINavigationController *navController = (UINavigationController *)self.window.rootViewController;
//        
//        ContainerViewController *container=[storyBoard instantiateViewControllerWithIdentifier:@"ContainerViewController"];
//        [navController setViewControllers:@[container]];
////        UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:container];
////        [self.window setRootViewController:nav];
//    }
    
    return YES;
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
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
@end
