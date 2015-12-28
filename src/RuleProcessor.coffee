module.exports = class RuleProcessor
  rule:
    name: 'prefer_english_operator_streamline'
    description: '''
    This rule prohibits `&&`, `||`, `==`, `!=` and `!`.
    Use `and`, `or`, `is`, `isnt`, and `not` instead.
    Using `!!` for converting to a boolean is ignored.
    Using `!_` for Streamline.js futures is ignored.
    '''
    level: 'ignore'
    doubleNotLevel: 'ignore'
    message: 'Don’t use `&&`, `||`, `==`, `!=`, or `!`'

  tokens: ['COMPARE', 'UNARY_MATH', 'LOGIC']
  lintToken: (token, tokenApi) ->
    config = tokenApi.config[@rule.name]
    level = config.level
    # Compare the actual token with the lexed token.
    {first_column, last_column} = token[2]
    line = tokenApi.lines[tokenApi.lineNumber]
    actual_token = line[first_column..last_column]
    context =
      switch actual_token
        when '==' then 'Replace `==` with `is`'
        when '!=' then 'Replace `!=` with `isnt`'
        when '||' then 'Replace `||` with `or`'
        when '&&' then 'Replace `&&` with `and`'
        when '!'
          # `not not expression` seems awkward, so `!!expression`
          # gets special handling.
          followingToken = tokenApi.peek 1
          precedingToken = tokenApi.peek -1
          if followingToken?[0] is 'UNARY_MATH'
            level = config.doubleNotLevel
            '`?` is usually better than `!!`'
          else if precedingToken?[0] is 'UNARY_MATH'
            # Ignore the 2nd half of the double not
            null
          else if followingToken?[1] is '_'
            null
          else
            'Replace `!` with `not`'
        else
          null

    if context?
      { level, context }
