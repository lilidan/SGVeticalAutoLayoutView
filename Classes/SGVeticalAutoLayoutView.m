//
//  SGTextFieldAutoLayoutView.m
//  SGTextFieldAutoLayout
//
//  Created by sgcy on 15/11/6.
//  Copyright © 2015年 sgcy. All rights reserved.
//

#import "SGVeticalAutoLayoutView.h"
#import <objc/runtime.h>

#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)


@interface UIView(VeticalAutoLayout)

@property (nonatomic,strong) NSLayoutConstraint *constraint;
@property (nonatomic,strong) NSNumber *nibHeight;

@end

static char CONSTRAINT_IDENTIFER;
static char NIB_HEIGHT;

@implementation UIView(VeticalAutoLayout)

@dynamic constraint;

- (void)setConstraint:(NSLayoutConstraint *)constraint
{
    objc_setAssociatedObject(self, &CONSTRAINT_IDENTIFER, constraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)constraint
{
    return objc_getAssociatedObject(self, &CONSTRAINT_IDENTIFER);
}

- (void)setNibHeight:(NSNumber *)nibHeight
{
    objc_setAssociatedObject(self, &NIB_HEIGHT, nibHeight, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)nibHeight
{
    return objc_getAssociatedObject(self, &NIB_HEIGHT);
}

- (void)setUpNotifications
{
    [self setNibHeight:@(self.superview.frame.size.height)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameDidChange:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameDidChange:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameDidChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameDidChange:) name:UIKeyboardDidChangeFrameNotification object:nil];
}

- (void)setUpConstraint
{
    if (!self.constraint) {
        CGFloat multiplier = self.center.y / (self.nibHeight.doubleValue / 2);
        self.constraint = [NSLayoutConstraint constraintWithItem:self
                                                       attribute:NSLayoutAttributeCenterY
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:self.superview
                                                       attribute:NSLayoutAttributeCenterY
                                                      multiplier:multiplier
                                                        constant:0];
        [self.superview addConstraint:self.constraint];
    }
}

- (void)keyboardFrameDidChange:(NSNotification *)notification
{
    
    NSDictionary* info = [notification userInfo];
    CGRect frame = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    UIViewAnimationCurve curve =  [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    CGFloat height = SCREEN_HEIGHT - frame.origin.y;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:duration
                              delay:0
                            options:(curve << 16)
                         animations:^{
                             self.constraint.constant = - ( height * self.constraint.multiplier / 2);
                             [self.superview setNeedsUpdateConstraints];
                             [self.superview layoutIfNeeded];
                             if ([self isKindOfClass:[UITextField class]]){
                                 NSLog(@"%f",self.constraint.constant);
                             }
                         }
                         completion:nil];

    });
}

@end

@implementation SGVeticalAutoLayoutView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setUpNotifications];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)updateConstraints
{
    [super updateConstraints];
    [self setUpConstraint];
}

@end


@implementation SGVeticalAutoLayoutTextField


- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setUpNotifications];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)updateConstraints
{
    [super updateConstraints];
    [self setUpConstraint];
}

@end

@implementation SGVeticalAutoLayoutButton

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setUpNotifications];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)updateConstraints
{
    [super updateConstraints];
    [self setUpConstraint];
}

@end

@implementation SGVeticalAutoLayoutImageView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setUpNotifications];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)updateConstraints
{
    [super updateConstraints];
    [self setUpConstraint];
}

@end