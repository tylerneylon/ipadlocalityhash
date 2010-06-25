//
//  DotsView.m
//
//  Created by Tyler Neylon on 6/12/10.
//

#import "DotsView.h"

#import "BNPoint.h"

static void drawCircleAt(float center_x, float center_y, float radius) {
	CGContextRef graphics = UIGraphicsGetCurrentContext();
	CGContextBeginPath(graphics);
	CGContextAddArc(graphics, center_x, center_y, radius, 0, 2 * M_PI, 0);
	CGContextClosePath(graphics);
	CGContextFillPath(graphics);
}

@implementation DotsView

@synthesize points, color;

- (id)initWithFrame:(CGRect)frame {
  if (![super initWithFrame:frame]) return nil;
  self.opaque = NO;
  self.userInteractionEnabled = NO;
  return self;
}

- (void)dealloc {
  self.points = nil;
  self.color = nil;
  [super dealloc];
}


- (void)setPoints:(NSSet *)newPoints {
  [points autorelease];
  points = [newPoints retain];
  [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
  [color setFill];
  for (BNPoint *point in points) {
    drawCircleAt(point.x, point.y, 5);
  }
}

@end
