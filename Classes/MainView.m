//
//  MainView.m
//
//  Created by Tyler Neylon on 6/10/10.
//

#import "MainView.h"

#import "BNLine.h"
#import "BNPoint.h"
#import "Debug.h"
#import "DotsView.h"
#import "LinesView.h"
#import "TriangleView.h"
#import "UIView+position.h"

#define kHashUpdateWaitTime 0.25

static void drawCircleAt(float center_x, float center_y, float radius) {
	CGContextRef graphics = UIGraphicsGetCurrentContext();
	CGContextBeginPath(graphics);
	CGContextAddArc(graphics, center_x, center_y, radius, 0, 2 * M_PI, 0);
	CGContextClosePath(graphics);
	CGContextFillPath(graphics);
}

@interface MainView ()

@property (nonatomic, retain) BNPoint *touchPoint;

- (void)computeAllHashes;
- (void)addPoint:(BNPoint *)point atHashPoint:(BNPoint *)hashPoint;
- (void)setupLinesFromArray:(NSSet *)pointArray;

- (void)setNeedsHashUpdate;
- (void)updateHashes;

- (void)drawLine:(BNLine *)line;
- (void)drawGraphLines;
- (void)drawTouchLines;
- (void)setTouchLines;

@end


@implementation MainView

@synthesize hashScale, scaleLabel, skewCorrection;

- (id)initWithFrame:(CGRect)frame {
  if (![super initWithFrame:frame]) return nil;
  self.backgroundColor = [UIColor whiteColor];
  points = [[NSMutableSet set] retain];
  hashmap = [[NSMutableDictionary dictionary] retain];
  lines = [[NSMutableDictionary dictionary] retain];
  skewCorrection = YES;
  
  triangleView = [[[TriangleView alloc] initWithFrame:self.bounds] autorelease];
  [self addSubview:triangleView];
  
  hashLinesView = [[[LinesView alloc] initWithFrame:self.bounds] autorelease];
  [self addSubview:hashLinesView];
  hashLinesView.hidden = YES;
  
  hashPointsView = [[[DotsView alloc] initWithFrame:self.bounds] autorelease];
  hashPointsView.color = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
  [self addSubview:hashPointsView];
  hashPointsView.hidden = YES;
  
  graphLinesView = [[[LinesView alloc] initWithFrame:self.bounds] autorelease];
  [self addSubview:graphLinesView];
  
  touchLinesView = [[[LinesView alloc] initWithFrame:self.bounds] autorelease];
  touchLinesView.starMode = YES;
  [self addSubview:touchLinesView];
  
  dotsView = [[[DotsView alloc] initWithFrame:self.bounds] autorelease];
  dotsView.color = [UIColor colorWithRed:0 green:0.5 blue:0.1 alpha:1];
  [self addSubview:dotsView];
  
  return self;
}

- (void)newRandomPoints:(int)numPoints {
  [points removeAllObjects];
  for (int i = 0; i < numPoints; ++i) {
    [points addObject:[BNPoint randomPointIn:self.frameSize]];
  }
  dotsView.points = points;
  [self setNeedsHashUpdate];
}

- (void)setHashScale:(float)newScale {
  if (hashScale == newScale) return;
  hashScale = newScale;
  if (hashScale <= 0.0) hashScale = 0.1;
  [self setNeedsHashUpdate];
}

- (void)setSkewCorrection:(BOOL)newSkewCorrection {
  if (skewCorrection == newSkewCorrection) return;
  skewCorrection = newSkewCorrection;
  [self setNeedsHashUpdate];
}

- (void)setShowGraph:(BOOL)newShowGraph {
  graphLinesView.hidden = !newShowGraph;
}

- (BOOL)showGraph {
  return !graphLinesView.hidden;
}

- (void)setShowHashPoints:(BOOL)showHashPoints {
  hashLinesView.hidden = !showHashPoints;
  hashPointsView.hidden = !showHashPoints;
}

- (BOOL)showHashPoints {
  return !hashLinesView.hidden;
}


