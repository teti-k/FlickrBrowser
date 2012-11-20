//
//  VacationHelper.h
//  FlickrBrowser
//
//  Created by Zshcbka on 11/6/12.
//  Copyright (c) 2012 Zshcbka. All rights reserved.
//

#import <Foundation/Foundation.h>
#define VACATION_PLANS_ARRAY @"Vacation Plans"

typedef void (^completion_block_t)(UIManagedDocument *vacation);
typedef void (^download_completion_block)(NSData *data);
@interface VacationHelper : NSObject
+ (void)openVacation:(NSString *)vacationName
          usingBlock:(completion_block_t)completionBlock;
@end
