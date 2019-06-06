/*
 * CobaltPdfPlugin.m
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

#import "CobaltPdfPlugin.h"
#import <Cobalt/PubSub.h>

@implementation CobaltPdfPlugin

- (void)onMessageFromWebView:(WebViewType)webView
          inCobaltController:(nonnull CobaltViewController *)viewController
                  withAction:(nonnull NSString *)action
                        data:(nullable NSDictionary *)data
          andCallbackChannel:(nullable NSString *)callbackChannel{
    
    if ([action isEqualToString:@"pdf"]) {
        if (DEBUG_COBALT) NSLog(@"PdfPlugin received data %@", data.description);

        // prepare data
        _viewController = viewController;
        // add defined tokens
        _tokens = @[kAPITokenSource,
                    kAPITokenPath,
                    kAPITokenLocal,
                    kAPITokenRemote,
                    kAPITokenTitle,
                    kAPITokenDetail];

        _filedata = data;
        if (_filedata == NULL || _filedata.count == 0) {
            NSLog(@"Error while parsing pdf data, check your javascript.");
            return;
        }
        if (DEBUG_COBALT) NSLog(@"PdfPlugin input parsing done: %@", _filedata.description);

        // open Remote Pdf
        NSString *source = [_filedata objectForKey:kAPITokenSource];
        if ([source isEqualToString:kAPITokenRemote]) {
            // get url
            NSURL *url = [NSURL URLWithString:[_filedata objectForKey:kAPITokenPath]];
            // check iOS version
            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
                SFSafariViewController *svc = [[SFSafariViewController alloc] initWithURL:url];
                svc.delegate = self;
                [viewController presentViewController:svc animated:YES completion:nil];
            } else if (SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(@"8.9")) { // version 0 to 8.9
                [[UIApplication sharedApplication] openURL:url];
            }
        } else if ([source isEqualToString:kAPITokenLocal]) { // open Local Pdf
            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"3.2")) {
                [self previewDocument:[_filedata objectForKey:kAPITokenPath]];
            }
            // can't open pdf
        }

        [[PubSub sharedInstance] publishMessage:nil
                                      toChannel:callbackChannel];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark  safari methods

////////////////////////////////////////////////////////////////////////////////////////////////

- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller {
    [controller dismissViewControllerAnimated:true completion:nil];
}

////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark  documentInteractionController methods

////////////////////////////////////////////////////////////////////////////////////////////////

- (void)previewDocument:(NSString*)path {
    NSString* fileName = [[path lastPathComponent] stringByDeletingPathExtension];
    if (fileName) {
        UIDocumentInteractionController *docController = [UIDocumentInteractionController  interactionControllerWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:fileName ofType:@"pdf"]]];
        docController.delegate = self;
        [docController presentPreviewAnimated:YES];
    }
}

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller {
    return _viewController;
}

- (UIView *)documentInteractionControllerViewForPreview:(UIDocumentInteractionController *)controller {
    return _viewController.view;
}

- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController *)controller {
    return _viewController.view.frame;
}
- (BOOL)documentInteractionController:(UIDocumentInteractionController *)controller   canPerformAction:(SEL)action{
    return FALSE;
}

@end