#pragma mark UIResponder methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  CGPoint cgPoint = [(UITouch *)[touches anyObject] locationInView:self];
  self.touchPoint = [BNPoint pointWithCGPoint:cgPoint];
  [self setTouchLines];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  CGPoint cgPoint = [(UITouch *)[touches anyObject] locationInView:self];
  self.touchPoint = [BNPoint pointWithCGPoint:cgPoint];
  [self setTouchLines];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  self.touchPoint = nil;
  triangleView.trianglePoints = nil;
  [touchLinesView clear];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
  [self touchesEnded:touches withEvent:event];
}

#pragma mark internal methods

@synthesize touchPoint;

- (void)computeAllHashes {
  static NSMutableArray *colors = nil;
  if (colors == nil) {
    colors = [[NSMutableArray array] retain];
    [colors addObject:[UIColor colorWithRed:0.7 green:0.8 blue:0.7 alpha:1.0]];
    [colors addObject:[UIColor colorWithRed:0.45 green:0.6 blue:0.45 alpha:1.0]];
    [colors addObject:[UIColor colorWithRed:0.05 green:0.08 blue:0.05 alpha:1.0]];    
  }  
  
  [hashmap removeAllObjects];
  [lines removeAllObjects];
  
  for (BNPoint *point in points) {
    NSArray *hashes = [point hashesAtScale:hashScale skewCorrection:skewCorrection];
    for (BNPoint *hashPoint in hashes) {
      [self addPoint:point atHashPoint:hashPoint];
    }
  }
  for (id key in hashmap) {
    [self setupLinesFromArray:[hashmap objectForKey:key]];
  }
  
  // Put the graph lines in graphLinesView.
  NSArray *linesPerWeight = [NSArray arrayWithObjects:[NSMutableSet set],
                             [NSMutableSet set], [NSMutableSet set], nil];
  for (BNLine *line in lines) {
    int weight = [[lines objectForKey:line] intValue] - 1;
    [[linesPerWeight objectAtIndex:weight] addObject:line];
  }
  [graphLinesView clear];
  for (int weight = 0; weight < 3; ++weight) {
    [graphLinesView addLines:[linesPerWeight objectAtIndex:weight]
                   withColor:[colors objectAtIndex:weight]];
  }
  
  // Put the hash lines in hashLinesView.
  [hashLinesView clear];
  UIColor *hashLineColor = [UIColor colorWithRed:1 green:0.4 blue:0.4 alpha:1];
  NSMutableSet *allHashPoints = [NSMutableSet set];
  for (BNPoint *hashPoint in hashmap) {
    BNPoint *realFromHashPoint = [hashPoint realPointFromHashPointAtScale:hashScale skewCorrection:skewCorrection];
    [allHashPoints addObject:realFromHashPoint];
    NSSet *pointSet = [hashmap objectForKey:hashPoint];
    NSMutableSet *lineSet = [NSMutableSet set];
    for (BNPoint *point in pointSet) {
      BNLine *line = [[[BNLine alloc] init] autorelease];
      line.from = realFromHashPoint;
      line.to = point;
      [lineSet addObject:line];
    }
    [hashLinesView addLines:lineSet withColor:hashLineColor];
  }
  hashPointsView.points = allHashPoints;
}

- (void)addPoint:(BNPoint *)point atHashPoint:(BNPoint *)hashPoint {
  NSMutableArray *pointArray = [hashmap objectForKey:hashPoint];
  if (pointArray) {
    [pointArray addObject:point];
  } else {
    [hashmap setObject:[NSMutableSet setWithObject:point] forKey:hashPoint];
  }
}

- (void)setupLinesFromArray:(NSSet *)pointArray {
  for (BNPoint *from in pointArray) {
    for (BNPoint *to in pointArray) {
      if (from >= to) continue;
      BNLine *line = [[BNLine alloc] init];
      line.from = from;
      line.to = to;
      NSNumber *numSoFar = [lines objectForKey:line];
      int newNum = [numSoFar intValue] + 1;
      [lines setObject:[NSNumber numberWithInt:newNum] forKey:line];
    }
  }
}

- (void)setNeedsHashUpdate {
  if (lastHashUpdate == nil) {
    [self updateHashes];
    return;
  }
  NSTimeInterval timeSinceLastUpdate = [[NSDate date] timeIntervalSinceDate:lastHashUpdate];
  if (timeSinceLastUpdate > kHashUpdateWaitTime) {
    [self updateHashes];
    return;
  }
  if (hashUpdateNeeded) return;
  hashUpdateNeeded = YES;
  [self performSelector:@selector(setNeedsHashUpdate) withObject:nil afterDelay:(kHashUpdateWaitTime - timeSinceLastUpdate + 0.01)];
}

