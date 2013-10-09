UITableViewCell-Label-Resizing-For-iOS7
=======================================

Pesky UITableViewCell's blocking your resizing? Don't sing the blues, **we've got your fix**!

After battling for literally hours to get the new <code>boundingRectWithSize:attributes:options:context</code> method working to replace the deprecated (and beautifully simple, mind you) <code>sizeWithFont:constrainedToSize:lineBreakMode:</code> method, we decided to Open Source our solution. This is absolutely cumbersome, but it future-proof's your apps and their various deprecated methods for something as mundane as fitting a UILabel into a UITableViewCell.

