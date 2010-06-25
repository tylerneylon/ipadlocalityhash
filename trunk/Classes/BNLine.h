//
//  BNLine.h
//  (BN is Bynomial, Inc.)
//
//  Created by Tyler Neylon on 6/12/10.
//
//  Simple model object to contain a line.
//

#import <Foundation/Foundation.h>

@class BNPoint;

@interface BNLine : NSObject <NSCopying> {
 @private
  // strong
  BNPoint *from;
  BNPoint *to;  
}

@property (nonatomic, retain) BNPoint *from;
@property (nonatomic, retain) BNPoint *to;

@end
