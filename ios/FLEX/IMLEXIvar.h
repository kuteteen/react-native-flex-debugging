//
//  IMLEXIvar.h
//  IMLEX
//
//  Derived from MirrorKit.
//  Created by Tanner on 6/30/15.
//  Copyright (c) 2015 Tanner Bennett. All rights reserved.
//

#import "IMLEXRuntimeConstants.h"

@interface IMLEXIvar : NSObject

+ (instancetype)ivar:(Ivar)ivar;
+ (instancetype)named:(NSString *)name onClass:(Class)cls;

/// The underlying \c Ivar data structure.
@property (nonatomic, readonly) Ivar             objc_ivar;

/// The name of the instance variable.
@property (nonatomic, readonly) NSString         *name;
/// The type of the instance variable.
@property (nonatomic, readonly) IMLEXTypeEncoding type;
/// The type encoding string of the instance variable.
@property (nonatomic, readonly) NSString         *typeEncoding;
/// The offset of the instance variable.
@property (nonatomic, readonly) NSInteger        offset;
/// The size of the instance variable. 0 if unknown.
@property (nonatomic, readonly) NSUInteger       size;
/// Describes the type encoding, size, offset, and objc_ivar
@property (nonatomic, readonly) NSString        *details;

/// For internal use
@property (nonatomic) id tag;

- (id)getValue:(id)target;
- (void)setValue:(id)value onObject:(id)target;

/// Calls into -getValue: and passes that value into
/// -[IMLEXRuntimeUtility potentiallyUnwrapBoxedPointer:type:]
/// and returns the result
- (id)getPotentiallyUnboxedValue:(id)target;

@end
