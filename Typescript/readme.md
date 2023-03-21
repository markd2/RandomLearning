# Typescript

Typescript has been coming up fairly often.  Might be time to look in to it.

Asked someone I trust about TS (and React) suggestions.


* https://www.typescriptlang.org/docs/ - Nothing like the original docs
  - since coming from a C-background, https://www.typescriptlang.org/docs/handbook/typescript-in-5-minutes-oop.html would be a good start
* https://vitejs.dev/ - setting up a TS app is more complex than a JS
  app, so use a tool to help with that. Vite recommended.

* https://www.theodinproject.com/ - Odin Project for React learning (via full-stack path)
  - start off by teaching the old _Class Component_ version of React,
    which is important because you can still run into that code
    today. Then they teach the modern _Functional Component_ version of
    react that uses _Hooks_.
  - https://www.youtube.com/@WebDevSimplified is a recommended channel

* Specific advice
  - Don't get hung up on creating types for everything, you only need
    to type things that TS can't figure out on its own.
  - Stay away from TS Interfaces, they're a poor implementation of
    what interfaces should be
  - The React team no longer encourages using create-react-app to
    start a project (the tool they built), they recommend Vite for
    single page apps, and Next (https://nextjs.org/) for full stack
    apps.
    * that'd be really rich, going from NeXT to Next...
  - In React, stick with Functional Components and get good with
    Hooks. Learn how to make your own Hooks if you can.

