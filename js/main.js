// Generated by CoffeeScript 1.4.0

/*
# メインとなるスクリプトファイル
*/


/*
# ファンクション
*/


(function() {
  var createBigStar, createMiddleStar, createPurpleStar, createRedMiddleStar, createRedSmallStar, createSmallStar, getRandomNum, getRandomOffset, getStarFactory;

  createSmallStar = function(x, y) {
    var circle;
    return circle = new Kinetic.Circle({
      x: x,
      y: y,
      radius: 1,
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

  createMiddleStar = function(x, y) {
    var circle;
    return circle = new Kinetic.Circle({
      x: x,
      y: y,
      radius: 2,
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

  createBigStar = function(x, y) {
    var circle;
    return circle = new Kinetic.Circle({
      x: x,
      y: y,
      radius: 4,
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

  createPurpleStar = function(x, y) {
    var circle;
    return circle = new Kinetic.Circle({
      x: x,
      y: y,
      radius: 3,
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

  createRedSmallStar = function(x, y) {
    var circle;
    return circle = new Kinetic.Circle({
      x: x,
      y: y,
      radius: 1,
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

  createRedMiddleStar = function(x, y) {
    var circle;
    return circle = new Kinetic.Circle({
      x: x,
      y: y,
      radius: 2,
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

  window.requestAnimationFrame = (function() {
    return window.requestAnimationFrame || window.webkitRequestAnimationFrame || window.mozRequestAnimationFrame || window.oRequestAnimationFrame || window.msRequestAnimationFrame || function(callback, element) {
      return window.setTimeout(callback, 1000 / 60);
    };
  })();

  jQuery(function($) {
    var $windowHeight, $windowMaxLength, $windowWidth, a, angularSpeed, anime, dayNum, ex, factory, i, shootingStar, shootingStarStart, shootingstarFunc, ssLayer, stage, star, starFactory, starLayer, starNum, starRate, x, y, _i;
    dayNum = new Date().getDate();
    $('#days').find('.numeric').not('.nextMonth').each(function() {
      if ($(this).text() === ("" + dayNum)) {
        return $(this).append('<span class="today">☆</span>');
      }
    });
    $windowWidth = $(window).width();
    $windowHeight = $(window).height();
    $windowMaxLength = Math.sqrt($windowWidth * $windowWidth + $windowHeight * $windowHeight);
    starNum = ($windowMaxLength * $windowMaxLength) / 1000;
    stage = new Kinetic.Stage({
      container: 'container',
      width: $windowWidth,
      height: $windowHeight
    });
    starLayer = new Kinetic.Layer({
      x: $windowWidth / 2,
      y: $windowHeight / 2,
      offset: [$windowWidth / 2, $windowHeight / 2]
    });
    ssLayer = new Kinetic.Layer();
    starFactory = [createSmallStar, createMiddleStar, createBigStar, createPurpleStar, createRedSmallStar, createRedMiddleStar];
    starRate = [50, 30, 1, 1, 7, 1];
    for (i = _i = 0; 0 <= starNum ? _i <= starNum : _i >= starNum; i = 0 <= starNum ? ++_i : --_i) {
      factory = getStarFactory(starFactory, starRate);
      x = getRandomOffset(($windowWidth - $windowMaxLength) / 2, $windowMaxLength);
      y = getRandomOffset(($windowHeight - $windowMaxLength) / 2, $windowMaxLength);
      star = factory(x, y);
      starLayer.add(star);
    }
    stage.add(starLayer);
    stage.add(ssLayer);
    angularSpeed = Math.PI / 800;
    anime = new Kinetic.Animation(function(frame) {
      var angleDiff;
      angleDiff = frame.timeDiff * angularSpeed / 1000;
      return starLayer.rotate(angleDiff);
    }, starLayer);
    anime.start();
    $(window).resize(function(e) {
      var _j;
      anime.stop();
      $windowWidth = $(window).width();
      $windowHeight = $(window).height();
      $windowMaxLength = Math.sqrt($windowWidth * $windowWidth + $windowHeight * $windowHeight);
      starNum = ($windowMaxLength * $windowMaxLength) / 1000;
      stage.setWidth($windowWidth);
      stage.setHeight($windowHeight);
      starLayer.rotate(0);
      starLayer.setX($windowWidth / 2);
      starLayer.setY($windowHeight / 2);
      starLayer.setOffset($windowWidth / 2, $windowHeight / 2);
      starLayer.draw();
      starLayer.removeChildren();
      for (i = _j = 0; 0 <= starNum ? _j <= starNum : _j >= starNum; i = 0 <= starNum ? ++_j : --_j) {
        factory = getStarFactory(starFactory, starRate);
        x = getRandomOffset(($windowWidth - $windowMaxLength) / 2, $windowMaxLength);
        y = getRandomOffset(($windowHeight - $windowMaxLength) / 2, $windowMaxLength);
        star = factory(x, y);
        starLayer.add(star);
      }
      return anime.start();
    });
    shootingStar = null;
    shootingStarStart = null;
    ex = null;
    a = null;
    shootingstarFunc = function() {
      var points, timeDiff;
      if (ssLayer.getChildren().length === 0) {
        shootingStarStart = new Date().getTime();
        x = getRandomOffset(($windowWidth - $windowMaxLength) / 2, $windowMaxLength);
        y = getRandomOffset(($windowHeight - $windowMaxLength) / 2, $windowMaxLength);
        ex = getRandomOffset(-30, 30);
        a = getRandomOffset(-30, 30);
        shootingStar = new Kinetic.Line({
          points: [x, y, x, y],
          stroke: 'white',
          strokeWidth: 1,
          lineCap: 'round'
        });
        ssLayer.add(shootingStar);
        ssLayer.draw();
      } else {
        timeDiff = (new Date().getTime() - shootingStarStart) / 100;
        points = shootingStar.getPoints();
        points[0].x = points[0].x + ex * timeDiff;
        points[0].y = points[0].y + a * timeDiff;
        points[1].x = points[1].x + 1.5 * ex * timeDiff;
        points[1].y = points[1].y + 1.5 * a * timeDiff;
        shootingStar.setPoints(points);
        shootingStar.setOpacity(shootingStar.getOpacity() / 1.2);
        ssLayer.draw();
        if (points[0].x < 0 || points[0].y < 0 || points[0].x > $windowWidth || points[0].y > $windowHeight) {
          shootingStar.remove();
          shootingStar = null;
          return setTimeout(function() {
            return window.requestAnimationFrame(shootingstarFunc);
          }, 2000);
        }
      }
      return window.requestAnimationFrame(shootingstarFunc);
    };
    return shootingstarFunc();
  });

}).call(this);
