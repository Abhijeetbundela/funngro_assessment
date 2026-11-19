# Funngro take-home: Flutter

Hi, this is my submission for the Mobile Engineer (Flutter) assessment. The README has my written answers for Part 1 and 3, how to run the project and assumption and question. The video(Part 4) is sent separately. I used an AI tool (Claude).

## Running it

You need Flutter (Channel stable, 3.50.0)

```
flutter clean
flutter pub get
flutter analyze
flutter run
```

I used clean architecture with Bloc as state management, get_it for dependency injection and Dio for HTTP.

```
lib/
  core/          Result type, failures, error handling, Dio setup, currency formatter
  features/
    projects/    domain, data, presentation
    earnings/    domain, data, presentation
  injection_container.dart
```

- Presentation: the pages/UIs and the Blocs
- Domain: entities, repository interfaces and use cases. No Flutter, no Dio/Websocket here.
- Data: data sources (remote and local if needed) and the repository implementations.

## Part 1: the earnings screen

### Problems, worst first
**1. Fetching and listening inside `build()`.**
This is the worst one. `build()` can run any time: after every `setState`, Here it starts a fetch, the fetch calls `setState`, that calls `build()` again. So it loops forever and same for `.listen()` on the wallet stream, it never canceled as well, so listeners pile up.
Fix: fetch and subscribe once, keep the subscription, cancel it when the screen closes.

**2. `formatCurrency` for every row inside `build()`.**
It takes about 3 ms, and there are up to 3,000 rows, so roughly 9 seconds of work on the UI thread for one build, and that's on a fast phone and Rs 8,000 phone the screen would freeze.
Fix: format when the data arrives, with one shared `NumberFormat` (building it each time is the slow part). `build()` just reads the finished string.

**3. A `Column` inside a `SingleChildScrollView`.**
Flutter builds and lays out all 3,000 rows even though only about 8 are visible. That means a slow first frame, janky scrolling.
Fix: `ListView.builder`, which builds only what is on screen.

**4. No loading, error or empty state.**
`loading` starts as `false` and is never set to `true`, so the spinner never shows. Nothing handles errors from future or stream.

### Keeping the other 59 screens clean
Give everyone one screen template with a Bloc and the four states, so a new screen starts correct. Last, a small review checklist for subscriptions canceled, all states handled, nothing heavy in build() and ListView.builder for long lists.

## Part 3: crash after v6.4.0
## Message to the founder
Yes, let’s halt it. It takes a minute in Play Console, we can undo it anytime, the other 80% are fine on the old version. I’m checking today if the crash is from our release or from something else. I’ll tell you if we need a hotfix.

## Investigation plan for the day
Open the crash in Crashlytics and read the stack trace and check it is a dart PlatformException or a native crash? or fatal or ANRs? When did it start and how many devices or users? and also look for old versions crashes too, it’s probably not our release.

what these users or devices have in common: Android os version, phone brand, RAM.

The ad SDK didn’t change, so I’d look at what else did in 6.4.0. For example the Flutter or Gradle version, targetSdk, a plugin or new code.

For the decision, I’d halt first, because it’s cheap and users come first. If 6.3.x has the same crash, I’d continue the rollout. If it’s our bug and the fix is small, I’d release 6.4.1 at 5%, then 20%, and watch the crash-free rate. I’d only hold at 20% if it’s a small group of devices, it isn’t fatal, and I have a quick workaround.

What I wish I had is a Remote Config switch to turn ads off on resume, by app version, Android version or device. Then I could stop the crash in minutes without a release. And yes, I would have shipped it.

## Assumptions and questions

Assumptions:
- Page size is 20. A page shorter than 20 or empty, means the end of the list. So after page 7 the app makes one more request that returns an empty list.
- I don't know what formatCurrency really does, so I made one shared CurrencyFormatter (₹, en_IN) and created only once.

Questions:
1. Does the real API return hasMore or total, or should the app guess the end from a short page? Is the earnings list paginated on the server? 3,000 items in one response is a risk by itself.
2. What does formatCurrency do and other screens uses it?
3. Which low-end phone should we test on (Android version, RAM)?