# highlight-nl

## What Is It?

highlight-nl is a simple JavaScript library for performing in-browser syntax highlighting of NetLogo source code.

## Installation

  * Run `npm install`
  * Run `grunt`
  * Retrieve the built `.css` file and `.min.js` from the `dist` directory

## Usage

highlight-nl ships with a `.js` file and a `.css` file.  The `.js` file must be included in your page (`<script src="highlight-nl.js"></script>`) in order for the functions to be available.  The CSS file with the default NetLogo syntax highlighting scheme that is used in NetLogo and NetLogo Web can be included (`<link href="highlight-nl.css" rel="stylesheet" />`), but is not required.  If you wish to provide your own CSS for highlighting the elements, please see the [Custom CSS](#custom-css) section below.

Once the files are available on your page, you will need to access highlight-nl through JavaScript.  The function is distributed as a Browserify module, so it can be obtained by calling `require('highlight-nl')`. The function takes a string of NetLogo code as its only argument and returns a string of syntax-highlighted HTML.

## Example

```javascript
var highlightNL = require('highlight-nl');

// Get an element on the page with some code in it (highly recommended to be a `pre` element)
var codeElem = document.getElementById("nl-code");

// Store the highlighted HTML string
var html = highlightNL(codeElem.innerText);

// Replace the contents of the element with the syntax-highlighted equivalent
codeElem.innerHTML = html;
```

## Custom CSS

Should you wish to create your own color scheme, all that needs to be done is to provide your own definitions for the following CSS classes:

  * command (e.g. `create-turtles`, `show`)
  * comment
  * constant (e.g. `true`, `pi`, `nobody`, `red`)
  * keyword (e.g. `breed`, `to`, `end`, `globals`, `extensions`)
  * number
  * reporter (e.g. `!=`, `who`, `pxcor`, `word`)
  * string

## Terms of Use

[![CC0](http://i.creativecommons.org/p/zero/1.0/88x31.png)](http://creativecommons.org/publicdomain/zero/1.0/)

highlight-nl is in the public domain.  To the extent possible under law, Uri Wilensky has waived all copyright and related or neighboring rights.
