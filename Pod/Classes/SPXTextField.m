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

#import "SPXTextField.h"
#import "SPXDefines.h"

static CGFloat const SPXTextFieldVerticalAdjustment = 8.0f;
static CGFloat const SPXTextFieldFontAdjustment = 1.5f;
static CGFloat const SPXTextFieldAnimationDuration = 1.0f;

@interface SPXTextField ()
@property (nonatomic, strong) UILabel *floatingLabel;
@property (nonatomic, assign) BOOL requiresUpdate;
@end

@implementation SPXTextField

- (void)animateWithBlock:(void (^)())block
{
  [UIView animateWithDuration:SPXTextFieldAnimationDuration delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
    !block ?: block();
  } completion:nil];
}

- (void)updateFloatingLabel
{
  if (!self.requiresUpdate) {
    self.floatingLabel.frame = self.floatingLabelRect;
  }
  
  NSString *text = self.capitalizeFloatingLabel ? self.placeholder.uppercaseString : self.placeholder;
  UIColor *textColor = self.isEditing ? self.activeTintColor : self.inactiveTintColor;
  
  NSError *error = nil;
  if (![self isFirstResponder] && ![self validateWithError:&error]) {
    textColor = self.invalidTintColor;
    text = self.capitalizeFloatingLabel ? error.localizedDescription.uppercaseString : error.localizedDescription;
  }
  
  NSDictionary *attributes = @
  {
    NSForegroundColorAttributeName : textColor,
    NSStrokeWidthAttributeName : @(-1),
  };
  
  self.floatingLabel.attributedText = [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (void)hideFloatingLabel:(BOOL)animated
{
  CGRect rect = self.floatingLabelRect;
  rect.origin.y += SPXTextFieldVerticalAdjustment;
  
  if (animated) {
    [self animateWithBlock:^{
      self.floatingLabel.alpha = 0;
      self.floatingLabel.frame = rect;
    }];
  } else {
    self.floatingLabel.alpha = 0;
    self.floatingLabel.frame = rect;
  }
}

- (void)showFloatingLabel:(BOOL)animated
{
  if (animated) {
    [self animateWithBlock:^{
      self.floatingLabel.alpha = 1;
      self.floatingLabel.frame = self.floatingLabelRect;
    }];
  } else {
    self.floatingLabel.alpha = 1;
    self.floatingLabel.frame = self.floatingLabelRect;
  }
}

#pragma mark - Notifications

- (void)willMoveToSuperview:(UIView *)newSuperview
{
  if (self.hasText) {
    [self showFloatingLabel:NO];
  } else {
    [self hideFloatingLabel:NO];
  }
}

- (void)textFieldDidBeginEditing:(NSNotification *)notification
{
  if (![self validateWithError:nil]) {
    return;
  }
  
  [self updateFloatingLabel];
}

- (void)textFieldDidEndEditing:(NSNotification *)notification
{
  [self updateFloatingLabel];
}

- (void)textFieldTextDidChange:(NSNotification *)notification
{
  [self updateFloatingLabel];
  
  BOOL requiresUpdate = self.requiresUpdate;
  self.requiresUpdate = !self.text.length;
  
  if (requiresUpdate != self.requiresUpdate) {
    if (self.requiresUpdate) {
      [self hideFloatingLabel:YES];
    } else {
      [self showFloatingLabel:YES];
    }
  }
}

#pragma mark - Lifecycle

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib
{
  [super awakeFromNib];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:self];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidEndEditing:) name:UITextFieldTextDidEndEditingNotification object:self];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:self];
  
  [self updateFloatingLabel];
  [self textFieldTextDidChange:nil];
}

- (void)setPlaceholder:(NSString *)placeholder
{
  [super setPlaceholder:placeholder];
  self.floatingLabel.frame = self.floatingLabelRect;
  self.floatingLabel.text = placeholder;
}

- (void)setDataValidator:(id<SPXDataValidator>)dataValidator
{
  [super setDataValidator:dataValidator];
  [self updateFloatingLabel];
}

- (UILabel *)floatingLabel
{
  if (_floatingLabel) {
    return _floatingLabel;
  }
  
  _floatingLabel = [[UILabel alloc] initWithFrame:self.floatingLabelRect];
  _floatingLabel.text = self.capitalizeFloatingLabel ? self.placeholder.uppercaseString : self.placeholder;
  _floatingLabel.textColor = self.tintColor;
  _floatingLabel.adjustsFontSizeToFitWidth = NO;
  _floatingLabel.lineBreakMode = NSLineBreakByTruncatingTail;
  _floatingLabel.font = [self.font fontWithSize:self.font.pointSize / SPXTextFieldFontAdjustment];
  
  [self addSubview:_floatingLabel];
  
  return _floatingLabel;
}

- (void)setFont:(UIFont *)font
{
  [super setFont:font];
  self.floatingLabel.font = [self.font fontWithSize:font.pointSize / SPXTextFieldFontAdjustment];
}

- (void)setText:(NSString *)text
{
  [super setText:text];
  [self textFieldTextDidChange:nil];
}

#pragma mark - Layout

- (CGRect)floatingLabelRect
{
  return CGRectOffset(self.bounds, 0, -self.font.lineHeight - 2 - self.verticalSpacing + SPXTextFieldVerticalAdjustment);
}

- (void)setVerticalSpacing:(CGFloat)verticalSpacing
{
  _verticalSpacing = verticalSpacing;
  [self updateFloatingLabel];
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
  if (!self.text.length) {
    return [super textRectForBounds:bounds];
  }
  
  return CGRectOffset([super textRectForBounds:bounds], 0, SPXTextFieldVerticalAdjustment + self.verticalSpacing / 2);
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
  if (!self.text.length) {
    return [super textRectForBounds:bounds];
  }
  
  return CGRectOffset([super editingRectForBounds:bounds], 0, SPXTextFieldVerticalAdjustment + self.verticalSpacing / 2);
}

- (CGRect)clearButtonRectForBounds:(CGRect)bounds
{
  return CGRectOffset([super clearButtonRectForBounds:bounds], 0, SPXTextFieldVerticalAdjustment + self.verticalSpacing / 2);
}

- (CGRect)leftViewRectForBounds:(CGRect)bounds
{
  return CGRectOffset([super leftViewRectForBounds:bounds], 0, SPXTextFieldVerticalAdjustment + self.verticalSpacing / 2);
}

- (CGRect)rightViewRectForBounds:(CGRect)bounds
{
  return CGRectOffset([super rightViewRectForBounds:bounds], 0, SPXTextFieldVerticalAdjustment + self.verticalSpacing / 2);
}

#pragma mark - Colors

- (void)setTintColor:(UIColor *)tintColor
{
  [super setTintColor:tintColor];
  self.activeTintColor = tintColor;
}

- (UIColor *)activeTintColor
{
  return _activeTintColor ?: self.tintColor;
}

- (UIColor *)inactiveTintColor
{
  return _inactiveTintColor ?: [UIColor colorWithRed:0.737 green:0.737 blue:0.761 alpha:1.000];
}

- (UIColor *)invalidTintColor
{
  return _invalidTintColor ?: [UIColor colorWithRed:0.796 green:0.000 blue:0.000 alpha:1.000];
}

@end
