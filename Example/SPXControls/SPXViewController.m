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

- (IBAction)handleButton:(id)sender
{
  SPXAlertController *controller = [SPXAlertController alertControllerWithTitle:@"Title" message:@"Message" preferredStyle:SPXAlertControllerStyleAlert];
  
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

