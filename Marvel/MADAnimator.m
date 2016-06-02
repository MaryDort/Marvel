//
//  MADAnimator.m
//  Marvel
//
//  Created by Mariia Cherniuk on 30.05.16.
//  Copyright © 2016 marydort. All rights reserved.
//

#import "MADAnimator.h"

@implementation MADAnimator

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.2f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    if (_presenting) {
        [self presentAnimateTransition:transitionContext];
    } else {
        [self dismissAnimateTransition:transitionContext];
    }
}

- (void)presentAnimateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    CGRect frame = [transitionContext finalFrameForViewController:toViewController];
    UIView *containerView = [transitionContext containerView];
    UIView *blur = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    blur.translatesAutoresizingMaskIntoConstraints = NO;
    
    toViewController.view.frame = frame;
    toViewController.view.alpha = 0.f;
    
    [containerView addSubview:blur];
    [containerView addSubview:toViewController.view];
    [self cteateConstraintToView:blur byView:containerView];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                     animations:^{
                         toViewController.view.alpha = 1.f;
                     } completion:^(BOOL finished) {
                         [transitionContext completeTransition:YES];
                     }];
}

- (void)dismissAnimateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                     animations:^{
                         fromViewController.view.alpha = 0.f;
                     } completion:^(BOOL finished) {
                         [transitionContext completeTransition:YES];
                     }];
}

- (void)cteateConstraintToView:(UIView *)toView byView:(UIView *)byView {
    [byView addConstraint:[NSLayoutConstraint constraintWithItem:toView
                                                       attribute:NSLayoutAttributeTop
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:byView
                                                       attribute:NSLayoutAttributeTop
                                                      multiplier:1.f
                                                        constant:0.f]];
    
    [byView addConstraint:[NSLayoutConstraint constraintWithItem:toView
                                                       attribute:NSLayoutAttributeBottom
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:byView
                                                       attribute:NSLayoutAttributeBottom
                                                      multiplier:1.f
                                                        constant:0.f]];
    
    [byView addConstraint:[NSLayoutConstraint constraintWithItem:toView
                                                       attribute:NSLayoutAttributeLeading
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:byView
                                                       attribute:NSLayoutAttributeLeading
                                                      multiplier:1.f
                                                        constant:0.f]];
    
    [byView addConstraint:[NSLayoutConstraint constraintWithItem:toView
                                                       attribute:NSLayoutAttributeTrailing
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:byView
                                                       attribute:NSLayoutAttributeTrailing
                                                      multiplier:1.f
                                                        constant:0.f]];
}

@end
