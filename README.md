# coffeelint-prefer-english-operator-streamline

This is a custom rule for [CoffeeLint] extending `prefer_english_operator` to
allow Streamline.js futures syntax (`!_`).

It disallows use of symbolic operators such as `==`, `!=`, `&&`, `||`, and `!`.
Instead, it recommends using `is`, `isnt`, `and`, `or`, and `not` instead.
Double not `!!` is allowed by default for boolean coercion but can be disallowed
via `doubleNotLevel` configuration.

```
a is a    # yes
a == a    # no

a isnt a  # yes
a != a    # no

a and b   # yes
a && b    # no

a or b    # yes
a || b    # no

!!a       # yes
not not a # yes

f !_      # yes

```

## How to Install

1.  Run `npm install --save-dev coffeelint-prefer-english-operator-streamline`.

## How to Use

In your `coffeelint.json`, add

```
{
  // other lint rules
  "prefer_english_operator_streamline": {
    "module": "coffeelint-prefer-english-operator-streamline",
    "level": "error"
  }
}
```

and run `coffeelint`.


### Acknowledgements

Forked from [coffeelint-prefer-english-operator] by [@parakeety].


[@parakeety]: https://github.com/parakeety
[coffeelint-prefer-english-operator]: https://github.com/parakeety/coffeelint-prefer-english-operator
[CoffeeLint]: http://www.coffeelint.org/
[Streamline.js]: https://github.com/Sage/streamlinejs
