###
# メインとなるスクリプトファイル
###

###
# ファンクション
###

# 小さき星を表現するShapeクラスを返す
createSmallStar = (x, y) ->
	circle = new Kinetic.Circle(
		x: x
		y: y
		radius: 1
		fill:
			start:
				x: 0
				y: 0
				radius: 0
			end:
				x: 0
				y: 0
				radius: 1
			colorStops: [0, 'white', 1, '#222222']
	)

# 小さき星を表現するShapeクラスを返す
createMiddleStar = (x, y) ->
	circle = new Kinetic.Circle(
		x: x
		y: y
		radius: 2
		fill:
			start:
				x: 0
				y: 0
				radius: 0
			end:
				x: 0
				y: 0
				radius: 2
			colorStops: [0, 'white', 1, '#222222']
	)

# 比較的大きな星を表現するShapeクラスを返す
createBigStar = (x, y) ->
	circle = new Kinetic.Circle(
		x: x
		y: y
		radius: 4
		fill:
			start:
				x: 0
				y: 0
				radius: 0
			end:
				x: 0
				y: 0
				radius: 4
			colorStops: [0, 'white', 1, '#222222']
	)

# 紫色の星を表現するShapeクラスを返す
createPurpleStar = (x, y) ->
	circle = new Kinetic.Circle(
		x: x
		y: y
		radius: 3
		fill:
			start:
				x: 0
				y: 0
				radius: 0
			end:
				x: 0
				y: 0
				radius: 3
			colorStops: [0, 'white', 1, '#620D7C']
	)

# 紫色の星を表現するShapeクラスを返す
createRedSmallStar = (x, y) ->
	circle = new Kinetic.Circle(
		x: x
		y: y
		radius: 1
		fill:
			start:
				x: 0
				y: 0
				radius: 0
			end:
				x: 0
				y: 0
				radius: 1
			colorStops: [0, 'red', 1, '#222222']
	)

# 紫色の星を表現するShapeクラスを返す
createRedMiddleStar = (x, y) ->
	circle = new Kinetic.Circle(
		x: x
		y: y
		radius: 2
		fill:
			start:
				x: 0
				y: 0
				radius: 0
			end:
				x: 0
				y: 0
				radius: 2
			colorStops: [0, 'red', 1, '#222222']
	)

# 0~maxまでの乱数を作成する関数
getRandomNum = (max) ->
	Math.round(Math.random() * max)

# min~maxまでの乱数を作成する関数
getRandomOffset = (min, max) ->
	Math.round(Math.random() * (max - min)) + min

# 乱数を生成し，引数で指定した比率で引数で指定したファクトリメソッドを返す.
getStarFactory = (starFactory, rate) ->
	rateAll = 0
	rateAll += num for num in rate
	value = getRandomNum(rateAll)
	now = 0
	for i, num of rate
		now += num
		return starFactory[i] if value < now
	return starFactory[starFactory.length - 1]

#
# アニメーションフレームの設定
#
window.requestAnimationFrame = ( ->
	return window.requestAnimationFrame		||
		window.webkitRequestAnimationFrame	||
		window.mozRequestAnimationFrame		||
		window.oRequestAnimationFrame		||
		window.msRequestAnimationFrame		||
		(callback, element) ->
			window.setTimeout(callback, 1000 / 60)
)();

