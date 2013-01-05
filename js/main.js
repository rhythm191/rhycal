// Generated by CoffeeScript 1.4.0

/*
# メインとなるスクリプトファイル
*/


/*
# ファンクション
*/


(function() {
  var createBigStar, createMiddleStar, createPurpleStar, createRedMiddleStar, createRedSmallStar, createSmallStar, getRandomNum, getRandomOffset, getStarFactory;

  createSmallStar = function(x, y, offsetX, offsetY) {
    var circle;
    return circle = new Kinetic.Circle({
      x: x,
      y: y,
      radius: 1,
      offset: [offsetX, offsetY],
      fill: {
        start: {
          x: 0,
          y: 0,
          radius: 0
        },
        end: {
          x: 0,
          y: 0,
          radius: 1
        },
        colorStops: [0, 'white', 1, '#222222']
      }
    });
  };

  createMiddleStar = function(x, y, offsetX, offsetY) {
    var circle;
    return circle = new Kinetic.Circle({
      x: x,
      y: y,
      radius: 2,
      offset: [offsetX, offsetY],
      fill: {
        start: {
          x: 0,
          y: 0,
          radius: 0
        },
        end: {
          x: 0,
          y: 0,
          radius: 2
        },
        colorStops: [0, 'white', 1, '#222222']
      }
    });
  };

  createBigStar = function(x, y, offsetX, offsetY) {
    var circle;
    return circle = new Kinetic.Circle({
      x: x,
      y: y,
      radius: 4,
      offset: [offsetX, offsetY],
      fill: {
        start: {
          x: 0,
          y: 0,
          radius: 0
        },
        end: {
          x: 0,
          y: 0,
          radius: 4
        },
        colorStops: [0, 'white', 1, '#222222']
      }
    });
  };

  createPurpleStar = function(x, y, offsetX, offsetY) {
    var circle;
    return circle = new Kinetic.Circle({
      x: x,
      y: y,
      radius: 3,
      offset: [offsetX, offsetY],
      fill: {
        start: {
          x: 0,
          y: 0,
          radius: 0
        },
        end: {
          x: 0,
          y: 0,
          radius: 3
        },
        colorStops: [0, 'white', 1, '#620D7C']
      }
    });
  };

  createRedSmallStar = function(x, y, offsetX, offsetY) {
    var circle;
    return circle = new Kinetic.Circle({
      x: x,
      y: y,
      radius: 1,
      offset: [offsetX, offsetY],
      fill: {
        start: {
          x: 0,
          y: 0,
          radius: 0
        },
        end: {
          x: 0,
          y: 0,
          radius: 1
        },
        colorStops: [0, 'red', 1, '#222222']
      }
    });
  };

  createRedMiddleStar = function(x, y, offsetX, offsetY) {
    var circle;
    return circle = new Kinetic.Circle({
      x: x,
      y: y,
      radius: 2,
      offset: [offsetX, offsetY],
      fill: {
        start: {
          x: 0,
          y: 0,
          radius: 0
        },
        end: {
          x: 0,
          y: 0,
          radius: 2
        },
        colorStops: [0, 'red', 1, '#222222']
      }
    });
  };

  getRandomNum = function(max) {
    return Math.round(Math.random() * max);
  };

  getRandomOffset = function(min, max) {
    return Math.round(Math.random() * (max - min)) + min;
  };

  getStarFactory = function(starFactory, rate) {
    var i, now, num, rateAll, value, _i, _len;
    rateAll = 0;
    for (_i = 0, _len = rate.length; _i < _len; _i++) {
      num = rate[_i];
      rateAll += num;
    }
    value = getRandomNum(rateAll);
    now = 0;
    for (i in rate) {
      num = rate[i];
      now += num;
      if (value < now) {
        return starFactory[i];
      }
    }
    return starFactory[starFactory.length - 1];
  };

  jQuery(function($) {
    var $windowHeight, $windowMaxLength, $windowWidth, angularSpeed, anime, centerX, centerY, factory, i, ssLayer, stage, star, starFactory, starLayer, starNum, starRate, x, y, _i;
    $windowWidth = $(window).width();
    $windowHeight = $(window).height();
    $windowMaxLength = Math.sqrt($windowWidth * $windowWidth + $windowHeight * $windowHeight);
    centerX = $windowWidth / 2;
    centerY = $windowHeight / 2;
    starNum = ($windowMaxLength * $windowMaxLength) / 600;
    stage = new Kinetic.Stage({
      container: 'container',
      width: $windowWidth,
      height: $windowHeight
    });
    starLayer = new Kinetic.Layer();
    ssLayer = new Kinetic.Layer();
    starFactory = [createSmallStar, createMiddleStar, createBigStar, createPurpleStar, createRedSmallStar, createRedMiddleStar];
    starRate = [50, 30, 1, 1, 7, 1];
    for (i = _i = 0; 0 <= starNum ? _i <= starNum : _i >= starNum; i = 0 <= starNum ? ++_i : --_i) {
      factory = getStarFactory(starFactory, starRate);
      x = getRandomOffset(($windowWidth - $windowMaxLength) / 2, $windowMaxLength);
      y = getRandomOffset(($windowHeight - $windowMaxLength) / 2, $windowMaxLength);
      star = factory(centerX, centerY, centerX - x, centerY - y);
      starLayer.add(star);
    }
    stage.add(starLayer);
    stage.add(ssLayer);
    angularSpeed = Math.PI / 800;
    anime = new Kinetic.Animation(function(frame) {
      var angleDiff, children, node, _j, _len, _results;
      angleDiff = frame.timeDiff * angularSpeed / 1000;
      children = starLayer.getChildren();
      _results = [];
      for (_j = 0, _len = children.length; _j < _len; _j++) {
        node = children[_j];
        _results.push(node.rotate(angleDiff));
      }
      return _results;
    }, starLayer);
    return anime.start();
  });

}).call(this);