//
//  IMLEXSQLResult.m
//  IMLEX
//
//  Created by Tanner on 3/3/20.
//  Copyright © 2020 Flipboard. All rights reserved.
//

#import "IMLEXSQLResult.h"
#import "NSArray+Functional.h"

@implementation IMLEXSQLResult
@synthesize keyedRows = _keyedRows;

+ (instancetype)message:(NSString *)message {
    return [[self alloc] initWithmessage:message columns:nil rows:nil];
}

+ (instancetype)columns:(NSArray<NSString *> *)columnNames rows:(NSArray<NSArray<NSString *> *> *)rowData {
    return [[self alloc] initWithmessage:nil columns:columnNames rows:rowData];
}

- (id)initWithmessage:(NSString *)message columns:(NSArray *)columns rows:(NSArray<NSArray *> *)rows {
    NSParameterAssert(message || (columns && rows));
    NSParameterAssert(columns.count == rows.firstObject.count);
    
    self = [super init];
    if (self) {
        _message = message;
        _columns = columns;
        _rows = rows;
    }
    
    return self;
}

- (NSArray<NSDictionary<NSString *,id> *> *)keyedRows {
    if (!_keyedRows) {
        _keyedRows = [self.rows IMLEX_mapped:^id(NSArray<NSString *> *row, NSUInteger idx) {
            return [NSDictionary dictionaryWithObjects:row forKeys:self.columns];
        }];
    }
    
    return _keyedRows;
}

@end
