UITableViewCell and UILabel Resizing For iOS7 and the Future!
=======================================

Pesky UITableViewCells blocking your resizing? Don't sing the blues, **we've got your fix**!

After battling for literally hours to get the new <code>boundingRectWithSize:attributes:options:context</code> method working to replace the deprecated (and beautifully simple, mind you) <code>sizeWithFont:constrainedToSize:lineBreakMode:</code> method, we decided to Open Source our solution. This is absolutely cumbersome, but it future-proof's your apps and their various deprecated methods for something as mundane as fitting a UILabel into a UITableViewCell.

## So what's the darn deal!?

Basically, Apple decided to deprecate a beautiful method for making a UILabel fit its content around any NSString you throw at it. This used to be achieved by calling <code>sizeWithFont:constrainedToSize:lineBreakMode:</code> like this:

```objc
// Don't Use This Anymore! It's deprecated!
CGSize labelSize = [@"Hello World!" sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(label.frame.size.width,MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
```

And that's all you had to do! Those were the glory days, huh? Now, Apple seems to be pushing a strategy of UI development that relies more heavily on NSAttributedString versus the old NSString for displaying things like bold or underline font, special colors for different words, and paragraphs that automatically tab themselves. It's actually pretty awesome stuff - and extremely flexible and customizable. However, getting a UILabel to fit around one of these also got a lot more cumbersome, and a little harder to predict what will happen on screen until you spin the roulette wheel, build, and look for yourself.

The new method, <code>boundingRectWithSize:attributes:options:context</code>, returns a CGRect object to you now (with an origin of {0,0}, so a CGSize would have worked just the same...) that you can then determine how to manipulate your UILabel frame to fit all of the text inside. It's not too hard to get working correctly, there's just more set up that needs to happen to make sure that the attributes are in the correct order and have the minimum amount of things to work. Here's what you gotta' have to make this work, **and** in this order:

* NSForegroundColorAttributeName
* NSParagraphStyleAttributeName
* NSFontAttributeName

Now, say you want to add a background color to the label because it's more performant versus <code>[UIColor clearColor]</code>, you can't just append it on the end after the NSFontAttributeName - that messes everything up! Crazy right? You have to add it *before* every other attribute for this to work. Again, crazy right?

Let's just set up an attributed string and make the label fit that:

```objc
// Let's make an NSAttributedString first
NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"Hello World!"];
// Add Background Color for Smooth rendering
[attributedString setAttributes:@{NSBackgroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(0, attributedString.length)];
// Add Main Font Color
[attributedString setAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0.23 alpha:1.0]} range:NSMakeRange(0, attributedString.length)];
// Add paragraph style
NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
[paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
[attributedString setAttributes:@{NSParagraphStyleAttributeName:paragraphStyle} range:NSMakeRange(0, attributedString.length)];
// Add Font
[attributedString setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} range:NSMakeRange(0, attributedString.length)];
// And finally set the text on the label to use this
label.attributedText = attributedString;

// Phew. Now let's make the Bounding Rect
CGRect boundingRect = [attributedString boundingRectWithSize:CGSizeMake(label.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil];

// Now let's set the label size from there
label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y, boundingRect.size.width, boundingRect.size.height);
```

There we go! That wasn't too bad, we're done right?

Oh no we're not.

----------------------

## UITableViewCell is the big brother that barges into your room and steals your toys!

Pretty much. If you throw that code into your <code>UITableViewDataSource</code> methods for <code>tableView:cellForRowAtIndexPath:</code> and <code>tableView:heightForRowAtIndexPath:</code> you'll realize that without setting anything up for iOS 7, you're gonna' have a bad time. Because iOS 7 added something superfluous known as...

**Separator Insets!**

For some reason, when you add a new UITableView to your projects, they come with the default separatorInset property of <code>UIEdgeInsetMake(0,15,0,0)</code> and it is up to YOU as a developer to notice and change this. So, here's what you have to add (either in code, or do it in the .xib file yourself):

```objc
if ([tableView respondsToSelector:@selector(separatorInset)]) {
    tableView.separatorInset = UIEdgeInsetsZero;
}
```

Wrapping this call up in the if block protects your code if you have to be backwards compatible to pre-iOS7. Now we're done right? Nope. We have to do this in the UITableViewCell as well.

```objc
if ([cell respondsToSelector:@selector(separatorInset)]) {
    cell.separatorInset = UIEdgeInsetsZero;
}
```

Now we're done? YEP! Just set your labels' frames inside the custom cell how you used to before we had to go crazy with NSAttributedStrings, but use the new boundingRect size to do it.

----------------------

## License

Copyright (c) 2012 The Board of Trustees of The University of Alabama
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions
are met:

 1. Redistributions of source code must retain the above copyright
    notice, this list of conditions and the following disclaimer.
 2. Redistributions in binary form must reproduce the above copyright
    notice, this list of conditions and the following disclaimer in the
    documentation and/or other materials provided with the distribution.
 3. Neither the name of the University nor the names of the contributors
    may be used to endorse or promote products derived from this software
    without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
OF THE POSSIBILITY OF SUCH DAMAGE.
