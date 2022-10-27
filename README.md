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

## Outro
It was a good coding task that makes sense. I had fun and interest in tipping my feets in MVVM for an iOS App.
