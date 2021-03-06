//
//  UIView+IMLEX_Layout.m
//  IMLEX
//
//  Created by Tanner Bennett on 7/18/19.
//  Copyright © 2019 Flipboard. All rights reserved.
//

#import "UIView+IMLEX_Layout.h"

@implementation UIView (IMLEX_Layout)

- (void)centerInView:(UIView *)view {
    [NSLayoutConstraint activateConstraints:@[
        [self.centerXAnchor constraintEqualToAnchor:view.centerXAnchor],
        [self.centerYAnchor constraintEqualToAnchor:view.centerYAnchor],
    ]];
}

- (void)pinEdgesTo:(UIView *)view {
   [NSLayoutConstraint activateConstraints:@[
       [self.topAnchor constraintEqualToAnchor:view.topAnchor],
       [self.leftAnchor constraintEqualToAnchor:view.leftAnchor],
       [self.bottomAnchor constraintEqualToAnchor:view.bottomAnchor],
       [self.rightAnchor constraintEqualToAnchor:view.rightAnchor],
   ]]; 
}

- (void)pinEdgesTo:(UIView *)view withInsets:(UIEdgeInsets)i {
    [NSLayoutConstraint activateConstraints:@[
        [self.topAnchor constraintEqualToAnchor:view.topAnchor constant:i.top],
        [self.leftAnchor constraintEqualToAnchor:view.leftAnchor constant:i.left],
        [self.bottomAnchor constraintEqualToAnchor:view.bottomAnchor constant:-i.bottom],
        [self.rightAnchor constraintEqualToAnchor:view.rightAnchor constant:-i.right],
    ]];
}

- (void)pinEdgesToSuperview {
    [self pinEdgesTo:self.superview];
}

- (void)pinEdgesToSuperviewWithInsets:(UIEdgeInsets)insets {
    [self pinEdgesTo:self.superview withInsets:insets];
}

- (void)pinEdgesToSuperviewWithInsets:(UIEdgeInsets)i aboveView:(UIView *)sibling {
    UIView *view = self.superview;
    [NSLayoutConstraint activateConstraints:@[
        [self.topAnchor constraintEqualToAnchor:view.topAnchor constant:i.top],
        [self.leftAnchor constraintEqualToAnchor:view.leftAnchor constant:i.left],
        [self.bottomAnchor constraintEqualToAnchor:sibling.topAnchor constant:-i.bottom],
        [self.rightAnchor constraintEqualToAnchor:view.rightAnchor constant:-i.right],
    ]];
}

- (void)pinEdgesToSuperviewWithInsets:(UIEdgeInsets)i belowView:(UIView *)sibling {
    UIView *view = self.superview;
    [NSLayoutConstraint activateConstraints:@[
        [self.topAnchor constraintEqualToAnchor:sibling.bottomAnchor constant:i.top],
        [self.leftAnchor constraintEqualToAnchor:view.leftAnchor constant:i.left],
        [self.bottomAnchor constraintEqualToAnchor:view.bottomAnchor constant:-i.bottom],
        [self.rightAnchor constraintEqualToAnchor:view.rightAnchor constant:-i.right],
    ]];
}

@end
