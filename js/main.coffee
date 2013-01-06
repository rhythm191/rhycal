###
# メインとなるスクリプトファイル
###

###
# ファンクション
###

# 小さき星を表現するShapeクラスを返す
createSmallStar = (x, y, offsetX, offsetY) ->
	circle = new Kinetic.Circle(
		x: x
		y: y
		radius: 1
		offset: [offsetX, offsetY]
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
createMiddleStar = (x, y, offsetX, offsetY) ->
	circle = new Kinetic.Circle(
		x: x
		y: y
		radius: 2
		offset: [offsetX, offsetY]
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
createBigStar = (x, y, offsetX, offsetY) ->
	circle = new Kinetic.Circle(
		x: x
		y: y
		radius: 4
		offset: [offsetX, offsetY]
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
createPurpleStar = (x, y, offsetX, offsetY) ->
	circle = new Kinetic.Circle(
		x: x
		y: y
		radius: 3
		offset: [offsetX, offsetY]
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
createRedSmallStar = (x, y, offsetX, offsetY) ->
	circle = new Kinetic.Circle(
		x: x
		y: y
		radius: 1
		offset: [offsetX, offsetY]
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
createRedMiddleStar = (x, y, offsetX, offsetY) ->
	circle = new Kinetic.Circle(
		x: x
		y: y
		radius: 2
		offset: [offsetX, offsetY]
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
	centerX = $windowWidth / 2
	centerY = $windowHeight / 2
	starNum = ($windowMaxLength * $windowMaxLength) / 1000

	stage = new Kinetic.Stage(
		container: 'container'
		width: $windowWidth
		height: $windowHeight
	)

	# 星を管理するレイヤー
	starLayer = new Kinetic.Layer()
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
		star = factory(centerX, centerY, centerX - x, centerY - y)
		starLayer.add(star)

	stage.add(starLayer)
	stage.add(ssLayer)

	# 星々全体を回転させるアニメーションの設定
	angularSpeed = Math.PI / 800
	anime = new Kinetic.Animation( (frame) ->
		angleDiff = frame.timeDiff * angularSpeed / 1000
		children = starLayer.getChildren()
		for node in children
			node.rotate(angleDiff)
	, starLayer)

	anime.start()

	# ウインドウサイズが変わったら星を作り直す
	$(window).resize (e) ->
		anime.stop()

		$windowWidth = $(window).width()
		$windowHeight = $(window).height()
		$windowMaxLength = Math.sqrt($windowWidth * $windowWidth + $windowHeight * $windowHeight)
		centerX = $windowWidth / 2
		centerY = $windowHeight / 2
		starNum = ($windowMaxLength * $windowMaxLength) / 1000

		stage.setWidth($windowWidth)
		stage.setHeight($windowHeight)

		starLayer.removeChildren()
		for i in [0..starNum]
			factory = getStarFactory(starFactory, starRate)
			x = getRandomOffset(($windowWidth - $windowMaxLength) / 2, $windowMaxLength)
			y = getRandomOffset(($windowHeight - $windowMaxLength) / 2, $windowMaxLength)
			star = factory(centerX, centerY, centerX - x, centerY - y)
			starLayer.add(star)

		anime.start()




	# 流れ星を生成するアニメーション
	# shootingstarFunc = ->
	# 	x = getRandomOffset(($windowWidth - $windowMaxLength) / 2, $windowMaxLength)
	# 	y = getRandomOffset(($windowHeight - $windowMaxLength) / 2, $windowMaxLength)
	# 	ex = 1 #getRandomOffset(-1, 1)
	# 	a =  3 #getRandomOffset(-100, 100)
	# 	shootingStar = new Kinetic.Line(
	# 		points: [0, 0, 0, 0]
	# 		stroke: 'white'
	# 		strokeWidth: 2
	# 	)

	# 	ssLayer.add(shootingStar)

	# 	ssanime = new Kinetic.Animation( (frame) ->
	# 		points = shootingStar.getPoints()
	# 		points[0] = points[0] + ex * frame.timeDiff 
	# 		points[1] = points[1] + a * frame.timeDiff 
	# 		shootingStar.setPoints(points)

	# 		if(points[0] < 0 or points[1] < 0 or points[0] > $windowWidth or points[1] > $windowHeight)
	# 			ssanime.stop()
	# 			shootingStar.remove()
	# 	, ssLayer)
	# 	ssanime.start()
	# 	setTimeout shootingstarFunc, getRandomOffset(1000, 5000)

	# shootingstarFunc()
	



