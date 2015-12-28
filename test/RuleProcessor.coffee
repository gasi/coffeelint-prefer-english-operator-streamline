assert = require 'assert'
coffeelint = require 'coffeelint'
PreferEnglishOperatorsStreamline = require '../src/RuleProcessor'
vows = require 'vows'


RULE = 'prefer_english_operator_streamline'
configError = {"#{RULE}": {level: 'error'}}
coffeelint.registerRule PreferEnglishOperatorsStreamline

vows.describe(RULE).addBatch({

  'non-English operators':
    'should warn when `==` is used': ->
      result = coffeelint.lint('1 == 1', configError)[0]
      assert.equal result.context, 'Replace `==` with `is`'

    'should warn when `!=` is used': ->
      result = coffeelint.lint('1 != 1', configError)[0]
      assert.equal result.context, 'Replace `!=` with `isnt`'

    'should warn when `&&` is used': ->
      result = coffeelint.lint('1 && 1', configError)[0]
      assert.equal result.context, 'Replace `&&` with `and`'

    'should warn when `||` is used': ->
      result = coffeelint.lint('1 || 1', configError)[0]
      assert.equal result.context, 'Replace `||` with `or`'

    'should warn when `!` is used': ->
      result = coffeelint.lint('x = !y', configError)[0]
      assert.equal result.context, 'Replace `!` with `not`'

  'double not (`!!`)':
    'is ignored by default': ->
      result = coffeelint.lint('x = !!y', configError)
      assert.equal(result.length, 0)

    'can be configured at an independent level': ->
      configError =
        "#{RULE}":
          level: 'error'
          doubleNotLevel: 'warn'

      result = coffeelint.lint('x = !!y', configError)
      assert.equal(result.length, 1)
      assert.equal(result[0].level, 'warn')
      assert.equal(result[0].rule, RULE)

  'Streamline.js future (`!_`)':
    'is ignored': ->
      result = coffeelint.lint('x = f !_', configError)
      assert.equal(result.length, 0)

  'English operators':
    'should not warn when \'is\' is used': ->
      assert.isEmpty(coffeelint.lint('1 is 1', configError))

    'should not warn when \'isnt\' is used': ->
      assert.isEmpty(coffeelint.lint('1 isnt 1', configError))

    'should not warn when \'and\' is used': ->
      assert.isEmpty(coffeelint.lint('1 and 1', configError))

    'should not warn when \'or\' is used': ->
      assert.isEmpty(coffeelint.lint('1 or 1', configError))

  'Comments':
    topic:
      '''
      # 1 == 1
      # 1 != 1
      # 1 && 1
      # 1 || 1
      # f !_

      ###
      1 == 1
      1 != 1
      1 && 1
      1 || 1
      f !_
      ###
      '''

    'should not warn when == is used in a comment': (source) ->
      assert.isEmpty(coffeelint.lint(source, configError))

  'Strings':
    'should not warn when == is used in a single-quote string': ->
      assert.isEmpty(coffeelint.lint('\'1 == 1\'', configError))

    'should not warn when == is used in a double-quote string': ->
      assert.isEmpty(coffeelint.lint('"1 == 1"', configError))

    'should not warn when == is used in a multiline string': ->
      source = '''
        """
        1 == 1
        """
        '''
      assert.isEmpty(coffeelint.lint(source, configError))

}).export(module)
