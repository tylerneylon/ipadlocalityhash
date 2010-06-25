//
//  DotsView.h
//
//  Created by Tyler Neylon on 6/12/10.
//
//  View object just for drawing dots on top
//  of other views.
//
//  This is useful since it doesn't need to
//  be redrawn as often, and thus speeds up
//  the drawing of moving parts in other layers.
//

#import <Foundation/Foundation.h>


@interface DotsView : UIView {
 @private
  // strong
  NSSet *points;  // Elements are BNPoint objects.
  UIColor *color;
}

@property (nonatomic, retain) NSSet *points;
@property (nonatomic, retain) UIColor *color;

@end
