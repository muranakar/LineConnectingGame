//
//  ViewController.swift
//  Shape2022-06-11
//
//  Created by 村中令 on 2022/06/11.
//
// 参考: https://uruly.xyz/%E3%80%90swift-3%E3%80%91calayer%E3%82%92%E7%94%A8%E3%81%84%E3%81%A6%E5%9B%B3%E5%BD%A2%E3%82%92%E7%A7%BB%E5%8B%95%E3%83%BB%E6%8B%A1%E5%A4%A7%E7%B8%AE%E5%B0%8F%E3%81%97%E3%81%A6%E3%81%BF%E3%81%9F/
import UIKit

class GameViewController: UIViewController {
    @IBOutlet weak var drawView: DrawView!


    @IBOutlet weak var coinLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!

    @IBOutlet weak var leftFirstLabel: UILabel!
    @IBOutlet weak var leftSecondLabel: UILabel!
    @IBOutlet weak var leftThirdLabel: UILabel!
    @IBOutlet weak var leftFourthLabel: UILabel!
    @IBOutlet weak var leftFifthLabel: UILabel!
    @IBOutlet weak var rightFirstLabel: UILabel!
    @IBOutlet weak var rightSecondLabel: UILabel!
    @IBOutlet weak var rightThirdLabel: UILabel!
    @IBOutlet weak var rightFourthLabel: UILabel!
    @IBOutlet weak var rightFifthLabel: UILabel!

    @IBOutlet weak var leftFirstImageView: UIImageView!
    @IBOutlet weak var leftSecondImageView: UIImageView!
    @IBOutlet weak var leftThirdImageView: UIImageView!
    @IBOutlet weak var leftFourthImageView: UIImageView!
    @IBOutlet weak var leftFifthImageView: UIImageView!
    @IBOutlet weak var rightFirstImageView: UIImageView!
    @IBOutlet weak var rightSecondImageView: UIImageView!
    @IBOutlet weak var rightThirdImageView: UIImageView!
    @IBOutlet weak var rightFourthImageView: UIImageView!
    @IBOutlet weak var rightFifthImageView: UIImageView!

    @IBOutlet private weak var correntNumLabel: UILabel!

    // MARK: - IBOutletをクロージャでまとめている
    private var labels: [UILabel] {
        return [
            leftFirstLabel,
            leftSecondLabel,
            leftThirdLabel,
            leftFourthLabel,
            leftFifthLabel,
            rightFirstLabel,
            rightSecondLabel,
            rightThirdLabel,
            rightFourthLabel,
            rightFifthLabel
        ]
    }
    private var leftLabels: [UILabel] {
        return [
            leftFirstLabel,
            leftSecondLabel,
            leftThirdLabel,
            leftFourthLabel,
            leftFifthLabel
        ]
    }
    private var rightLabels: [UILabel] {
        return [
            rightFirstLabel,
            rightSecondLabel,
            rightThirdLabel,
            rightFourthLabel,
            rightFifthLabel
        ]
    }

    private var imageViews: [UIImageView] {
        return [
            leftFirstImageView,
            leftSecondImageView,
            leftThirdImageView,
            leftFourthImageView,
            leftFifthImageView,
            rightFirstImageView,
            rightSecondImageView,
            rightThirdImageView,
            rightFourthImageView,
            rightFifthImageView
        ]
    }


    private var leftImageViews: [UIImageView] {
        return [
            leftFirstImageView,
            leftSecondImageView,
            leftThirdImageView,
            leftFourthImageView,
            leftFifthImageView
        ]
    }

    private var rightImageViews: [UIImageView] {
        return [
            rightFirstImageView,
            rightSecondImageView,
            rightThirdImageView,
            rightFourthImageView,
            rightFifthImageView
        ]
    }

    // MARK: - ランダムの値を出力するために用いているプロパティ
    var characterType: CharacterType
    var allShuffledValue: [String] = []
    var filtedFiveRandomValue :[String] = []
    var leftShuffledRandomValue: [String] = []
    var rightShuffledRandomValue: [String] = []
    var dictonaryImageAndValue: [UIImageView: String] = [:]

    // MARK: - 正解の数
    var correctNum: Int = 0

    // MARK: - 図形の挙動にまつわるプロパティ
    //選択したレイヤーをいれておく
    private var selectLayer:CALayer!
    //最後にタッチされた座標をいれておく
    private var touchLastPoint:CGPoint!

    // MARK: - タイマー関係のプロパティ
    let time:Float = 5.0
    var cnt:Float = 0
    var count: Float { time - cnt }
    var GameTimer: Timer?

    // MARK: - コイン関係のプロパティ
    var coin: Int


    required init?(coder: NSCoder,characterType: CharacterType) {
        self.coin = CoinRepository.load() ?? 0
        self.characterType = characterType
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        drawView.delegate = self
        imageViews.forEach { image in
            self.view.sendSubviewToBack(image)
        }
        drawView.setDrawingColor(color: UIColor.black)
        randomValueInitializationAndConfigureLabel()
        timerLabel.text = TimerFormatter.string(from: count)
        GameTimer = Timer.scheduledTimer(
    timeInterval: 1,
    target: self,
    selector: #selector(countDown(timer: )),
    userInfo: nil,
    repeats: true)

    }

