// Plask.
// (c) Dean McNamee <dean@gmail.com>, 2010.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to
// deal in the Software without restriction, including without limitation the
// rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
// sell copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
// IN THE SOFTWARE.

#import <Cocoa/Cocoa.h>
#import <Foundation/NSFileHandle.h>
#import "MyDocument.h"

BOOL g_launched_document = NO;
NSTextView* g_output_text_view = nil;

@interface AntiDocumentController : NSDocumentController {
}
@end

@implementation AntiDocumentController

-(void)onPipeData:(NSNotification*)notification {
  // TODO(deanm): Move this to objective-c++ and reinterpret_cast.
  NSFileHandle* handle = (NSFileHandle*)([notification object]);
  NSData* data = [handle availableData];
  // NSLog(@"Data: %@", data);

  if ([data length] == 0)  // Test if we've reached EOF.
    return;
  // TODO(deanm): We should cleanup and remove our observers here.

  if (g_output_text_view) {
    [[g_output_text_view textStorage] appendAttributedString:
        [[[NSAttributedString alloc] initWithString:
            [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]
          autorelease]] autorelease]];
    // TODO(deanm): Only scroll the view if it was already at the bottom.
    [g_output_text_view scrollRangeToVisible:
        NSMakeRange([[g_output_text_view string] length], 0)];
  } else {
    // NSLog(@"Debug output window not open.");
  }
    
  [handle waitForDataInBackgroundAndNotify];  // Continue on the async chain.
}

-(id)openDocumentWithContentsOfURL:(NSURL *)abs_url
    display:(BOOL)displayDocument
    error:(NSError **)outError {
  g_launched_document = YES;

  NSPipe* p_stderr = [NSPipe pipe];
  NSPipe* p_stdout = [NSPipe pipe];

  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(onPipeData:)
             name:NSFileHandleDataAvailableNotification
           object:[p_stderr fileHandleForReading]];
  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(onPipeData:)
             name:NSFileHandleDataAvailableNotification
           object:[p_stdout fileHandleForReading]];
  [[p_stderr fileHandleForReading] waitForDataInBackgroundAndNotify];
  [[p_stdout fileHandleForReading] waitForDataInBackgroundAndNotify];

  NSString* plaskpath = 
      [[[[NSBundle mainBundle] URLForResource:@"Plask" withExtension:@"app"]
          URLByAppendingPathComponent:@"Contents/MacOS/Plask"] path];

  NSTask* task = [[NSTask alloc] init];
  [task setLaunchPath:plaskpath];
  [task setArguments:[NSArray arrayWithObject:[abs_url path]]];
  [task setStandardError:p_stderr];
  [task setStandardOutput:p_stdout];
  // TODO(deanm): It's maybe not a good idea to let stdin be inherited.
  [task launch];

  // TODO(deanm): Yeah, probably shouldn't leak the task.

  return [[[MyDocument alloc] init] autorelease];
}

@end

int main(int argc, char** argv) {
  [[AntiDocumentController alloc] init];
  return NSApplicationMain(argc, (const char **)argv);
}
