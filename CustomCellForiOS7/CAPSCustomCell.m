//  Copyright (c) 2013 The Board of Trustees of The University of Alabama
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions
//  are met:
//
//  1. Redistributions of source code must retain the above copyright
//  notice, this list of conditions and the following disclaimer.
//  2. Redistributions in binary form must reproduce the above copyright
//  notice, this list of conditions and the following disclaimer in the
//  documentation and/or other materials provided with the distribution.
//  3. Neither the name of the University nor the names of the contributors
//  may be used to endorse or promote products derived from this software
//  without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
//  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
//  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
//  FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
//  THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
//  INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//   SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
//  HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
//  STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
//  OF THE POSSIBILITY OF SUCH DAMAGE.

#import "CAPSCustomCell.h"

@implementation CAPSCustomCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - Create Attributed String
+ (NSMutableAttributedString *)attributedStringFromLoremIpsum:(NSString *)loremIpsum {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:loremIpsum];
    // Add Background Color for Smooth rendering
    [attributedString setAttributes:@{NSBackgroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(0, attributedString.length)];
    // Add Main Font Color
    [attributedString setAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0.23 alpha:1.0]} range:NSMakeRange(0, attributedString.length)];
    // Add paragraph style
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
    [attributedString setAttributes:@{NSParagraphStyleAttributeName:paragraphStyle} range:NSMakeRange(0, attributedString.length)];
    // Add Font
    [attributedString setAttributes:@{NSFontAttributeName:[CAPSCustomCell customCellFont]} range:NSMakeRange(0, attributedString.length)];
    // Add Font Color for "Lorem" string
    [attributedString setAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:[loremIpsum rangeOfString:@"Lorem"]];
    
    // Return the string
    return attributedString;
}


#pragma mark - System Font
+ (UIFont *)customCellFont {
    return [UIFont systemFontOfSize:17];
}


#pragma mark - Set Cell Content
- (void)setCellContentWithLoremIpsumString:(NSString *)loremIpsum {
    //
    // THIS IS IMPORTANT!
    //  - The separator insets start your cell off at xOrigin = 15, instead of 0
    //  - like in iOS 6 and lower. Calling responds to selector means this won't break
    //  - in iOS 6 and lower either!
    //
    if ([self respondsToSelector:@selector(separatorInset)]) {
        self.separatorInset = UIEdgeInsetsZero;
    }
    
    // THIS IS ALSO IMPORTANT!
    // - You need to make sure the label's line # is set to 0 (aka any amount)
    self.resizeLabel.numberOfLines = 0;
    
    // Set Attributed String
    [self.resizeLabel setAttributedText:[CAPSCustomCell attributedStringFromLoremIpsum:loremIpsum]];
    
    
    // We want the label to appear inside of the cell with 10px padding on each side like so:
    //   ---------------------------------
    //  |                                 |
    //  | LABEL BEGINS HERE AND ENDS HERE |
    //  | UNLESS IT ENCOMPASSES MORE THAN |
    //  | ONE LINE!                       |
    //  |                                 |
    //   ---------------------------------
    
    
    // Get Size from String
    // - if the string responds to selector "boundingRectForSize:", then we are on iOS6+
    // - else, use the deprecated "sizeWithFont:" method
    CGSize labelSize = CGSizeZero;
    if ([self.resizeLabel.attributedText respondsToSelector:@selector(boundingRectWithSize:options:context:)]) {
        CGRect boundingRect = [self.resizeLabel.attributedText boundingRectWithSize:CGSizeMake(self.frame.size.width - 2*CAPSCustomCellHorizontalPad, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        labelSize = boundingRect.size;
    }
    else {
        labelSize = [loremIpsum sizeWithFont:[CAPSCustomCell customCellFont] constrainedToSize:CGSizeMake(self.frame.size.width - 2*CAPSCustomCellHorizontalPad, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    }
    
    
    // Set the heights of the frame and label now!
    self.resizeLabel.frame = CGRectMake(CAPSCustomCellHorizontalPad, CAPSCustomCellVerticalPad, self.frame.size.width - 2*CAPSCustomCellHorizontalPad, ceilf(labelSize.height));
    self.frame = CGRectMake(0, 0, self.frame.size.width, self.resizeLabel.frame.size.height + 2*CAPSCustomCellVerticalPad);
    if ([self respondsToSelector:@selector(contentView)]) {
        self.contentView.frame = self.frame;
    }
}


#pragma mark - Height for Cell
+ (float)heightForLoremIpsumString:(NSString *)loremIpsum tableView:(UITableView *)tableView {
    NSAttributedString *attributedLoremIpsum = [self attributedStringFromLoremIpsum:loremIpsum];
    
    // Get Size from String
    // - if the string responds to selector "boundingRectForSize:", then we are on iOS6+
    // - else, use the deprecated "sizeWithFont:" method
    CGSize labelSize = CGSizeZero;
    if ([attributedLoremIpsum respondsToSelector:@selector(boundingRectWithSize:options:context:)]) {
        CGRect boundingRect = [attributedLoremIpsum boundingRectWithSize:CGSizeMake(tableView.frame.size.width - 2*CAPSCustomCellHorizontalPad, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        labelSize = boundingRect.size;
    }
    else {
        labelSize = [loremIpsum sizeWithFont:[CAPSCustomCell customCellFont] constrainedToSize:CGSizeMake(tableView.frame.size.width - 2*CAPSCustomCellHorizontalPad, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    }
    
    // Return the calculated height of the label + 2 * the VerticalPadding (for top and bottom)
    return labelSize.height + 2*CAPSCustomCellVerticalPad;
}

@end
