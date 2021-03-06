//
//  IMLEXTableViewCell.h
//  IMLEX
//
//  Created by Tanner on 4/17/19.
//  Copyright © 2019 Flipboard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IMLEXTableViewCell : UITableViewCell

/// Use this instead of .textLabel
@property (nonatomic, readonly) UILabel *titleLabel;
/// Use this instead of .detailTextLabel
@property (nonatomic, readonly) UILabel *subtitleLabel;

/// Subclasses can override this instead of initializers to
/// perform additional initialization without lots of boilerplate.
/// Remember to call super!
- (void)postInit;

@end