#
# メインスクリプト
# 
jQuery ($) ->

	# 今日の日付には.todayをつける
	dayNum = new Date().getDate()
	$('#days').find('.numeric').not('.nextMonth').each ->
		#$(this).addClass('today').text('☆') if $(this).text() is "#{dayNum}"
		$(this).append('<span class="today">☆</span>') if $(this).text() is "#{dayNum}"


	# 星の描画に関する設定パラメータ
	$windowWidth = $(window).width()
	$windowHeight = $(window).height()
	$windowMaxLength = Math.sqrt($windowWidth * $windowWidth + $windowHeight * $windowHeight)
	starNum = ($windowMaxLength * $windowMaxLength) / 1000

	stage = new Kinetic.Stage(
		container: 'container'
		width: $windowWidth
		height: $windowHeight
	)

	# 星を管理するレイヤー
	starLayer = new Kinetic.Layer(
		x: $windowWidth / 2
		y: $windowHeight / 2
		offset: [$windowWidth / 2, $windowHeight / 2]
	)
	
	# 流れ星を管理するレイヤー
	ssLayer = new Kinetic.Layer()

	# 星を生成するメソッド
	starFactory = [createSmallStar, createMiddleStar, createBigStar, createPurpleStar, createRedSmallStar, createRedMiddleStar]
	# 各星を出現させるレート
	starRate = [50, 30, 1, 1, 7, 1]

	for i in [0..starNum]
		factory = getStarFactory(starFactory, starRate)
		x = getRandomOffset(($windowWidth - $windowMaxLength) / 2, $windowMaxLength)
		y = getRandomOffset(($windowHeight - $windowMaxLength) / 2, $windowMaxLength)
		star = factory(x, y)
		starLayer.add(star)

	stage.add(starLayer)
	stage.add(ssLayer)

	# 星々全体を回転させるアニメーションの設定
	angularSpeed = Math.PI / 800
	anime = new Kinetic.Animation( (frame) ->
		angleDiff = frame.timeDiff * angularSpeed / 1000
		starLayer.rotate(angleDiff)
	, starLayer)

	anime.start()

	# ウインドウサイズが変わったら星を作り直す
	$(window).resize (e) ->
		anime.stop()

		$windowWidth = $(window).width()
		$windowHeight = $(window).height()
		$windowMaxLength = Math.sqrt($windowWidth * $windowWidth + $windowHeight * $windowHeight)
		starNum = ($windowMaxLength * $windowMaxLength) / 1000

		stage.setWidth($windowWidth)
		stage.setHeight($windowHeight)
		starLayer.rotate(0)
		starLayer.setX($windowWidth / 2)
		starLayer.setY($windowHeight / 2)
		starLayer.setOffset($windowWidth / 2, $windowHeight / 2)
		starLayer.draw()

		starLayer.removeChildren()
		for i in [0..starNum]
			factory = getStarFactory(starFactory, starRate)
			x = getRandomOffset(($windowWidth - $windowMaxLength) / 2, $windowMaxLength)
			y = getRandomOffset(($windowHeight - $windowMaxLength) / 2, $windowMaxLength)
			star = factory(x, y)
			starLayer.add(star)

		anime.start()



	# 流れ星を生成するアニメーション
	shootingStar = null
	shootingStarStart = null
	ex = null
	a = null
	shootingstarFunc = ->
		if ssLayer.getChildren().length == 0
			shootingStarStart = new Date().getTime()
			x = getRandomOffset ($windowWidth - $windowMaxLength) / 2, $windowMaxLength
			y = getRandomOffset ($windowHeight - $windowMaxLength) / 2, $windowMaxLength
			ex = getRandomOffset -30, 30
			a =  getRandomOffset -30, 30
			shootingStar = new Kinetic.Line(
				points: [x, y, x, y]
				stroke: 'white'
				strokeWidth: 1
				lineCap: 'round'
			)
			ssLayer.add(shootingStar)
			ssLayer.draw()
		else 
			timeDiff =  (new Date().getTime() - shootingStarStart) / 100
			points = shootingStar.getPoints()
			points[0].x = points[0].x + ex * timeDiff
			points[0].y = points[0].y + a * timeDiff
			points[1].x = points[1].x + 1.5 * ex  * timeDiff
			points[1].y = points[1].y + 1.5 * a * timeDiff
			shootingStar.setPoints(points)
			shootingStar.setOpacity(shootingStar.getOpacity() / 1.2)
			ssLayer.draw()


			if(points[0].x < 0 or points[0].y < 0 or points[0].x > $windowWidth or points[0].y > $windowHeight)
				shootingStar.remove()
				shootingStar = null
				return setTimeout( ->
					window.requestAnimationFrame shootingstarFunc
				, 2000)

		window.requestAnimationFrame shootingstarFunc

	shootingstarFunc()

	