    // MARK: - メソッド
    func randomValueInitializationAndConfigureLabel() {
        coinLabel.text = "×  \(coin)"
        allShuffledValue = CsvConversion.convertFacilityInformationFromCsv(characterType: characterType).shuffled()
        filtedFiveRandomValue = Array(allShuffledValue.prefix(5))

        leftShuffledRandomValue = filtedFiveRandomValue.shuffled()
        rightShuffledRandomValue = filtedFiveRandomValue.shuffled()

        dictonaryImageAndValue = [
            leftImageViews[0]: leftShuffledRandomValue[0],
            leftImageViews[1]: leftShuffledRandomValue[1],
            leftImageViews[2]: leftShuffledRandomValue[2],
            leftImageViews[3]: leftShuffledRandomValue[3],
            leftImageViews[4]: leftShuffledRandomValue[4],
            rightImageViews[0]: rightShuffledRandomValue[0],
            rightImageViews[1]: rightShuffledRandomValue[1],
            rightImageViews[2]: rightShuffledRandomValue[2],
            rightImageViews[3]: rightShuffledRandomValue[3],
            rightImageViews[4]: rightShuffledRandomValue[4]
        ]
        var leftLabelIndex = 0
        leftLabels.forEach { label in
            label.text = leftShuffledRandomValue[leftLabelIndex]
            leftLabelIndex += 1
        }

        var rightLabelIndex = 0
        rightLabels.forEach { label in
            label.text = rightShuffledRandomValue[rightLabelIndex]
            rightLabelIndex += 1
        }
        drawView.configure(
            labels: labels,
            leftLabels: leftLabels,
            rightLabels: rightLabels,
            imageViews: imageViews,
            leftImageViews: leftImageViews,
            rightImageViews: rightImageViews,
            dictonaryImageAndValue: dictonaryImageAndValue
        )
        correntNumLabel.text = "\(correctNum)個　正解 "

    }


    @objc func countDown(timer: Timer) {
        //カウントを１減らす
        cnt += 1
        //タイマーを止める
        if count < 0 {
            GameTimer?.invalidate()

            self.timerLabel.text = TimerFormatter.string(from: 0)

            CoinRepository.save(coinNum: coin)
            performSegue(withIdentifier: "result", sender: nil)
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.timerLabel.text = TimerFormatter.string(from: self!.count)
            }
        }
    }

    @IBAction func clearTapped(_ sender: Any) {
        drawView.clear()
    }

}

extension GameViewController: ProtocolDrawView {
    func precessingAfterCorrectAnswer() {
        var countCorrect = 0

        drawView.selectedValue.forEach { string in
            let bool = string.0 == string.1
            if bool == true {
                countCorrect += 1
                return
            }
        }
        if countCorrect == 5 {
            correctNum += 1
            coin += 1
            randomValueInitializationAndConfigureLabel()
        }
    }

    func selectedSelectionAlert() {
//        present(UIAlertController.checkIsSelection(), animated: true)
    }
}

class DrawView: UIView {
    enum ImageSelectionStatus {
        case rightImage
        case leftImage
        case nothingIsSelected
    }
    var delegate: ProtocolDrawView!
    private var currentDrawing: Drawing?
    private var finishedDrawings: [Drawing] = []
    private var currentColor = UIColor.black
    private var labels: [UILabel] = []
    private var leftLabels: [UILabel] = []
    private var rightLabels: [UILabel] = []
    private var imageViews: [UIImageView] = []
    private var leftImageViews: [UIImageView] = []
    private var rightImageViews: [UIImageView] = []
    private var dictonaryImageAndValue: [UIImageView: String] = [:]


    var setOfTwoImages:(first: UIImageView?, second: UIImageView?)
    var setOfTwoValue: (first: String?,second: String?)
    var selectedImages:[UIImageView] = []
    var selectedValue:[(String,String)] = []
    var imageSelectionStatus: ImageSelectionStatus = .nothingIsSelected

    func configure(
        labels: [UILabel],
        leftLabels: [UILabel] ,
        rightLabels: [UILabel],
        imageViews: [UIImageView],
        leftImageViews: [UIImageView],
        rightImageViews: [UIImageView],
        dictonaryImageAndValue: [UIImageView: String]
    ) {
        self.labels = labels
        self.leftLabels = leftLabels
        self.rightLabels = rightLabels
        self.imageViews = imageViews
        self.leftImageViews = leftImageViews
        self.rightImageViews = rightImageViews
        self.dictonaryImageAndValue = dictonaryImageAndValue
    }

