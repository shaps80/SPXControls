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


/**
 *  The default reuse identifier -- register a cell or nib with this identifier to change the default cell used by this controller
 */
extern NSString *SPXSelectionCellReuseIdentifier;

@protocol SPXSelectionControllerDelegate;


/**
 *  Provides a configuration for a SPXSelectionController
 */
@interface SPXSelectionControllerConfiguration : NSObject


/**
 *  The items representing options for this selection controller
 */
@property (nonatomic, copy) NSArray *items;


/**
 *  The currently selected index
 */
@property (nonatomic, assign) NSInteger selectedIndex;


/**
 *  The supported interface orientations for this selection controller
 */
@property (nonatomic, assign) NSUInteger supportedInterfaceOrientations;


/**
 *  The preferred status bar style for this selection controller
 */
@property (nonatomic, assign) UIStatusBarStyle preferredStatusBarStyle;


/**
 *  If YES, the status bar will be hidden when the selection controller is presented
 */
@property (nonatomic, assign) BOOL prefersStatusBarHidden;


@end



/**
 *  Represents a multiple selection view controller, providing the user with multiple options and a completion block (and/or optional delegate) for responding to selecfion changes
 */
@interface SPXSelectionController : UIViewController


/**
 *  The delegate for this controller (optional)
 */
@property (nonatomic, weak) id <SPXSelectionControllerDelegate> delegate;


/**
 *  The tableView that will be used to present the options (read-only). You can use this to register a custom cell or change appearance settings.
 */
@property (nonatomic, readonly) UITableView *tableView;


/**
 *  The completion block to call when a selection is made. You are responsible for dimissing/popping this controller if necessary, this is a good place to do that.
 */
@property (nonatomic, copy) void (^completionBlock)(id item, NSUInteger selectedIndex);


/**
 *  You can provide a custom block for returning a cell to the table view.
 */
@property (nonatomic, copy) UITableViewCell* (^cellForRowAtIndexPathBlock)(UITableView *tableView, id item, NSIndexPath *indexPath, BOOL selected);


/**
 *  Initializes this controller with the specified configuration block
 *
 *  @param configurationBlock The configuration block will return an SPXSelectionControllerConfiguration instance that you can configure.
 *
 *  @return A newly configured instance
 */
- (instancetype)initWithConfiguration:(void (^)(SPXSelectionControllerConfiguration *configuration))configurationBlock;


/**
 *  Applies the specified configuration to an existing controller
 *
 *  @param configurationBlock The configuration block will return an SPXSelectionControllerConfiguration instance that you can configure.
 */
- (void)applyConfiguration:(void (^)(SPXSelectionControllerConfiguration *configuration))configurationBlock;


@end



/**
 *  Defines a delegate for an SPXSelectionController
 */
@protocol SPXSelectionControllerDelegate <NSObject>


/**
 *  When a selection is made, this method is called
 *
 *  @param controller The controller that called this method
 *  @param item       The item that was selected
 *  @param index      The index of the item that was selected
 *
 *  @note You are responsible for dimissing/popping this controller if necessary, this is a good place to do that.
 */
- (void)controller:(SPXSelectionController *)controller didSelectItem:(id)item atIndex:(NSUInteger)index;


@end

