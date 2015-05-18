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

#import <UIKit/UIKit.h>

@class SPXAlertAction;


/**
 *  Styles to apply to action buttons in an alert.
 */
typedef NS_ENUM(NSInteger, SPXAlertActionStyle){
  /**
   *  Apply the default style to the action’s button.
   */
  SPXAlertActionStyleDefault = 0,
  /**
   *  Apply a style that indicates the action cancels the operation and leaves things unchanged.
   */
  SPXAlertActionStyleCancel,
  /**
   *  Apply a style that indicates the action might change or delete data.
   */
  SPXAlertActionStyleDestructive
};


/**
 *  Constants indicating the type of alert to display.
 */
typedef NS_ENUM(NSInteger, SPXAlertControllerStyle){
  /**
   *  An action sheet displayed in the context of the view controller that presented it.
   */
  SPXAlertControllerStyleActionSheet = 0,
  /**
   *  An alert displayed modally for the app
   */
  SPXAlertControllerStyleAlert
};


/**
 *  A UIAlertController object displays an alert message to the user. This class replaces the UIActionSheet and UIAlertView classes for displaying alerts on both iOS 7 and iOS 8. After configuring the alert controller with the actions and style you want, present it using the presentViewController:animated:completion: method.
 */
@interface SPXAlertController : UIViewController

/**
 *  The actions that the user can take in response to the alert or action sheet. (read-only)
 */
@property (nonatomic, readonly) NSArray *actions;


/**
 *  The style of the alert controller. (read-only)
 */
@property (nonatomic, assign, readonly) SPXAlertControllerStyle preferredStyle;


/**
 *  The title of the alert. The title string is displayed prominently in the alert or action sheet. You should use this string to get the user’s attention and communicate the reason for displaying the alert.
 */
@property (nonatomic, copy) NSString *title;


/**
 *  Descriptive text that provides more details about the reason for the alert.
 */
@property (nonatomic, copy) NSString *message;

/**
 *  Creates and returns a view controller for displaying an alert to the user. After creating the alert controller, configure any actions that you want the user to be able to perform by calling the addAction: method one or more times. When specifying a preferred style of UIAlertControllerStyleAlert, you may also configure one or more text fields to display in addition to the actions.
 *
 *  @param title          The title of the alert. Use this string to get the user’s attention and communicate the reason for the alert.
 message
 *  @param message        Descriptive text that provides additional details about the reason for the alert.
 *  @param preferredStyle The style to use when presenting the alert controller. Use this parameter to configure the alert controller as an action sheet or as a modal alert.
 *
 *  @return An initialized alert controller object.
 */
+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(SPXAlertControllerStyle)preferredStyle;


/**
 *  Attaches an action object to the alert or action sheet. If your alert has multiple actions, the order in which you add those actions determines their order in the resulting alert or action sheet.
 *
 *  @param action The action object to display as part of the alert. Actions are displayed as buttons in the alert. The action object provides the button text and the action to be performed when that button is tapped.
 */
- (void)addAction:(SPXAlertAction *)action;


@end


/**
 *  A UIAlertAction object represents an action that can be taken when tapping a button in an alert. You use this class to configure information about a single action, including the title to display in the button, any styling information, and a handler to execute when the user taps the button. After creating an alert action object, add it to a UIAlertController object before displaying the corresponding alert to the user.
 */
@interface SPXAlertAction : NSObject <NSCopying>


/**
 *  Create and return an action with the specified title and behavior. Actions are enabled by default when you create them.
 *
 *  @param title   The text to use for the button title. The value you specify should be localized for the user’s current language. This parameter must not be nil.
 *  @param style   Additional styling information to apply to the button. Use the style information to convey the type of action that is performed by the button. For a list of possible values, see the constants in UIAlertActionStyle.
 *  @param handler A block to execute when the user selects the action. This block has no return value and takes the selected action object as its only parameter.
 *
 *  @return A new alert action object.
 */
+ (instancetype)actionWithTitle:(NSString *)title style:(SPXAlertActionStyle)style handler:(void (^)(SPXAlertAction *action))handler;


/**
 *  The title of the action’s button. (read-only)
 */
@property (nonatomic, readonly) NSString *title;


/**
 *  The style that is applied to the action’s button. (read-only)
 */
@property (nonatomic, readonly) SPXAlertActionStyle style;


@end

