//
//  IMLEXArgumentInputViewFactory.h
//  IMLEXInjected
//
//  Created by Ryan Olson on 6/15/14.
//
//

#import <Foundation/Foundation.h>
#import "IMLEXArgumentInputSwitchView.h"

@interface IMLEXArgumentInputViewFactory : NSObject

/// Forwards to argumentInputViewForTypeEncoding:currentValue: with a nil currentValue.
+ (IMLEXArgumentInputView *)argumentInputViewForTypeEncoding:(const char *)typeEncoding;

/// The main factory method for making argument input view subclasses that are the best fit for the type.
+ (IMLEXArgumentInputView *)argumentInputViewForTypeEncoding:(const char *)typeEncoding currentValue:(id)currentValue;

/// A way to check if we should try editing a filed given its type encoding and value.
/// Useful when deciding whether to edit or explore a property, ivar, or NSUserDefaults value.
+ (BOOL)canEditFieldWithTypeEncoding:(const char *)typeEncoding currentValue:(id)currentValue;

@end
