//
//  SPXViewController.m
//  SPXControls
//
//  Created by Shaps Mohsenin on 02/05/2015.
//  Copyright (c) 2014 Shaps Mohsenin. All rights reserved.
//

#import "SPXViewController.h"
#import "SPXTextField.h"
#import "UITextField+SPXDataValidatorAdditions.h"
#import "SPXRegexDataValidator.h"

@interface SPXViewController ()
@property (nonatomic, weak) IBOutlet SPXTextField *textField;
@end

@implementation SPXViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.textField.text = @"Shaps Server";
  self.textField.placeholder = @"Server name";
  self.textField.verticalSpacing = 10;
  [self.textField applyValidator:[SPXRegexDataValidator emailValidator]];
}

@end