    override func draw(_ rect: CGRect) {
        for drawing in finishedDrawings {
            drawing.color.setStroke()
            stroke(drawing: drawing)
        }

        if let drawing = currentDrawing {
            drawing.color.setStroke()
            stroke(drawing: drawing)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)

        imageViews.forEach { imageView in
            let convertFrame = imageView.convert(imageView.bounds, to: self)
            if isPressedPositionInTheImageArea(convertFrame: convertFrame, touchedLocation: location) {
                if selectedImages.contains(imageView) {
                    // TODO: アラート表示する。
                    delegate.selectedSelectionAlert()
                    return
                }
                currentDrawing = Drawing(startPoint: CGPoint(x: convertFrame.midX, y: convertFrame.midY))
                currentDrawing?.color = currentColor
                setNeedsDisplay()
                // 選択された１つ目の画像
                setOfTwoImages.first = imageView
                setOfTwoValue.first = dictonaryImageAndValue[imageView]
                if leftImageViews.contains(imageView) {
                    leftImageViews.forEach { imageView in
                        imageView.isHidden = true
                    }
                    imageSelectionStatus = .leftImage
                } else {
                    if rightImageViews.contains(imageView) {
                        rightImageViews.forEach { image in
                            image.isHidden = true
                        }
                        imageSelectionStatus = .rightImage
                    }
                }
                return
            } else {
            }

        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
        currentDrawing?.endPoint = location
        setNeedsDisplay()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard var drawing = currentDrawing else { return }
        let touch = touches.first!
        let location = touch.location(in: self)

        switch imageSelectionStatus {
        case .rightImage:
            leftImageViews.forEach { imageView in

                let convertFrame = imageView.convert(imageView.bounds, to: self)
                if isPressedPositionInTheImageArea(convertFrame: convertFrame, touchedLocation: location) {
                    if selectedImages.contains(imageView) {
                        // TODO: アラート表示する。
                        delegate.selectedSelectionAlert()

                        return
                    }
                    drawing.endPoint = CGPoint(x: convertFrame.midX, y: convertFrame.midY)
                    finishedDrawings.append(drawing)
                    setOfTwoImages.second = imageView
                    setOfTwoValue.second = dictonaryImageAndValue[imageView]
                    selectedImages.append(setOfTwoImages.first!)
                    selectedImages.append(setOfTwoImages.second!)
                    selectedValue.append((setOfTwoValue.first!,setOfTwoValue.second!))
                }
            }
        case .leftImage:
            rightImageViews.forEach { imageView in
                let convertFrame = imageView.convert(imageView.bounds, to: self)
                if isPressedPositionInTheImageArea(convertFrame: convertFrame, touchedLocation: location) {
                    if selectedImages.contains(imageView) {
                        // TODO: アラート表示する。
                        delegate.selectedSelectionAlert()

                        return
                    }
                    drawing.endPoint = CGPoint(x: convertFrame.midX, y: convertFrame.midY)
                    finishedDrawings.append(drawing)
                    setOfTwoImages.second = imageView
                    setOfTwoValue.second = dictonaryImageAndValue[imageView]
                    selectedImages.append(setOfTwoImages.first!)
                    selectedImages.append(setOfTwoImages.second!)
                    selectedValue.append((setOfTwoValue.first!,setOfTwoValue.second!))
                }
            }
        case .nothingIsSelected:
            break
        }

        imageViews.forEach { imageView in
            imageView.isHidden = false
        }
        currentDrawing = nil
        setNeedsDisplay()

        if selectedValue.count == 5 {

            delegate.precessingAfterCorrectAnswer()
            clear()
        }
    }

    func clear() {
        selectedImages = []
        selectedValue = []
        finishedDrawings.removeAll()
        setNeedsDisplay()
    }

    func setDrawingColor(color : UIColor){
        currentColor = color
    }

    func stroke(drawing: Drawing) {
        let path = UIBezierPath()

        path.lineWidth = 8.0
        path.lineCapStyle = .round
        path.lineJoinStyle = .round

        let begin = drawing.startPoint
        path.move(to: begin)

        guard let end = drawing.endPoint else { return }
        path.addLine(to: end)
        path.close()
        path.stroke()
    }

    func isPressedPositionInTheImageArea(convertFrame: CGRect,touchedLocation: CGPoint ) -> Bool{
        return convertFrame.minX <= touchedLocation.x
        && convertFrame.maxX >= touchedLocation.x
        && convertFrame.minY <= touchedLocation.y
        && convertFrame.maxY >= touchedLocation.y
    }
}

private extension GameViewController {
    @IBSegueAction
    func makeResult(coder: NSCoder, sender: Any?, segueIdentifier: String?) -> ResultViewController? {
        return ResultViewController(coder: coder, correntNum: correctNum, coin: coin)
    }
}

protocol ProtocolDrawView {
    func selectedSelectionAlert()
    func precessingAfterCorrectAnswer()
}

/// タイマーのformatter
struct TimerFormatter {
    static func string(from absoluteTime: Float) -> String {
        var (sec): (Int)
        (sec, _) = Int(absoluteTime * 100).quotientAndRemainder(dividingBy: 100)
        return String(format: "残り%02ld秒", sec)
    }
}
