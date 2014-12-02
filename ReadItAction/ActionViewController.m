//
//  ActionViewController.m
//  ReadItAction
//
//  Created by Lukas Petr on 11/28/14.
//  Copyright (c) 2014 Glimsoft. All rights reserved.
//

#import "ActionViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@import AVFoundation;


@interface ActionViewController ()

@property (nonatomic, strong) IBOutlet UITextView *textView;

@end

@implementation ActionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Get the item[s] we're handling from the extension context.
    // In our action extension, we only need one input item (text), so we use the first item from the array.
    NSExtensionItem *item = self.extensionContext.inputItems[0];
    NSItemProvider *itemProvider = item.attachments[0];
    
    if ([itemProvider hasItemConformingToTypeIdentifier:(NSString *)kUTTypePlainText]) {
        
        // It's a plain text!
        __weak UITextView *textView = self.textView;
        
        [itemProvider loadItemForTypeIdentifier:(NSString *)kUTTypePlainText options:nil completionHandler:^(NSString *item, NSError *error) {
            
            if (item) {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    
                    [textView setText:item];
                    
                    // Set up speech synthesizer and start it
                    AVSpeechSynthesizer *synthesizer = [[AVSpeechSynthesizer alloc]init];
                    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:textView.text];
                    [utterance setRate:0.1];
                    [synthesizer speakUtterance:utterance];
                }];
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)done {
    // Return any edited content to the host app.
    // This template doesn't do anything, so we just echo the passed in items.
    [self.extensionContext completeRequestReturningItems:self.extensionContext.inputItems completionHandler:nil];
}

@end
