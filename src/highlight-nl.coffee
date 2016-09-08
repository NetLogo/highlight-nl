Prism = require('prismjs')

{ commands, constants, keywords, reporters } = require('./netlogo-syntax-constants')

notWordCh = /[\s\[\(\]\)]/.source
wordCh    = /[^\s\[\(\]\)]/.source
wordEnd   = "(?=#{notWordCh}|$)"
wordStart = "(#{notWordCh}|^)"

wordRegEx   = (pattern) -> { pattern: new RegExp("#{wordStart}(#{pattern})#{wordEnd}", 'i'), lookbehind: true }
memberRegEx = (words)   -> wordRegEx("(?:#{words.join('|')})")

keywordRegex = (->
  normalKeyword = memberRegEx(keywords).pattern.source
  xsOwn         = wordRegEx("#{wordCh}*-own").pattern.source
  new RegExp("#{normalKeyword}|#{xsOwn}", 'i')
)()

NetLogo = {
  comment:  { pattern: /(^|[^\\]);.*/, lookbehind: true }
, string:   { pattern: /"(?:[^\\]|\\.)*?"/, greedy: true }
, keyword:  keywordRegex
, command:  memberRegEx(commands)
, reporter: memberRegEx(reporters)
, number:   wordRegEx(/0x[a-f\d]+|[-+]?(?:\.\d+|\d+\.?\d*)(?:e[-+]?\d+)?/.source)
, constant: memberRegEx(constants)
, variable: wordRegEx(wordCh + "+")
}

# String -> String
module.exports = (code) -> Prism.highlight(code, NetLogo)
