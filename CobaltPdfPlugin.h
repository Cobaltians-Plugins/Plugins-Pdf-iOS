/*
* CobaltPdfPlugin.h
* Cobalt
*
* The MIT License (MIT)
*
* Copyright (c) 2014 Cobaltians
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*
*/

#import <Cobalt/CobaltAbstractPlugin.h>
#import <SafariServices/SafariServices.h>
#import <UIKit/UIKit.h>

#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)
#define IS_OS_5_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
#define IS_OS_6_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define IS_OS_8_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define IS_OS_9_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)

// modify tokens here and in PdfTokens.java (android) to modify javascript syntax
// source of files
#define kAPITokenSource @"source"
#define kAPITokenPath @"path"
#define kAPITokenLocal @"local"
#define kAPITokenRemote @"url"
// commons fields
#define kAPITokenTitle @"title"
#define kAPITokenDetail @"detail"

@interface CobaltPdfPlugin: CobaltAbstractPlugin <SFSafariViewControllerDelegate, UIDocumentInteractionControllerDelegate>
@property (weak, nonatomic) CobaltViewController *viewController;
@property (strong, nonatomic) NSArray *tokens;
@property (weak, nonatomic) NSDictionary *filedata;
@end
