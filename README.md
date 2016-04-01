# FOURSQUARE-integration-iOS

You can run this by cloning the project and opening with XCode.

Obviously it's best run on a device, and is an iPhone only application (due to time constraints).

I've opted to use objective-c as I've spent 95% of my iOS development time coding in it; I am more fluent and felt I could produce more work by using it.

I tried to put an emphasis on building solid foundations, which took the majority of the time. I tried to take an approach whereby there are few dependencies (lots of protocols). The main view controller implements the core components (table, api requests, navigation), and passes messages/data between these to function as a whole.

If I had more time I would have probably taken A BDD approach and used unit tests as a foundation. In the same regard I didn't want to spend too much time setting up bots and xcode server to automate testing while pushing to github.

My networking code is quite felxible and has been designed to handle many more functions. It might seem a bit busy for this simple task.

Future tasks:
I like the idea of creating a watchkit extension to send walking directions to the user. I would also create an SQLite implementation for persisting searches.

If you have any more questions please don't hesitate to raise them as issues.
