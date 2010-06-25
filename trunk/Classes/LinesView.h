//
//  LinesView.h
//
//  Created by Tyler Neylon on 6/12/10.
//
//  View object just for drawing lines on top
//  of other views, such as TriangleView.
//
//  This is useful since it doesn't need to
//  be redrawn as often, and thus speeds up
//  the drawing of moving parts in other layers.
//

#import <Foundation/Foundation.h>


@interface LinesView : UIView {
 @private
  // strong
  NSMutableArray *lineSets;
  NSMutableArray *colors;
  
  // The purpose of starMode is to draw a line set more quickly when
  // they all have the same from point (the center of the star).
  // It might be slightly faster, but I'm not sure it's worth it.
  BOOL starMode;
}

@property (nonatomic) BOOL starMode;

- (void)addLines:(NSSet *)lines withColor:(UIColor *)color;
- (void)clear;

@end
