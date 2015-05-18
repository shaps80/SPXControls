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

#import <UIKit/UIKit.h>

extern NSString *SPXSelectionCellReuseIdentifier;

@protocol SPXSelectionControllerDelegate;

@interface SPXSelectionControllerConfiguration : NSObject

@property (nonatomic, copy) NSArray *items;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) NSUInteger supportedInterfaceOrientations;
@property (nonatomic, assign) UIStatusBarStyle preferredStatusBarStyle;
@property (nonatomic, assign) BOOL prefersStatusBarHidden;

@end


@interface SPXSelectionController : UIViewController

@property (nonatomic, weak) id <SPXSelectionControllerDelegate> delegate;

@property (nonatomic, readonly) UITableView *tableView;
@property (nonatomic, copy) void (^completionBlock)(id item, NSUInteger selectedIndex);
@property (nonatomic, copy) UITableViewCell* (^cellForRowAtIndexPathBlock)(UITableView *tableView, id item, NSIndexPath *indexPath, BOOL selected);

- (instancetype)initWithConfiguration:(void (^)(SPXSelectionControllerConfiguration *configuration))configurationBlock;

- (void)applyConfiguration:(void (^)(SPXSelectionControllerConfiguration *configuration))configurationBlock;

@end


@protocol SPXSelectionControllerDelegate <NSObject>

- (void)controller:(SPXSelectionController *)controller didSelectItem:(id)item atIndex:(NSUInteger)index;

@end
