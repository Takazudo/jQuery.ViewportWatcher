# jQuery.viewportWatcher

handle window's width change for responsive web design.

## Demos

* [basic](http://takazudo.github.io/jQuery.viewportWatcher/demos/1/)

## Usage

```javascript
var watcher = new $.ViewportWatcher(function(o) {

  o.when(function(width) {
    if(width < 800) { return true; }
    return false;
  }, function() {
    doSomething();
  });

  o.when(function(width) {
    if(800 <= width) { return true; }
    return false;
  }, function() {
    doSomething();
  });

});
```

see demos for details

## Depends

* [EveEve](https://github.com/Takazudo/EveEve)
* [viewportSize](https://github.com/tysonmatanich/viewportSize)
* jQuery 1.10.2

## Browsers

IE6+ and other new browsers.  

## How to build

git clone, then `git submodule init`, `git submodule update`.  
Then, `grunt` to build or `grunt watch` to watch coffee file's change.

## License

Copyright (c) 2013 "Takazudo" Takeshi Takatsudo  
Licensed under the MIT license.

## Build

Use

 * [CoffeeScript][coffeescript]
 * [grunt][grunt]

[coffeescript]: http://coffeescript.org "CoffeeScript"
[grunt]: http://gruntjs.com "grunt"
