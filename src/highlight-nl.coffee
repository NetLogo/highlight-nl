Prism = require('prismjs')

{ commands, constants, keywords, reporters } = require('./netlogo-syntax-constants')

notWordCh = /[\s\[\(\]\)]/.source
wordCh    = /[^\s\[\(\]\)]/.source
wordEnd   = "(?=#{notWordCh}|$)"

wordRegEx   = (pattern) -> new RegExp("#{pattern}#{wordEnd}", 'i')
memberRegEx = (words)   -> wordRegEx("(?:#{words.join('|')})")

keywordRegex = (->
  normalKeyword = memberRegEx(keywords).source
  xsOwn         = wordRegEx("#{wordCh}*-own").source
  new RegExp("#{normalKeyword}|#{xsOwn}", 'i')
)()

NetLogo = {
  comment:  { pattern: /(^|[^\\]);.*/, lookbehind: true }
, string:   { pattern: /"(?:[^\\]|\\.)*?"/, greedy: true }
, command:  memberRegEx(commands)
, constant: memberRegEx(constants)
, keyword:  keywordRegex
, number:   /0x[a-f\d]+|[-+]?(?:\.\d+|\d+\.?\d*)(?:e[-+]?\d+)?/i
, reporter: memberRegEx(reporters)
, variable: new RegExp(wordCh + "+")
}

# String -> String
module.exports = (code) -> Prism.highlight(code, NetLogo)
