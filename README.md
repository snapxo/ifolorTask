# ifolorTask
Coding task for ifolor

## Motivation
I am used to work with MVP architectures. But since the ifolor project uses MVVM, I wanted to provide two small Apps for this coding task.

## Work
- General research about MVVM for iOS (~1h)
- ifolorMVVM (2h30)
- ifolorMVP (1h) > went really fast since I know the architecture and could copy the UI and logic from the other App
- README, polishing & some more unit tests (40min)

## General observations
### Navigation
The navigation was kept (over-)simplified. I choose just to present the confirmation screen over the registration.
This still goes through my router, where I would implement more complex navigations. Most certianly sub-dividing it into several sub-routers.

### Unit Testing
Given my lack of experience regarding unit testing, I only integrated very basic verification of my validation logic.

### Dependency injection
For the sake of demonstration, I managed the registration of the user in a very simple service in the MVP solution.
Shall I need to use this service (or any other), i would just pass my dependency manager along to my presenter.

### Store and Strings
I am used to generate my assets using swiftgen to make them type safe. My String files replicates the use I would have of it, without setting the whole localization of the App.
For persisting the user, I use a property wrapper to make the encoding and decoding in the UserDefaults more elegant.

## Biggest Challenge in MVVM
My biggest struggle came from the navigation, since I'm not yet very familiar with the MVVM.
I was split between managing my navigation by subscribing to the $isRegistered of my viewModel but I ran into small synchronisation issues.
This is why I ended up managing it with actions whose callbacks are defined at the init of my screens.

## Known issues, missing features
- Should you be born on the 1.1.1900, you would have to first select another date before selecting back your birthdate for the datePicker to notify for its valueChanged. This comes from the fact that I set minimum and maximal dates for my date picker, whose initial currentDate shall not be nil and must be within its bounds.
- I first wanted to implement UI feedback with hint and border colors. Although this would take maximal 30 min (given the simplicity of the UI, i would just add a label to the stack view and set isHidden), I would have to validate every field individually and I thought that it would imper the simplicity of the project.
- My keyboard handler does not support well the suggestion keyboard accessory view instantaneous hide/show, and therefore glitches whilst changing from one textfield to another with suggestions.
- I should have managed the responders, not requiring the user to clic on each textfield. But I would have again to validate each field and jump to the missing valid input textfield. I did not have enough time.

## Outro
It was a good coding task that makes sense. I had fun and interest in tipping my feets in MVVM for an iOS App.
