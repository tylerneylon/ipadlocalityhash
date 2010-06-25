//
//  MainViewController.m
//
//  Created by Tyler Neylon on 6/10/10.
//

#import "MainViewController.h"

#import "MainView.h"
#import "UIView+position.h"

// We need this to work with properties of mainView's CALayer.
#import <QuartzCore/QuartzCore.h>

#define kScaleScale 100
#define kMaxNumPoints 200

@implementation MainViewController

@synthesize scaleLabel;

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.frame = CGRectMake(0, 20, 768, 1004);
  
  CGRect mainFrame = CGRectMake(10, 10, self.view.frameWidth - 20, 838);
  mainView = [[[MainView alloc] initWithFrame:mainFrame] autorelease];
  mainView.scaleLabel = scaleLabel;
  mainView.hashScale = 0.5 * kScaleScale;
  mainView.layer.borderColor = [UIColor grayColor].CGColor;
  mainView.layer.borderWidth = 1.0;
  [self.view addSubview:mainView];
  
  numNewPoints = kMaxNumPoints * 0.5;
  [newButton setTitle:[NSString stringWithFormat:@"%d new points", numNewPoints] forState:UIControlStateNormal];
  
  [mainView newRandomPoints:numNewPoints];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return NO;
}

- (void)dealloc {
  [super dealloc];
}

- (IBAction)newTapped {
  [mainView newRandomPoints:numNewPoints];
}

- (IBAction)sliderSlid:(id)sender {
  UISlider *slider = (UISlider *)sender;
  mainView.hashScale = slider.value * kScaleScale;
}

- (IBAction)skewCorrectionToggled:(id)sender {
  mainView.skewCorrection = ((UISwitch *)sender).on;
}

- (IBAction)showGraphToggled:(id)sender {
  mainView.showGraph = ((UISwitch *)sender).on;
}

- (IBAction)showHashPointsToggled:(id)sender {
  mainView.showHashPoints = ((UISwitch *)sender).on;
}

- (IBAction)numPointsSliderSlid:(id)sender {
  numNewPoints = ((UISlider *)sender).value * kMaxNumPoints;
  if (numNewPoints < 2) numNewPoints = 2;
  [newButton setTitle:[NSString stringWithFormat:@"%d new points", numNewPoints] forState:UIControlStateNormal];
}

@end
