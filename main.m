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
#import "MyDocument.h"

BOOL g_launched_document = NO;

@interface AntiDocumentController : NSDocumentController {
}
@end

@implementation AntiDocumentController

-(id)openDocumentWithContentsOfURL:(NSURL *)abs_url
    display:(BOOL)displayDocument
    error:(NSError **)outError {
  g_launched_document = YES;
  NSString* plaskpath = 
      [[[[NSBundle mainBundle] URLForResource:@"Plask" withExtension:@"app"]
          URLByAppendingPathComponent:@"Contents/MacOS/Plask"] path];
  NSTask* task = [NSTask launchedTaskWithLaunchPath:plaskpath
                    arguments:[NSArray arrayWithObject:[abs_url path]]];  
  return [[[MyDocument alloc] init] autorelease];
}

@end

int main(int argc, char** argv) {
  [[AntiDocumentController alloc] init];
  return NSApplicationMain(argc, (const char **)argv);
}