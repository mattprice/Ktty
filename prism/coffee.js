// Copied from https://gist.github.com/3430542

Prism.languages.coffee = {
  'string': /("|')(\\?.)*?\1/g,
  'comment': /#[^\r\n]*(\r?\n|$)/g,
  'regex': {
    pattern: /(^|[^/])\/(?!\/)(\[.+?]|\\.|[^/\r\n])+\/[gim]{0,3}(?=\s*($|[\r\n,.;})]))/g,
    lookbehind: true
  },
  'boolean': /\b(true|false)\b/g,
  'number': /\b-?(0x)?\d*\.?\d+\b/g,
  'arrow': /(-|=)&gt;/g,
  'operator': /[-+]{1,2}|!|={1,2}|(&amp;){1,2}|\|?\||\?|\*|\//g,
  'var': /[@&]\b[a-zA-Z_][a-zA-Z_0-9]*[?!]?\b/g,
  'class': /\b[A-Z][a-zA-Z_0-9]*[?!]?\b/g,
  'ignore': /&(lt|gt|amp);/gi,
  'punctuation': /[{}[\];(),.:]/g
};