# Mobile Developer Coding Challenge

# Audiobooks.com Flowchart 
![Alt text](/Images/Flowchart-Audiobooks.png "Audiobooks Flowchart")

# Audiobooks.com Dependency Diagram:

![Alt text](/Images/Podcasts-dependency-diagram.png "Audiobooks Overview")


## Important:
To run the project on a simulator or a device, select `PodcastViewControllerTests` target.
To run tests, choose the appropriate test schemes. 
To run all the tests, choose CI scheme.

### TDD Flow:
```
User launches app -> Expects to see latest podcasts fetched from internet
App makes a request to the backend -> If response is succeess -> Decodes data -> Displays to user
-> If request is not succesful -> Shows an error message
```

```
For persistence store, I have created an abstract interface with a collaborator 
which can be easily replaced by any framework that we want to use. 
By using interface for persisting user favourite podcast, we can
inverse the dependency on the framework that we want to use. 
Currently I am using `UserDefaults` as the project requires only
peristing the podcast's ID. 
```

## Persistence Store:
- ✅ Details screen opened -> Checks if a podcast is favourited or not
- ✅ Details screen opened -> User clicks on Favourite Button when podcast is not already favourited -> Saves to Favourite 
and title changes to "Favourited"
- ✅ Details screen opened -> User clicks on Favourite button when podcast is already favourited -> Removes from Favourite


## Testing Pointer #1:
- ✅ Assert that `PodcastLoader` doesn't make a request to client on init
- ✅ Assert that `PodcastLoader` only makes request to client on `load` invocation
- ✅ Assert that `PodcastLoader` fails with same errors as client
- ✅ Assert that `PodcastLoader` can map data from client to correct `Podcast` objects from dummy JSON file
- ✅ Assert that `PodcastLoaderAPI` can fetch data from backend server and process it to display to user

## Testing Pointer #2:
- ✅ Assert that `PodcastDetailViewController` shows correct title of the podcast
- ✅ Assert that `PodcastDetailViewController` shows correct author of the podcast
- ✅ Assert that `PodcastDetailViewController` shows correct thumbnail of the podcast
- ✅ Assert that `PodcastDetailViewController` shows correct description of the podcast

Please read the instructions below carefully before starting the coding challenge.

Once submitted, the mobile team will review your work and get back to you as soon as possible.

## The Goal

You will be building a simple two-screen podcasts app. A basic mockup is provided below:

[![](https://i.imgur.com/yi8w1s8.png)](https://i.imgur.com/yi8w1s8.png)

#### Screen 1

- ✅ Show a list of podcasts using the endpoint provided below.
- ✅ Each list item should show the podcast thumbnail, title, and publisher name.
- ✅ Leave some space for the "Favourited" label (refer to the second podcast in the list in the mockup above).
- ✅ Show the Favourited label only if the podcast has been favourited, otherwise hide the label.

#### Screen 2

- ✅ Tapping on a list item from Screen 1 should bring you to Screen 2.
- ✅ On Screen 2, show the podcast's title, publisher name, thumbnail, and description.
- ✅ Add a Favourite button.
- ✅ The Favourite button should have two states: Favourite and Favourited.
- ✅ When tapping the Favourite button, the label should change to Favourited, and vice-versa.

## Details

- ✅ Fork this repo and keep it public until we've been able to review it.
- ✅ Can be written in either Java or Kotlin for Android applicants, and Objective-C or Swift for iOS applicants.
- ✅ For the API, use data provided by Listen Notes:
     - ✅ Use the following endpoint to fetch podcast data: https://www.listennotes.com/api/docs/?lang=kotlin&test=1#get-api-v2-best_podcasts
     - ✅ No API key required, you can simply use the mock server to fetch test data. [More information here](https://www.listennotes.help/article/48-how-to-test-the-podcast-api-without-an-api-key "More information here").
- ✅ Focus on implementing the app in portrait orientation only.
- ✅ The list should support pagination, loading 10 items at a time.

## The Evaluation

Your code will be evaluated based on the following criteria:

- [X] The code should compile.
- [X] No crashes, bugs, or compiler warnings.
- [X] App operates as outlined above.
- [X] Conforms to modern development principles.
- [X] Code is easy to understand. Bonus points for documentation.
- [X] Commit history is consistent, easy to follow and understand.
