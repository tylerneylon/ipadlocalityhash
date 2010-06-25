//
//  MainView.h
//
//  Created by Tyler Neylon on 6/10/10.
//
//  This view contains and coordinates
//  the dots, lines, and triangle layers.
//

#import <Foundation/Foundation.h>

@class BNPoint;
@class DotsView;
@class LinesView;
@class TriangleView;

@interface MainView : UIView {
 @private
  // strong
  NSMutableSet *points;
  NSMutableDictionary *hashmap;
  NSMutableDictionary *lines;
  
  // The most expensive part of a hash update is actually the drawing.
  // We avoid some lag (but not all) by only doing this update if things
  // are stale for at least x seconds, where x is kHashUpdateWaitTime,
  // a constant in MainView.m.
  NSDate *lastHashUpdate;
  
  // weak
  TriangleView *triangleView;
  DotsView *dotsView;
  LinesView *graphLinesView;
  DotsView *hashPointsView;
  LinesView *hashLinesView;
  LinesView *touchLinesView;
  UILabel *scaleLabel;
  
  BNPoint *touchPoint;

  BOOL hashUpdateNeeded;
  float hashScale;
  BOOL skewCorrection;
}

@property (nonatomic) BOOL showGraph;
@property (nonatomic) BOOL showHashPoints;
@property (nonatomic) float hashScale;
@property (nonatomic, assign) UILabel *scaleLabel;
@property (nonatomic) BOOL skewCorrection;

- (void)newRandomPoints:(int)numPoints;

@end
