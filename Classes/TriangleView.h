//
//  TriangleView.h
//
//  Created by Tyler Neylon on 6/12/10.
//
//  View to show a triangle, in combination with
//  other views like DotsView and LinesView.
//

#import <Foundation/Foundation.h>


@interface TriangleView : UIView {
 @private
  // strong
  NSArray *trianglePoints;
}

@property (nonatomic, retain) NSArray *trianglePoints;

@end
