// Based on the line numbers plugin for Prism.js
// https://github.com/LeaVerou/prism/blob/gh-pages/plugins/line-numbers/prism-line-numbers.js
(function(){
  var code = document.querySelector('code');
  var pre = code.parentNode;

  var linesNum = (1 + code.textContent.split('\n').length);
  var lineNumbersWrapper;

  lines = new Array(linesNum);
  lines = lines.join('<span></span>');

  lineNumbersWrapper = document.createElement('span');
  lineNumbersWrapper.className = 'line-numbers-rows';
  lineNumbersWrapper.innerHTML = lines;

  if (pre.hasAttribute('data-start')) {
    pre.style.counterReset = 'linenumber ' + (parseInt(pre.getAttribute('data-start'), 10) - 1);
  }

  code.appendChild(lineNumbersWrapper);
})();