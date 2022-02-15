# Relative Date Time Formatter

Needed to do a "two days ago", "yesterday", etc.  RelativeDateTimeFormatter
is the tool.

* https://developer.apple.com/documentation/foundation/relativedatetimeformatter
  - "A formatter that create local-aware string representations of a relative date or time"
  - Use as stand-o-lone strings, like "1 hour ago", "in 2 weeks", etc.  Embedding
    them in strings may grammatically incorrect be doing.

# Experiments

```
-432000 - 5 days ago
-3600 - 1 hour ago
-15 - 15 seconds ago
0 - in 0 seconds
15 - in 15 seconds
3600 - in 1 hour
14400 - in 4 hours
```

## Date Time Style

"the style to use when describing a relative date"

Default is .numeric
There's also .named
