# My Time

This IOS app is intended to make your life more efficient. It serves to not only keep track of the events in your day but to schedule in your assignments for you into the day. The app allows you to add events based on length, name, and date/time which it will put in the calendar in green, but it also allows you to input a to do based on name, time needed, and due date which it then will schedule in to your calendar in yellow in the first time slot large enough for the time needed from the current time to the due date. If the due date is before the current time, it will not schedule the to do, but if the due date is after the current time and there is no time available, it will schedule the assignment at the next available time (better to turn it in late than not at all!).

In order to run the app on the computer, open 'My Time Final.xcodeproj' in xcode and hit the play button in the corner. In order to open this however with all of its dependencies, you must select 'Open another project' and then select the entire folder entitled 'My Time (SQL)'. You should see a folder layout on the lefthand side with both the blueprint 'My Time Final' icon dropdown as well as the blueprint 'Pods' icon dropdown. The app was built based on an iPhone 6s, so this would be the best simulator to run the app on. To select a schema,  click the drop down before the arrow next to the play and stop buttons (top left corner) and select the name of the project as your schema which should have the app icon next to it. If you see a settings symbol or something else, click 'Manage schema' and add the suggested schema, which should be the name of the app.

The app will open on January 2017 (the calendar is hard set to begin there and end in December of 2018 for sample purposes). From there, you can swipe right to navigate to different months as well as the following year with the month and year and dates updating accordingly. To view the events and to-dos for a certain date, simply click on that day in the calendar. None will be there at the start, but you can add some! In order to add an event, navigate to the add page by clicking on the bottom right '+' icon. This will bring you to the Add Event page. From there, you can enter the title of your event, the length of the event in hours, and the date/time of the event. You can also toggle the switch to make an event repeating and enter the number of weeks you want it to repeat.

Next, if you would like to add a To Do, simply click the word 'To Do' in the upper left corner to switch between templates to the Add To Do page. From there, you can enter the title of your assignment, the time you need in hours, and the date/time that the assignment is due. The app will look from the current time to the due date and slot in your assignment in the first slot of time large enough that it finds and display the to do as "work on {name of assignment} due {due date of assignment} at {time scheduled to do assignment}". This will ensure that you will not be overbooked and will have enough time to complete your assignments before the due date.

Finally, if you would like to delete an event or assignment, swipe left on the cell to reveal the delete button and click it. Any additions or deletions you make when you open the app will persist even after you close the app and run it again. Schedule to your heart's delight!