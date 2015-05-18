/*
 Copyright (c) 2015 Shaps Mohsenin. All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 1. Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 2. Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.
 
 THIS SOFTWARE IS PROVIDED BY Shaps Mohsenin `AS IS' AND ANY EXPRESS OR
 IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
 EVENT SHALL Shaps Mohsenin OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "UIViewController+SPXAdditions.h"
#import "SPXAlertController.h"
#import <objc/runtime.h>

@interface SPXAlertController ()
- (void)presentFromViewController:(UIViewController *)controller completion:(void (^)(void))completion;
@end

@implementation UIViewController (SPXAdditions)

void (*spxPresentViewController)(id, SEL, UIViewController*, BOOL, id);

+ (void)load
{
  Method origMethod = class_getInstanceMethod(self, @selector(presentViewController:animated:completion:));
  spxPresentViewController = (void *)method_getImplementation(origMethod);
  
  if (!class_addMethod(self, @selector(presentViewController:animated:completion:), (IMP)SPXPresentViewController, method_getTypeEncoding(origMethod))) {
    method_setImplementation(origMethod, (IMP)SPXPresentViewController);
  }
}

static void SPXPresentViewController(id self, SEL _cmd, UIViewController* controllerToPresent, BOOL animated, id completionBlock)
{
  if ([controllerToPresent isKindOfClass:[SPXAlertController class]]) {
    // do something else
    SPXAlertController *controller = (SPXAlertController *)controllerToPresent;
    [controller presentFromViewController:self completion:completionBlock];
  } else {
    spxPresentViewController(self, _cmd, controllerToPresent, animated, completionBlock);
  }
}

@end
