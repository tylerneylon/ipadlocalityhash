//
//  TriangleView.m
//
//  Created by Tyler Neylon on 6/12/10.
//

#import "TriangleView.h"

#import "BNPoint.h"

@implementation TriangleView

@synthesize trianglePoints;

- (id)initWithFrame:(CGRect)frame {
  if (![super initWithFrame:frame]) return nil;
  self.opaque = NO;
  self.userInteractionEnabled = NO;
  return self;
}

- (void)dealloc {
  self.trianglePoints = nil;
  [super dealloc];
}

- (void)setTrianglePoints:(NSArray *)points {
  [trianglePoints autorelease];
  trianglePoints = [points retain];
  [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
  if (trianglePoints == nil) return;
  [[UIColor colorWithRed:1 green:1 blue:0.6 alpha:1] setFill];
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextBeginPath(context);
  BNPoint *last = [trianglePoints lastObject];
  CGContextMoveToPoint(context, last.x, last.y);
  for (BNPoint *point in trianglePoints) {
    CGContextAddLineToPoint(context, point.x, point.y);
  }
  CGContextFillPath(context);
}


@end
