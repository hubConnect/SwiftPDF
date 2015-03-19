//
//  NoteCategory.h
//  twttest
//
//  Created by Jon Kotowski on 5/4/14.
//  Copyright (c) 2014 Jon Kotowski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoteCategory : NSObject
<NSCoding>

@property (strong, nonatomic) NSArray<NSCoding> *notes;
@property (strong, nonatomic) NSString *categoryName;
@property (strong, nonatomic) NSDate *lastModified;

@end
