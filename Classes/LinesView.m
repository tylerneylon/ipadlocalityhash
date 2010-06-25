//
//  LinesView.m
//
//  Created by Tyler Neylon on 6/12/10.
//

#import "LinesView.h"

#import "BNLine.h"
#import "BNPoint.h"

@interface LinesView ()

- (void)drawLines:(NSSet *)lines withColor:(UIColor *)color;
- (void)pathLine:(BNLine *)line inContext:(CGContextRef)context;
- (void)drawLine:(BNLine *)line inContext:(CGContextRef)context;

@end

@implementation LinesView

@synthesize starMode;

- (id)initWithFrame:(CGRect)frame {
  if (![super initWithFrame:frame]) return nil;
  lineSets = [[NSMutableArray array] retain];
  colors = [[NSMutableArray array] retain];
  self.opaque = NO;
  self.userInteractionEnabled = NO;
  return self;
}

- (void)dealloc {
  [lineSets release];
  [colors release];
  [super dealloc];
}

- (void)addLines:(NSSet *)lines withColor:(UIColor *)color {
  [lineSets addObject:lines];
  [colors addObject:color];
  [self setNeedsDisplay];
}

- (void)clear {
  [lineSets removeAllObjects];
  [colors removeAllObjects];
  [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
  int n = [lineSets count];
  for (int i = 0; i < n; ++i) {
    [self drawLines:[lineSets objectAtIndex:i] withColor:[colors objectAtIndex:i]];
  }
}

#pragma mark internal methods

- (void)drawLines:(NSSet *)lines withColor:(UIColor *)color {
  CGContextRef context = UIGraphicsGetCurrentContext();
  [color setStroke];
  if (!starMode) {
    for (BNLine *line in lines) {
      [self drawLine:line inContext:context];
    }
    return;
  }
  CGContextBeginPath(context);
  BNPoint *centerPoint = [[lines anyObject] from];
  CGContextMoveToPoint(context, centerPoint.x, centerPoint.y);
  for (BNLine *line in lines) [self pathLine:line inContext:context];
  CGContextStrokePath(context);
}

- (void)pathLine:(BNLine *)line inContext:(CGContextRef)context {
	CGContextAddLineToPoint(context, line.to.x, line.to.y);
	CGContextAddLineToPoint(context, line.from.x, line.from.y);
}

- (void)drawLine:(BNLine *)line inContext:(CGContextRef)context {
	CGContextBeginPath(context);
	CGContextMoveToPoint(context, line.from.x, line.from.y);
	CGContextAddLineToPoint(context, line.to.x, line.to.y);
	CGContextClosePath(context);
  CGContextStrokePath(context);
}

@end
