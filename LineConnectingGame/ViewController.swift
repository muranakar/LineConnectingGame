//
//  ViewController.swift
//  Shape2022-06-11
//
//  Created by 村中令 on 2022/06/11.
//
// 参考: https://uruly.xyz/%E3%80%90swift-3%E3%80%91calayer%E3%82%92%E7%94%A8%E3%81%84%E3%81%A6%E5%9B%B3%E5%BD%A2%E3%82%92%E7%A7%BB%E5%8B%95%E3%83%BB%E6%8B%A1%E5%A4%A7%E7%B8%AE%E5%B0%8F%E3%81%97%E3%81%A6%E3%81%BF%E3%81%9F/
import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var drawView: DrawView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!

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

    private let randomNumber = 1...100
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
        [
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

    var randomValue :[String] = ["1","2","3","4","5"]
    var dictonaryImageAndValue: [UIImageView: String] {
        return [
            leftImageViews[0]: randomValue[0],
            leftImageViews[1]: randomValue[1],
            leftImageViews[2]: randomValue[2],
            leftImageViews[3]: randomValue[3],
            leftImageViews[4]: randomValue[4],
            rightImageViews[0]: randomValue[0],
            rightImageViews[1]: randomValue[1],
            rightImageViews[2]: randomValue[2],
            rightImageViews[3]: randomValue[3],
            rightImageViews[4]: randomValue[4]
        ]
    }

    var dictonaryImageAndLabel: [UIImageView: UILabel] {
        return [
            leftImageViews[0]: leftLabels[0],
            leftImageViews[1]: leftLabels[1],
            leftImageViews[2]: leftLabels[2],
            leftImageViews[3]: leftLabels[3],
            leftImageViews[4]: leftLabels[4],
            rightImageViews[0]: rightLabels[0],
            rightImageViews[1]: rightLabels[1],
            rightImageViews[2]: rightLabels[2],
            rightImageViews[3]: rightLabels[3],
            rightImageViews[4]: rightLabels[4]
        ]
    }
    //選択したレイヤーをいれておく
    private var selectLayer:CALayer!
    //最後にタッチされた座標をいれておく
    private var touchLastPoint:CGPoint!

    override func viewDidLoad() {
        super.viewDidLoad()
        drawView.delegate = self
        segmentedControl.selectedSegmentIndex = 0
        
        imageViews.forEach { imageView in
            drawView.imageViews.append(imageView)
        }

        leftImageViews.forEach { imageView in
            drawView.leftImageViews.append(imageView)
        }

        rightImageViews.forEach { imageView in
            drawView.rightImageViews.append(imageView)
        }

        leftImageViews.forEach { imageView in
            imageView.layer.borderColor = UIColor.tintColor.cgColor
            //線の太さ(太さ)
            imageView.layer.borderWidth = 1
        }
        rightImageViews.forEach { imageView in

            imageView.layer.borderColor = UIColor.black.cgColor
            //線の太さ(太さ)
            imageView.layer.borderWidth = 1
        }

    }

    @IBAction func clearTapped(_ sender: Any) {
        drawView.clear()
    }

    @IBAction func undoTapped(_ sender: Any) {
        drawView.undo()
    }

    @IBAction func colorChanged(_ sender: Any) {
        var c = UIColor.black
        switch segmentedControl.selectedSegmentIndex {
        case 1:
            c = UIColor.green
            break
        case 2:
            c = UIColor.red
            break
        default:
            break
        }
        drawView.setDrawingColor(color: c)
    }
}

extension ViewController: ProtocolDrawView {
    func selectedSelectionAlert() {
        present(UIAlertController.checkIsSelection(), animated: true)
    }
}

class DrawView: UIView {
    enum ImageSelectionStatus {
        case rightImage
        case leftImage
        case nothingIsSelected
    }
    var delegate: ProtocolDrawView!
    var currentDrawing: Drawing?
    var finishedDrawings: [Drawing] = []
    var currentColor = UIColor.black
    var imageViews: [UIImageView] = []
    var leftImageViews: [UIImageView] = []
    var rightImageViews: [UIImageView] = []
    var setOfTwoImages:(first: UIImageView?, second: UIImageView?)
    var selectedImages:[UIImageView] = []
    var imageSelectionStatus: ImageSelectionStatus = .nothingIsSelected

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
        let location2 = touch.preciseLocation(in: self)
        print(location2)
        let location3 = touch.previousLocation(in: self)
        print(location3)
        let location = touch.location(in: self)


        print(location)
        imageViews.forEach { imageView in

            let convertFrame = imageView.convert(imageView.bounds, to: self)
            print("最小X:\(convertFrame.minX),最大X:\(convertFrame.maxX),最小Y:\(convertFrame.minY),最大Y:\(convertFrame.maxY)")
            if convertFrame.minX <= location.x
                && convertFrame.maxX >= location.x
                && convertFrame.minY <= location.y
                && convertFrame.maxY >= location.y {
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
                if leftImageViews.contains(imageView) {
                    leftImageViews.forEach { imageView in
                        imageView.isHidden = true

                    }
                    imageSelectionStatus = .leftImage
                } else {
                    if rightImageViews.contains(imageView) {
                        rightImageViews.forEach { image in
                            image.isHidden = true
                            print(image)
                        }
                        imageSelectionStatus = .rightImage
                    }
                }
                return
            } else {
            }
        }
        print("-----------------------")
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
                if convertFrame.minX <= location.x
                    && convertFrame.maxX >= location.x
                    && convertFrame.minY <= location.y
                    && convertFrame.maxY >= location.y {
                    if selectedImages.contains(imageView) {
                        // TODO: アラート表示する。
                        delegate.selectedSelectionAlert()

                        return
                    }
                    drawing.endPoint = CGPoint(x: convertFrame.midX, y: convertFrame.midY)
                    finishedDrawings.append(drawing)
                    setOfTwoImages.second = imageView
                    selectedImages.append(setOfTwoImages.first!)
                    selectedImages.append(setOfTwoImages.second!)
                }
            }
        case .leftImage:
            rightImageViews.forEach { imageView in
                let convertFrame = imageView.convert(imageView.bounds, to: self)
                if convertFrame.minX <= location.x
                    && convertFrame.maxX >= location.x
                    && convertFrame.minY <= location.y
                    && convertFrame.maxY >= location.y {
                    if selectedImages.contains(imageView) {
                        // TODO: アラート表示する。
                        delegate.selectedSelectionAlert()

                        return
                    }
                    drawing.endPoint = CGPoint(x: convertFrame.midX, y: convertFrame.midY)
                    finishedDrawings.append(drawing)
                    setOfTwoImages.second = imageView
                    selectedImages.append(setOfTwoImages.first!)
                    selectedImages.append(setOfTwoImages.second!)
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
    }

    func clear() {
        selectedImages = []
        finishedDrawings.removeAll()
        setNeedsDisplay()
    }

    func undo() {
        if finishedDrawings.count == 0 {
            return
        }
        finishedDrawings.remove(at: finishedDrawings.count - 1)
        setNeedsDisplay()
    }

    func setDrawingColor(color : UIColor){
        currentColor = color
    }

    func stroke(drawing: Drawing) {
        let path = UIBezierPath()

        path.lineWidth = 10.0
        path.lineCapStyle = .round
        path.lineJoinStyle = .round

        let begin = drawing.startPoint
        path.move(to: begin)

        guard let end = drawing.endPoint else { return }
        path.addLine(to: end)
        path.close()
        path.stroke()
    }
}

protocol ProtocolDrawView {
    func selectedSelectionAlert()
}
