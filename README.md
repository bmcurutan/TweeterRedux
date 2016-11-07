# Project 4 - Tweeter Redux

Time spent: 20 hours spent in total

## User Stories

The following **required** functionality is completed:

- [x] Hamburger menu
   - [x] Dragging anywhere in the view should reveal the menu.
   - [x] The menu should include links to your profile, the home timeline, and the mentions view.
   - [x] The menu can look similar to the example or feel free to take liberty with the UI.
- [x] Profile page
   - [x] Contains the user header view
   - [x] Contains a section with the users basic stats: # tweets, # following, # followers
   - [x] Shows the users timeline
- [x] Home Timeline
   - [x] Tapping on a user image should bring up that user's profile page

The following **optional** features are implemented:

- [x] Profile Page
   - [x] Implement the paging view for the user description.
   - [x] As the paging view moves, increase the opacity of the background screen. See the actual Twitter app for this effect
   - [x] Pulling down the profile page should blur and resize the header image.
- [x] Account switching
   - [x] Long press on tab bar to bring up Account view with animation
   - [ ] Tap account to switch to
   - [ ] Include a plus button to Add an Account
   - [x] Swipe to delete an account

The following **additional** features are implemented:

- [x] Tap gesture recognizer "outside" of presented modal to dismiss it
- [x] Customized navigation bar colors and hamburger menu
- [x] Added more animations 
- [x] Tap to open and dismiss hamburger menu (not just swipe gestures)

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

  1. Better ways to implement controller layer between model and view so as to use the same view with multiple models.
  2. Way to implement multiple account authentication and switching for OAuth


## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='http://i.imgur.com/FgrG1zI.gif' title='Tweeter Redux Video Walkthrough' width='' alt='Tweeter Redux Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

- Faced some challenges implementing the controller layer between model and view so as to use the same view with multiple models
- Some challenges with what I thought were UI navigation bugs when using the hamburger menu in lieu of the tab bar or nav bar (i.e., built-in iOS functionality); but it ended up being logical errors in how the data was being presented
- Some difficulties implementing gesture recognizers on certain types of views (e.g., UIButton)
- There's more duplicate logic and code here than I'd like due to time pressures to complete the assignment tasks

## Icons

- Icons made by [Elegant Themes](http://www.flaticon.com/authors/elegant-themes) from [Flaticon](http://www.flaticon.com) 
- Icons made by [Icon Works](http://www.flaticon.com/authors/icon-works) from [Flaticon](http://www.flaticon.com)
- Icons made by [ionicons](http://ionicons.com/) from [ICONFINDER](http://www.iconfinder.com)

## License

    Copyright 2016 Bianca Curutan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
