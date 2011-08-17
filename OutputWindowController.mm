//
//  OutputWindowController.mm
//  PlaskLauncher
//
//  Created by Dean on 16/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OutputWindowController.h"

extern NSTextView* g_output_text_view;

@implementation OutputWindowController

@synthesize text_view;

-(id)init {
  if (self = [super initWithWindowNibName:@"OutputWindow"]) {
  }
  return self;
}

-(void)windowDidLoad {
  NSLog(@"Loaded");

#if 0
  [text_view setAllowsUndo:NO];
  [text_view setAllowsImageEditing:NO];
  [text_view setAllowsDocumentBackgroundColorChange:NO];
  [text_view setAutomaticSpellingCorrectionEnabled:NO];
  [text_view setAutomaticTextReplacementEnabled:NO];
  [text_view setContinuousSpellCheckingEnabled:NO];
  [text_view setEditable:NO];
  [text_view setGrammarCheckingEnabled:NO];
  [text_view setImportsGraphics:NO];
  [text_view setRichText:NO];
#endif

  [[text_view textContainer] setWidthTracksTextView:YES];

  g_output_text_view = text_view;
}

-(void)windowWillClose:(NSNotification*)notification {
  NSLog(@"Closing");
  g_output_text_view = nil;
}

@end