- (void)updateHashes {
  [self computeAllHashes];
  [self setNeedsDisplay];
  lastHashUpdate = [[NSDate date] retain];
  hashUpdateNeeded = NO;
  scaleLabel.text = [NSString stringWithFormat:@"Scale: %.2f", hashScale];
}

- (void)drawLine:(BNLine *)line {
  CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextBeginPath(context);
	CGContextMoveToPoint(context, line.from.x, line.from.y);
	CGContextAddLineToPoint(context, line.to.x, line.to.y);
	CGContextClosePath(context);
  CGContextStrokePath(context);
}

- (void)drawGraphLines {
  static NSMutableArray *colors = nil;
  if (colors == nil) {
    colors = [[NSMutableArray array] retain];
    [colors addObject:[UIColor colorWithRed:0.7 green:0.8 blue:0.7 alpha:1.0]];     // lowest weight color
    [colors addObject:[UIColor colorWithRed:0.45 green:0.6 blue:0.45 alpha:1.0]];
    [colors addObject:[UIColor colorWithRed:0.05 green:0.08 blue:0.05 alpha:1.0]];  // highest weight color
  }
  for (BNLine *line in lines) {
    int weight = [[lines objectForKey:line] intValue];
    // Uncomment the next line to make heavier connections visually thicker.
    //CGContextSetLineWidth(UIGraphicsGetCurrentContext(), weight);
    [[colors objectAtIndex:(weight - 1)] setStroke];
    [self drawLine:line];
  }
}

- (void)pathLine:(BNLine *)line inContext:(CGContextRef)context {
	CGContextAddLineToPoint(context, line.to.x, line.to.y);
	CGContextAddLineToPoint(context, line.from.x, line.from.y);
}

- (void)drawTouchLines {
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextBeginPath(context);
  [[UIColor blueColor] setStroke];
  NSArray *hashPoints = [touchPoint hashesAtScale:hashScale skewCorrection:skewCorrection];
  
  // Set up the triangle for drawing.
  NSMutableArray *realPointsFromHashPoints = [NSMutableArray array];
  for (BNPoint *hashPoint in hashPoints) {
    [realPointsFromHashPoints addObject:[hashPoint realPointFromHashPointAtScale:hashScale skewCorrection:skewCorrection]];
  }
  triangleView.trianglePoints = realPointsFromHashPoints;
  
  BNLine *line = [[[BNLine alloc] init] autorelease];
  line.from = touchPoint;
  CGContextMoveToPoint(context, touchPoint.x, touchPoint.y);
  NSMutableSet *allNbors = [NSMutableSet set];
  for (BNPoint *hashPoint in hashPoints) {
    NSSet *nbors = [hashmap objectForKey:hashPoint];
    [allNbors unionSet:nbors];
  }  
  for (BNPoint *nbor in allNbors) {
    line.to = nbor;
    [self pathLine:line inContext:context];
  }
  CGContextStrokePath(context);
}

- (void)setTouchLines {
  NSArray *hashPoints = [touchPoint hashesAtScale:hashScale skewCorrection:skewCorrection];

  // Set up the triangle for drawing.
  NSMutableArray *realPointsFromHashPoints = [NSMutableArray array];
  for (BNPoint *hashPoint in hashPoints) {
    [realPointsFromHashPoints addObject:[hashPoint realPointFromHashPointAtScale:hashScale skewCorrection:skewCorrection]];
  }
  triangleView.trianglePoints = realPointsFromHashPoints;
  
  NSMutableSet *allNbors = [NSMutableSet set];
  for (BNPoint *hashPoint in hashPoints) {
    NSSet *nbors = [hashmap objectForKey:hashPoint];
    [allNbors unionSet:nbors];
  }
  NSMutableSet *lineSet = [NSMutableSet set];
  for (BNPoint *nbor in allNbors) {
    BNLine *line = [[[BNLine alloc] init] autorelease];
    line.from = touchPoint;
    line.to = nbor;
    [lineSet addObject:line];
  }
  [touchLinesView clear];
  [touchLinesView addLines:lineSet withColor:[UIColor blueColor]];
}

@end
