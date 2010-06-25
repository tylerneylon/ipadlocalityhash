//
//  MainViewController.h
//
//  Created by Tyler Neylon on 6/10/10.
//
//  The primary and only view controller for
//  this locality-sensitive hashing demo app.
//  Most of the screen is handled by a MainView,
//  and the bottom is a set of controls for
//  setting parameters or choosing new random
//  data points.  The initial view hierarchy
//  is mostly set up in the MainViewController.xib.
//  

#import <UIKit/UIKit.h>

@class MainView;

@interface MainViewController : UIViewController {
 @private
  // weak
  IBOutlet UILabel *scaleLabel;
  IBOutlet UIButton *newButton;
  
  MainView *mainView;
  int numNewPoints;
}

@property (nonatomic, assign) UILabel *scaleLabel;

- (IBAction)newTapped;
- (IBAction)sliderSlid:(id)sender;
- (IBAction)skewCorrectionToggled:(id)sender;
- (IBAction)showGraphToggled:(id)sender;
- (IBAction)showHashPointsToggled:(id)sender;
- (IBAction)numPointsSliderSlid:(id)sender;

@end
