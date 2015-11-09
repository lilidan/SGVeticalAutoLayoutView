//
//  ViewController.m
//  SGTextFieldAutoLayout
//
//  Created by sgcy on 15/11/6.
//  Copyright © 2015年 sgcy. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imgView.layer.cornerRadius = self.imgView.frame.size.width /2 ;
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGr)];
    [self.view addGestureRecognizer:tapGr];
}

- (void)tapGr
{
    for (UIView *view in self.view.subviews) {
        [view resignFirstResponder];
    }
}

@end
