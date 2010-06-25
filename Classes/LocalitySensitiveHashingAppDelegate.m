//
//  LocalitySensitiveHashingAppDelegate.m
//  LocalitySensitiveHashing
//
//  Created by Tyler Neylon on 6/25/10.
//

#import "LocalitySensitiveHashingAppDelegate.h"

#import "MainViewController.h"

@implementation LocalitySensitiveHashingAppDelegate

@synthesize window;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
  mainController = [MainViewController new];
  [window addSubview:mainController.view];
  [window makeKeyAndVisible];
  return YES;
}


- (void)dealloc {
  [window release];
  [mainController release];
  [super dealloc];
}


@end
