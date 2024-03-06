# TriForkApp


- SwiftUI
- MVVM architecture pattern & POP
- Combine
- Connectivity control in order to check network connection

*Usage:

- When you start the app, the first fifteen results of current GitHub Organizations are displayed. By scrolling, more organizations are loaded according to pagination (Infinite scrolling).
- When you start editing/searching in the upper Textfield, the app will show the repositories of the organization searched in the search Textfield dynamically and sorted from largest to smaller size in bytes. As with showing the organizations, as you scroll over the list of repositories shown, the app will load more results (repositories of that organization) according to pagination (Infinite scrolling).
- If a search is being performed in the Textfield, all the text is deleted and we press Return on the keyboard, the first fifteen current Github organizations are shown again

 
