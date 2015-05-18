//
//  SPXViewController.m
//  SPXControls
//
//  Created by Shaps Mohsenin on 02/05/2015.
//  Copyright (c) 2014 Shaps Mohsenin. All rights reserved.
//

#import "SPXViewController.h"
#import "SPXAlertController.h"

@interface SPXViewController ()
@end

@implementation SPXViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self presentViewController:[UIViewController new] animated:YES completion:nil];
  
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [self dismissViewControllerAnimated:YES completion:nil];
  });
}

- (IBAction)handleButton:(id)sender
{
  SPXAlertController *controller = [SPXAlertController alertControllerWithTitle:@"Title" message:@"Message" preferredStyle:SPXAlertControllerStyleActionSheet];
  
  SPXAlertAction *ok = [SPXAlertAction actionWithTitle:@"OK" style:SPXAlertActionStyleDefault handler:^(SPXAlertAction *action) {
    NSLog(@"%@", action.title);
  }];
  
  SPXAlertAction *cancel = [SPXAlertAction actionWithTitle:@"Cancel" style:SPXAlertActionStyleCancel handler:^(SPXAlertAction *action) {
    NSLog(@"%@", action.title);
  }];
  
  SPXAlertAction *delete = [SPXAlertAction actionWithTitle:@"Delete" style:SPXAlertActionStyleDestructive handler:^(SPXAlertAction *action) {
    NSLog(@"%@", action.title);
  }];

  
  [controller addAction:ok];
  [controller addAction:cancel];
  [controller addAction:delete];
  
  [self presentViewController:controller animated:YES completion:^{
    
  }];
}

@end

