//
//  MADAnimator.h
//  Marvel
//
//  Created by Mariia Cherniuk on 30.05.16.
//  Copyright © 2016 marydort. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MADAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@property (assign, nonatomic, readwrite) BOOL presenting;

@end
