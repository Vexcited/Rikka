# Rikka

## Motivation

At [LiterateInk](https://github.com/LiterateInk), we're rewriting some of our
TypeScript librairies in Swift, and in JS/TS we're using [Schwi](https://github.com/Vexcited/Schwi) to perform cross-runtime HTTP requests with a common API.

To make the maintenance between the languages easier, I've made this Swift library
that should be a one-to-one compatible API with Schwi.

## Features

- `toHTML()` helper on responses to directly parse the response as HTML using [SwiftSoup](https://github.com/scinfu/SwiftSoup)
- `getSetCookie()` on headers to retrieve each `Set-Cookie` header in an array

## Installation

The simplest way is to use the [Swift Package Manager](https://github.com/swiftlang/swift-package-manager).

You simply add the dependency to your `Package.swift` file.

```swift
Package(
  dependencies: [
    // You must add the following line.
    .package(url: "https://rad.vexcited.com/z3Cqe7gEqxdqkGsPSS7KnBwJBBu5s.git", from: "0.1.0"),
  ],
  targets: [
    .target(name: "YourTarget", dependencies: ["Rikka"]),
    //                                         ^^^^^^^
  ]
)
```

## Usage

```swift
import Rikka

let request = try HttpRequest.Builder("https://postman-echo.com/cookies/set")
  .setUrlSearchParameter("foo1", "bar1")
  .setUrlSearchParameter("foo2", "bar2")
  .setRedirection(.manual)
  .build();

let response = try await send(request);
print(response.headers.getSetCookie());

let body = response.toString();
print(body);
```
