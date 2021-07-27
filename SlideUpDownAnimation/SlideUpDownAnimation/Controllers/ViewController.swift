
import UIKit

enum StatusType: String{
    case like = "Liked"
    case dislike = "Disliked"
    case matched = "Matched"
}

class ViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var firstImageView: UIImageView!
    @IBOutlet weak var secondImageView: UIImageView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var successLabel: UILabel!
    @IBOutlet weak var effectView: UIView!
    
    //MARK: - Declared Variables
    private var initialCenter: CGPoint = .zero
    private var blurredEffectView = UIView()
    
    private let panView: UIView = {
        let panview = UIView()
        panview.backgroundColor = .clear
        return panview
    }()
    private let lineOfPanView: UIView = {
        let line = UIView()
        line.backgroundColor = .cyan
        return line
    }()
    private let dragImageView: UIImageView = {
        let drag = UIImageView()
        drag.image = UIImage(named: "icon")
        return drag
    }()
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialization()
    }
}

//MARK:- Initialization
extension ViewController {
    
    fileprivate func initialization() {
        setupPanView()
        setupDottedLine()
        setInitialMaskToImage()
    }
    
    private func setupPanView() {
        view.addSubview(panView)
        panView.addSubview(lineOfPanView)
        panView.addSubview(dragImageView)
        let panViewHeight : CGFloat = 30
        panView.frame = CGRect(x: 0, y: (Device.height - panViewHeight)/2, width: Device.width, height: panViewHeight)
        lineOfPanView.frame = CGRect(x: 0, y: panView.height/2, width: panView.width, height: 1)
        dragImageView.frame = CGRect(x: (panView.width - panViewHeight)/2, y: (panView.height - panViewHeight)/2, width: panViewHeight, height: panViewHeight)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
        panView.addGestureRecognizer(panGestureRecognizer)
    }
    
    private func setupDottedLine() {
        firstView.makeDashedBorderLine()
        secondView.makeDashedBorderLine()
    }
    
    private func setInitialMaskToImage() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.maskImage(y: self.panView.midY - Device.top_padding)
            self.successLabel.transform = CGAffineTransform(scaleX: Constants.zeroZoomOutScale, y: Constants.zeroZoomOutScale)
            self.successLabel.layoutIfNeeded()
        }
    }
}

//MARK: - Animations
extension ViewController {
    
    private func blurView(time: TimeInterval) {
        let blurEffect = UIBlurEffect(style: .regular)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = self.effectView.bounds
        effectView.addSubview(blurredEffectView)
        panView.isHidden = true
        fadeInOutView(blurredEffectView, isFadeIn: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + time) {
            self.fadeInOutView(blurredEffectView, isFadeIn: false)
            self.panView.isHidden = false
        }
    }
    
    private func fadeInOutView(_ view: UIView, isFadeIn: Bool) {
        view.alpha = CGFloat(Int(truncating: NSNumber(value: !isFadeIn)))
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut, animations: {
            view.alpha = CGFloat(Int(truncating: NSNumber(value: isFadeIn)))
        }, completion: nil)
    }
    
    private func animateLabel(_ view: UILabel, isFadeIn: Bool, withDelay delay: CGFloat = 0){
        UIView.animate(withDuration: Constants.animationDuration, delay: 0, options: [], animations: {
            view.alpha = CGFloat(Int(truncating: NSNumber(value: isFadeIn)))
            view.transform = CGAffineTransform(scaleX: Constants.zoomInScale, y: Constants.zoomInScale)
        }, completion: { _ in
            UIView.animate(withDuration: Constants.animationDuration, delay: TimeInterval(delay), options: [], animations: {
                view.transform = CGAffineTransform(scaleX: Constants.zoomOutScale, y: Constants.zoomOutScale)
            }, completion: { _ in
                view.alpha = CGFloat(Int(truncating: NSNumber(value: !isFadeIn)))
            })
        })
    }
}

//MARK:- Helper Methods
extension ViewController {
    
    @objc func hideLines()  {
        self.firstView.isHidden = true
        self.secondView.isHidden = true
    }
    
    @objc func showPanView() {
        self.panView.isHidden = false
    }
    
    private func maskImage(y: CGFloat) {
        let maskLayer = CALayer()
        maskLayer.contents = firstImageView.image?.cgImage
        maskLayer.frame = CGRect(
            x: 0, y: y, width: self.secondImageView.width, height: self.secondImageView.height)
        self.firstImageView.layer.mask = maskLayer
    }
}

//MARK: - UIPanGestureRecognizer Method
extension ViewController {
    
    @objc private func didPan(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        
        ////Starting state of panview
        case .began: initialCenter = panView.center
            
        ////Moving state of  panview
        case .changed:
            
            let translation = sender.translation(in: panView)
            panView.center = CGPoint(x: initialCenter.x,
                                     y: initialCenter.y + translation.y)
            
            if panView.yPos < Device.top_padding - self.panView.height/2  {
                panView.frame = CGRect(
                    origin:  CGPoint(x: panView.xPos,
                                     y: Device.top_padding - self.panView.height/2),
                    size: panView.size
                )
            } else if panView.yPos > (Device.top_padding + Device.viewHeight) - self.panView.height/2 {
                panView.frame = CGRect(
                    origin: CGPoint(x: panView.xPos,
                                    y: (Device.top_padding + Device.viewHeight ) - self.panView.height/2),
                    size: panView.size
                )
            }
            maskImage(y: panView.midY - Device.top_padding)
            
        ////End State of panview
        case .ended :
            firstView.isHidden = false
            secondView.isHidden = false

            DispatchQueue.main.async {
                if self.panView.yPos < self.secondView.yPos && self.panView.yPos > self.firstView.yPos{
                    self.panView.isHidden = true
                    self.perform(#selector(self.hideLines), with: nil, afterDelay: 2)
                    self.perform(#selector(self.showPanView), with: nil, afterDelay: 2)
                    
                } else {
                    if self.panView.maxY < self.firstView.yPos && self.panView.yPos > Device.top_padding - self.panView.height   {
                        self.animateLabel(self.successLabel, isFadeIn: true, withDelay: 3)
                        self.blurView(time: 3)
                        self.successLabel.textColor = .red
                        self.successLabel.text = StatusType.dislike.rawValue
                        self.perform(#selector(self.hideLines), with: nil, afterDelay: 4)
                        
                    } else if self.panView.maxY > self.secondView.yPos && self.panView.yPos < Device.top_padding + Device.viewHeight{
                        self.animateLabel(self.successLabel, isFadeIn: true, withDelay: 3)
                        self.blurView(time: 7)
                        self.successLabel.textColor = .green
                        self.successLabel.text = StatusType.like.rawValue
                        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                            self.successLabel.layoutIfNeeded()
                            self.animateLabel(self.successLabel, isFadeIn: true, withDelay: 3)
                            self.successLabel.textColor = .cyan
                            self.successLabel.text = StatusType.matched.rawValue
                        }
                        self.perform(#selector(self.hideLines), with: nil, afterDelay: 8)
                    }
                }
            }
            blurredEffectView.removeFromSuperview()
        default:
            break
        }
    }
}
