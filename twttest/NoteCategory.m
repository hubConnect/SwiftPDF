//
//  NoteCategory.m
//  twttest
//
//  Created by Jon Kotowski on 5/4/14.
//  Copyright (c) 2014 Jon Kotowski. All rights reserved.
//no

#import "NoteCategory.h"

@implementation NoteCategory


- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:self.categoryName forKey:[NSString stringWithFormat:@"category"]];
    
    [aCoder encodeObject:self.notes forKey:@"notes"];
    
    [aCoder encodeObject:self.lastModified forKey:[NSString stringWithFormat:@"date"]];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    NoteCategory* temp = [[NoteCategory alloc] init];
    
    NSString *category = (NSString *)[aDecoder decodeObjectForKey:[NSString stringWithFormat:@"category"]];
        temp.categoryName = category;
    
    NSArray * notes = (NSArray *) [aDecoder decodeObjectForKey:@"notes"];
    self.notes = notes;
    
    NSDate * lastMod = (NSDate *) [aDecoder decodeObjectForKey:[NSString stringWithFormat:@"date"]];
    temp.lastModified = lastMod;
    
    return temp;
}

@end

