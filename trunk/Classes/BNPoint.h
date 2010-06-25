//
//  BNPoint.h
//  (BN is Bynomial, Inc.)
//
//  Created by Tyler Neylon on 6/10/10.
//
//  A simple point representation that is both
//  a class (unlike CGPoint) and can handle
//  some LSH-friendly operations.
//

#import <Foundation/Foundation.h>


@interface BNPoint : NSObject <NSCopying> {
  CGFloat x;
  CGFloat y;
}

@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat y;

+ (BNPoint *)randomPointIn:(CGSize)size;
+ (BNPoint *)pointWithCGPoint:(CGPoint)cgPoint;

- (id)initWithX:(float)x y:(float)y;
- (NSArray *)hashesAtScale:(float)scale skewCorrection:(BOOL)skewCorrection;

- (BNPoint *)hashablePointFromRealPointAtScale:(float)scale skewCorrection:(BOOL)skewCorrection;
- (BNPoint *)realPointFromHashPointAtScale:(float)scale skewCorrection:(BOOL)skewCorrection;

@end
