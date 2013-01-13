// Copied from https://gist.github.com/3430542

Prism.languages.haml = {
  'string': /("|')(\\?.)*?\1/g,
  'comment': /\/[^\r\n]*(\r?\n|$)/g,
  'boolean': /\b(true|false)\b/g,
  'number': /\b-?(0x)?\d*\.?\d+\b/g,
  'tag': /%[a-zA-Z_0-9]*\b/g,
  'var': /[@&]\b[a-zA-Z_0-9]*[?!]?\b/g,
  'operator': /[-+]{1,2}|!|={1,2}|(&amp;){1,2}|\|?\||\?|\*|\//g,
  'rails': /(form_tag|do|end|link_to|image_tag|content_for)/g,
  'ignore': /&(lt|gt|amp);/gi
};