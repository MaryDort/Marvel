//
//  AppDelegate.m
//  Marvel
//
//  Created by Mariia Cherniuk on 24.05.16.
//  Copyright © 2016 marydort. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "MADCoreDataStack.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    NSManagedObjectContext *context = [[MADCoreDataStack sharedCoreData] managedObjectContext];
    NSError *error;
    
    if (![context save:&error]) {
        NSLog(@"%@", [error description]);
    }
}

@end
