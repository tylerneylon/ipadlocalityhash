//
//  BNPoint.m
//
//  Created by Tyler Neylon on 6/10/10.
//

#import "BNPoint.h"

// The purpose of this factor is to keep the approximate
// radius of both forms of hashes close to each other.
#define kSkewFactor 0.8

@implementation BNPoint

@synthesize x, y;

+ (BNPoint *)randomPointIn:(CGSize)size {
  BNPoint *point = [[[BNPoint alloc] init] autorelease];
  point.x = (float)rand() / RAND_MAX * size.width;
  point.y = (float)rand() / RAND_MAX * size.height;
  return point;
}

+ (BNPoint *)pointWithCGPoint:(CGPoint)cgPoint {
  return [[[BNPoint alloc] initWithX:cgPoint.x y:cgPoint.y] autorelease];
}

- (id)initWithX:(float)x_ y:(float)y_ {
  if (![super init]) return nil;
  x = x_;
  y = y_;
  return self;
}

- (NSArray *)hashesAtScale:(float)scale skewCorrection:(BOOL)skewCorrection {
  BNPoint *hPoint = [self hashablePointFromRealPointAtScale:scale skewCorrection:skewCorrection];  
  BNPoint *corner = [[[BNPoint alloc]
                      initWithX:floor(hPoint.x) y:floor(hPoint.y)]
                     autorelease];
  NSMutableArray *hashes = [NSMutableArray arrayWithObject:[corner copy]];
  float xFrac = hPoint.x - floor(hPoint.x);
  float yFrac = hPoint.y - floor(hPoint.y);
  if (xFrac > yFrac) {
    corner.x++;
    [hashes addObject:[corner copy]];
    corner.y++;
    [hashes addObject:[corner copy]];
  } else {
    corner.y++;
    [hashes addObject:[corner copy]];
    corner.x++;
    [hashes addObject:[corner copy]];
  }
  return hashes;
}

- (NSUInteger)hash {
  return (int)floor(x + 100 * y);
}

- (BOOL)isEqual:(id)anObject {
  if (![anObject isKindOfClass:[BNPoint class]]) return NO;
  BNPoint *otherPoint = (BNPoint *)anObject;
  return x == otherPoint.x && y == otherPoint.y;
}

- (NSString *)description {
  return [NSString stringWithFormat:@"%@(%p) (%.1f, %.1f)", [self class], self, x, y];
}

- (BNPoint *)hashablePointFromRealPointAtScale:(float)scale skewCorrection:(BOOL)skewCorrection {
  BNPoint *point = [[[BNPoint alloc] init] autorelease];
  point.x = x / scale;
  point.y = y / scale;
  if (skewCorrection) {
    float sum = point.x + point.y;
    const float mu = (1 - 1 / sqrt(3)) / 2.0;
    point.x = (point.x / sqrt(3) + mu * sum) / kSkewFactor;
    point.y = (point.y / sqrt(3) + mu * sum) / kSkewFactor;
  }
  return point;
}

- (BNPoint *)realPointFromHashPointAtScale:(float)scale skewCorrection:(BOOL)skewCorrection {
  BNPoint *point = [[[BNPoint alloc] init] autorelease];
  point.x = x * scale;
  point.y = y * scale;
  if (skewCorrection) {
    float sum = point.x + point.y;
    const float mu = (1 - 1 / sqrt(3)) / 2.0;
    point.x = sqrt(3) * (point.x - mu * sum) * kSkewFactor;
    point.y = sqrt(3) * (point.y - mu * sum) * kSkewFactor;
  }
  return point;
}

#pragma mark NSCopying methods

- (id)copyWithZone:(NSZone *)zone {
  BNPoint *pointCopy = [[BNPoint allocWithZone:zone] init];
  pointCopy.x = x;
  pointCopy.y = y;
  return pointCopy;
}

@end
