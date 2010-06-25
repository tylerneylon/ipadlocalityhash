//
//  BNLine.m
//
//  Created by Tyler Neylon on 6/12/10.
//

#import "BNLine.h"

#import "BNPoint.h"

@implementation BNLine

@synthesize from, to;

- (void)dealloc {
  self.from = nil;
  self.to = nil;
  [super dealloc];
}

- (NSUInteger)hash {
  // tylerneylon: I have no idea if this is a good hash.
  //              Almost certainly not the best, but it is
  //              good enough for now.  (This is purely for
  //              the use as a key in dictionaries/sets,
  //              independent of the locality hashing stuff.)
  return (int)floor([from hash] + 100 * [to hash]);
}

- (BOOL)isEqual:(id)anObject {
  if (![anObject isKindOfClass:[BNLine class]]) return NO;
  BNLine *otherLine = (BNLine *)anObject;
  return [from isEqual:(otherLine->from)] && [to isEqual:(otherLine->to)];
}

- (id)copyWithZone:(NSZone *)zone {
  BNLine *lineCopy = [[BNLine allocWithZone:zone] init];
  lineCopy->from = from;
  lineCopy->to = to;
  return lineCopy;
}

- (NSString *)description {
  return [NSString stringWithFormat:@"%@ from:%@   to:%@", [self class], from, to];
}

@end
