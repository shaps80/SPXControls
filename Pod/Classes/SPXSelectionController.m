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

#import "SPXSelectionController.h"
#import "SPXDefines.h"

NSString *SPXSelectionCellReuseIdentifier = @"Cell";

@interface SPXSelectionController() <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) SPXSelectionControllerConfiguration *configuration;

@end

@implementation SPXSelectionController

#pragma mark - Lifecycle

- (instancetype)initWithConfiguration:(void (^)(SPXSelectionControllerConfiguration *))configurationBlock
{
  self = [super init];
  SPXAssertTrueOrReturnNil(self);
  SPXAssertTrueOrReturnNil(configurationBlock);
  
  [self applyConfiguration:configurationBlock];
  
  return self;
}

- (void)applyConfiguration:(void (^)(SPXSelectionControllerConfiguration *))configurationBlock
{
  SPXSelectionControllerConfiguration *configuration = [SPXSelectionControllerConfiguration new];
  configurationBlock(configuration);
  
  if (configuration.selectedIndex > configuration.items.count - 1) {
    configuration.selectedIndex = -1;
  }
  
  _configuration = configuration;  
  [self.tableView reloadData];
}

- (void)loadView
{
  self.view = self.tableView;
}

- (UITableView *)tableView
{
  return _tableView ?: ({
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    _tableView = tableView;
  });
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  if (self.isSelectedIndexValid) {
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:self.configuration.selectedIndex inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
  }
}

- (BOOL)isSelectedIndexValid
{
  return (self.configuration.selectedIndex > -1 && self.configuration.selectedIndex < self.configuration.items.count);
}

#pragma mark - Configuration

- (BOOL)prefersStatusBarHidden
{
  return self.configuration.prefersStatusBarHidden;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
  return self.configuration.preferredStatusBarStyle;
}

- (NSUInteger)supportedInterfaceOrientations
{
  return self.configuration.supportedInterfaceOrientations;
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = nil;
  id item = self.configuration.items[indexPath.item];
  BOOL selected = (indexPath.item == self.configuration.selectedIndex);
  
  if (self.cellForRowAtIndexPathBlock) {
    cell = self.cellForRowAtIndexPathBlock(tableView, item, indexPath, selected);
  }

  if (cell) {
    return cell;
  }
  
  cell = [tableView dequeueReusableCellWithIdentifier:SPXSelectionCellReuseIdentifier];
  
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SPXSelectionCellReuseIdentifier];
  }
  
  if ([item isKindOfClass:[NSString class]]) {
    cell.textLabel.text = self.configuration.items[indexPath.item];
  } else {
    cell.textLabel.text = [self.configuration.items[indexPath.item] description];
  }
  
  if (self.isSelectedIndexValid) {
    cell.accessoryType = selected ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
  }
  
  return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.configuration.items.count;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  id item = self.configuration.items[indexPath.item];
  
  if ([self.delegate respondsToSelector:@selector(controller:didSelectItem:atIndex:)]) {
    [self.delegate controller:self didSelectItem:item atIndex:indexPath.item];
  }
  
  !self.completionBlock ?: self.completionBlock(item, indexPath.item);
}

@end

@implementation SPXSelectionControllerConfiguration

- (NSString *)description
{
  return SPXDescription(SPXKeyPath(selectedIndex), SPXKeyPath(supportedInterfaceOrientations), SPXKeyPath(preferredStatusBarStyle), SPXKeyPath(prefersStatusBarHidden));
}

@end



