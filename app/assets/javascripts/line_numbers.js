// Based on the line number plugin for Prism.js
// https://github.com/LeaVerou/prism/blob/gh-pages/plugins/line-numbers/prism-line-numbers.js
(function(){
  // getElementsByTagName() doesn't natively support forEach().
  // https://gist.github.com/DavidBruant/1016007
  NodeList.prototype.forEach = Array.prototype.forEach;
  HTMLCollection.prototype.forEach = Array.prototype.forEach;

  var tags = document.getElementsByTagName('code');
  tags.forEach(function(code) {
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
  });
})();