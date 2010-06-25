//
//  LocalitySensitiveHashingAppDelegate.h
//  LocalitySensitiveHashing
//
//  Created by Tyler Neylon on 6/25/10.
//

#import <UIKit/UIKit.h>

@class MainViewController;

@interface LocalitySensitiveHashingAppDelegate : NSObject <UIApplicationDelegate> {
 @private
  // strong
  UIWindow *window;
  MainViewController *mainController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

