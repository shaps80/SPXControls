/*
   Copyright (c) 2015 Snippex. All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 1. Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 2. Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.
 
 THIS SOFTWARE IS PROVIDED BY Snippex `AS IS' AND ANY EXPRESS OR
 IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
 EVENT SHALL Snippex OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "SPXAlertController.h"
#import "SPXDefines.h"

static SPXAlertController *__controller = nil;

@interface SPXAlertAction ()
@property (nonatomic, strong) NSString *title;
@property (nonatomic, copy) void (^handler)();
@property (nonatomic, assign) SPXAlertActionStyle style;
@end


@interface SPXAlertController () <UIAlertViewDelegate, UIActionSheetDelegate>

@property (nonatomic, assign) SPXAlertControllerStyle preferredStyle;
@property (nonatomic, strong) NSMutableDictionary *alertActions;

@end

@implementation SPXAlertController

#pragma mark - Lifeycle

@synthesize title;

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(SPXAlertControllerStyle)preferredStyle
{
  if (objc_getClass("UIAlertController") != nil) {
    return (SPXAlertController *)[UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyle)preferredStyle];
  }
  
  SPXAlertController *controller = [SPXAlertController new];
  
  controller.title = title;
  controller.message = message;
  controller.preferredStyle = preferredStyle;
  
  return controller;
}

#pragma mark - Actions

- (NSMutableDictionary *)alertActions
{
  return _alertActions ?: (_alertActions = [NSMutableDictionary new]);
}

- (NSArray *)actions
{
  return self.alertActions.copy;
}

- (void)addAction:(SPXAlertAction *)action
{
  SPXAssertTrueOrReturn(action.title);
  self.alertActions[action.title] = action;
}

#pragma mark - Presentation

- (void)presentFromViewController:(UIViewController *)controller completion:(void (^)(void))completion
{
  __controller = self;
  
  NSString *cancelTitle = nil, *destructiveTitle = nil;
  NSMutableArray *otherTitles = [NSMutableArray new];
  
  for (SPXAlertAction *action in self.alertActions.allValues) {
    switch (action.style) {
      case SPXAlertActionStyleCancel:
        cancelTitle = action.title;
        break;
      case SPXAlertActionStyleDestructive:
        destructiveTitle = action.title;
        break;
        
      default:
        [otherTitles addObject:action.title];
        break;
    }
  }
  
  if (self.preferredStyle == SPXAlertControllerStyleAlert) {
    [self presentAlertViewWithCancelTitle:cancelTitle destructiveTitle:destructiveTitle otherTitles:otherTitles];
  } else {
    [self presentActionSheetFromViewController:controller cancelTitle:cancelTitle destructiveTitle:destructiveTitle otherTitles:otherTitles];
  }
  
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    !completion ?: completion();
  });
}

- (void)presentActionSheetFromViewController:(UIViewController *)controller cancelTitle:(NSString *)cancelTitle destructiveTitle:(NSString *)destructiveTitle otherTitles:(NSArray *)otherTitles
{
  NSString *sheetTitle = [self.title stringByAppendingString:self.message ? [NSString stringWithFormat:@"\n\n%@", self.message] : @""];
  UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:sheetTitle delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
  
  for (NSString *buttonTitle in otherTitles) {
    [sheet addButtonWithTitle:buttonTitle];
  }
  
  NSUInteger index = [sheet addButtonWithTitle:destructiveTitle];
  sheet.destructiveButtonIndex = index;
  
  index = [sheet addButtonWithTitle:cancelTitle];
  sheet.cancelButtonIndex = index;
  
  UIView *view = controller.view;
  
  if ([controller isKindOfClass:[UITabBarController class]]) {
    [sheet showFromTabBar:((UITabBarController *)controller).tabBar];
    return;
  }
  else if (controller.tabBarController) {
    [sheet showFromTabBar:controller.tabBarController.tabBar];
    return;
  }
  else if (controller.navigationController.toolbar && !controller.navigationController.toolbarHidden) {
    if (controller.navigationController.toolbar.barStyle == UIBarStyleDefault) {
      sheet.actionSheetStyle = UIActionSheetStyleDefault;
    } else if (controller.navigationController.toolbar.barStyle == UIBarStyleBlackTranslucent) {
      sheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    } else {
      sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    }
    
    [sheet showFromToolbar:controller.navigationController.toolbar];
  }
  else {
    [sheet showInView:view];
  }
}

- (void)presentAlertViewWithCancelTitle:(NSString *)cancelTitle destructiveTitle:(NSString *)destructiveTitle otherTitles:(NSArray *)otherTitles
{
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:self.title message:self.message delegate:self cancelButtonTitle:cancelTitle otherButtonTitles:nil];
  
  for (NSString *buttonTitle in otherTitles) {
    [alert addButtonWithTitle:buttonTitle];
  }
  
  if (destructiveTitle) {
    [alert addButtonWithTitle:destructiveTitle];
  }
  
  [alert show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
  NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
  [self dismissWithButtonTitle:buttonTitle];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
  NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
  [self dismissWithButtonTitle:buttonTitle];
}

- (void)dismissWithButtonTitle:(NSString *)buttonTitle
{
  SPXAlertAction *action = self.alertActions[buttonTitle];
  !action.handler ?: action.handler(action);
  __controller = nil;
}

#pragma mark - Debugging

- (NSString *)preferredStyleValue
{
  switch (self.preferredStyle) {
    case SPXAlertControllerStyleActionSheet:
      return @"SPXAlertControllerStyleActionSheet";
    case SPXAlertControllerStyleAlert:
      return @"SPXAlertControllerStyleAlert";
  }
}

- (NSString *)description
{
  return SPXDescription(SPXKeyPath(title), SPXKeyPath(message), SPXKeyPath(preferredStyleValue), SPXKeyPath(actions));
}

@end


@implementation SPXAlertAction

- (id)copyWithZone:(NSZone *)zone
{
  SPXAlertAction *copy = [SPXAlertAction new];
  
  copy->_style = self.style;
  copy->_title = self.title;
  copy->_handler = self.handler;
  
  return copy;
}

+ (instancetype)actionWithTitle:(NSString *)title style:(SPXAlertActionStyle)style handler:(void (^)(SPXAlertAction *action))handler
{
  SPXAssertTrueOrReturnNil(title);
  
  if (objc_getClass("UIAlertController") != nil) {
    return (SPXAlertAction *)[UIAlertAction actionWithTitle:title style:(UIAlertActionStyle)style handler:(void (^)(UIAlertAction *action))handler];
  }
  
  SPXAlertAction *action = [SPXAlertAction new];
  
  action.title = title;
  action.style = style;
  action.handler = handler;
  
  return action;
}

#pragma mark - Debugging

- (NSString *)styleValue
{
  switch (self.style) {
    case SPXAlertActionStyleDefault:
      return @"SPXAlertActionStyleDefault";
    case SPXAlertActionStyleCancel:
      return @"SPXAlertActionStyleCancel";
    case SPXAlertActionStyleDestructive:
      return @"SPXAlertActionStyleDestructive";
  }
}

- (NSString *)description
{
  return SPXDescription(SPXKeyPath(title), SPXKeyPath(styleValue));
}

@end


