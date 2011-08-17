//
//  OutputWindowController.h
//  PlaskLauncher
//
//  Created by Dean on 16/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface OutputWindowController : NSWindowController<NSWindowDelegate> {
  NSTextView* text_view;
}

@property(nonatomic, retain) IBOutlet NSTextView* text_view;

@end
