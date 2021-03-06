//
//  NSString+YDDExtend.m
//  YDDExercise
//
//  Created by ydd on 2019/7/21.
//  Copyright © 2019 ydd. All rights reserved.
//

#import "NSString+YDDExtend.h"

@implementation NSString (YDDExtend)


- (NSString *)ydd_subStringToByteIndex:(NSInteger)index
{
    NSInteger sum = 0;
    NSString *subStr = [[NSString alloc] init];
    for(int i = 0; i<[self length]; i++){
        unichar strChar = [self characterAtIndex:i];
        if(strChar < 256){
            sum += 1;
        }
        else {
            sum += 2;
        }
        if (sum > index) {
            subStr = [self substringToIndex:i];
            return subStr;
        }
    }
    return self;
}

- (NSString *)ydd_subStringFormByteIndex:(NSInteger)index
{
    NSInteger sum = 0;
    NSString *subStr = [[NSString alloc] init];
    for(int i = 0; i<[self length]; i++){
        unichar strChar = [self characterAtIndex:i];
        if(strChar < 256){
            sum += 1;
        }
        else {
            sum += 2;
        }
        if (sum > index) {
            subStr = [self substringFromIndex:i];
            return subStr;
        }
    }
    return self;
}


- (NSURL *)ydd_coverUrl
{
    if (self.length == 0) {
        return nil;
    }
    if ([self hasPrefix:@"http:"] || [self hasPrefix:@"https:"]) {
        return [NSURL URLWithString:self];
    } else {
        NSURL *url = [NSURL fileURLWithPath:self];
        if (url) {
            return url;
        }
    }
    if ([self hasPrefix:@"file"] || [self containsString:@"/users/"]) {
        return [NSURL fileURLWithPath:self];
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:self ofType:@""];
    if (path) {
        return [NSURL fileURLWithPath:path];
    }
    return nil;
}

- (CGSize)ydd_textSize:(CGSize)maxSize font:(UIFont *)font
{
    NSAttributedString *att = [[NSAttributedString alloc] initWithString:self attributes:@{NSFontAttributeName : font}];
    return [att boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
}


+ (NSString *)getPathForDocumentWithDirName:(NSString *)dirName fileName:(NSString *)fileName
{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSFileManager *manager = [NSFileManager defaultManager];
    path = [path stringByAppendingPathComponent:dirName];
    BOOL isDir = NO;
    BOOL isEx = [manager fileExistsAtPath:path isDirectory:&isDir];
    if (!isDir || !isEx) {
        [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    if (!fileName) {
        fileName = [NSString stringWithFormat:@"%lu.png", (NSUInteger)[[NSDate date] timeIntervalSince1970] * 1000];
    }
    
    return [path stringByAppendingPathComponent:fileName];
}



+ (YDDNumber)maxFourNum:(NSInteger)num
{
    YDDNumber number = {@"0", @""};
    if (num < 1e4) {
        number.value = [NSString stringWithFormat:@"%ld", (long)num];
        number.unit = @"";
        return number;
    }
    NSDecimalNumber *decNum = [[NSDecimalNumber alloc] initWithInteger:num];
    NSDecimalNumber *num1 = [[NSDecimalNumber alloc] initWithDouble:1e4];
    
    NSDecimalNumber *valueNum = [decNum decimalNumberByDividingBy:num1];

    
    CGFloat value = valueNum.floatValue;
    if (value < 1e4) {
        number.value = [self subFourNumber:valueNum];
        number.unit = @"万";
        return number;
    }
    
    NSDecimalNumber *num2 = [[NSDecimalNumber alloc] initWithDouble:1e8];
    valueNum = [decNum decimalNumberByDividingBy:num2];
    
    value = valueNum.floatValue;
    if (value < 1e4) {
        number.value = [self subFourNumber:valueNum];
        number.unit = @"亿";
        return number;
    }
    
    number.value = [NSString stringWithFormat:@"%ld", (long)[valueNum integerValue]];
    number.unit = @"亿";
    return number;
}

+ (NSString *)subFourNumber:(NSDecimalNumber *)number
{
    CGFloat value = [number floatValue];
    
    NSString *result = @"";
    if (value >= 1e3) {
        result = [self decimalWithDeciNum:number scale:0];
    } else if (value >= 1e2) {
        result = [self decimalWithDeciNum:number scale:1];
    } else if (value >= 1e1) {
        result = [self decimalWithDeciNum:number scale:2];
    } else {
        result = [self decimalWithDeciNum:number scale:3];
    }
    return result;
}


+ (NSString *)decimalWithDeciNum:(NSDecimalNumber *)num scale:(short)scale
{
    NSDecimalNumberHandler *behavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:scale raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *newNum = [num decimalNumberByRoundingAccordingToBehavior:behavior];
    return [newNum stringValue];
}


@end
