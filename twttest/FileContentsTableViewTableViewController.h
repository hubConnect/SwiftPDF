//
//  FileContentsTableViewTableViewController.h
//  twttest
//
//  Created by Jon Kotowski on 5/21/14.
//  Copyright (c) 2014 Jon Kotowski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FileContentsTableViewTableViewController : UITableViewController
<UITableViewDataSource,UITableViewDelegate>

-(void) setDataItems: (NSArray * ) data ;
@end
