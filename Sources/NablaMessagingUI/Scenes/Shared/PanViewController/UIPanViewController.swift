//
//  File.swift
//  
//
//  Created by Mathieu PERROUD on 07/03/2023.
//

import UIKit

open class UIPanViewController: UIViewController {
    // MARK: - Lifecycle
    open override func viewDidAppear(_ animated: Bool) {
        originalPosition = pannedView.center
    }
    
    // MARK: - Private
    
    private var originalPosition: CGPoint!
    private var pannedView: UIView!
    private lazy var background: UIView = makeBackground()
    private lazy var quitButton: UIButton = makeQuitButton()
    
    internal func setUpPan(with pannedView: UIView) {
        self.pannedView = pannedView
        
        view.addSubview(background)
        view.addSubview(pannedView)
        view.addSubview(quitButton)

        quitButton.translatesAutoresizingMaskIntoConstraints = false
        quitButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12).isActive = true
        quitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24).isActive = true
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPanImage(_:)))
        pannedView.addGestureRecognizer(panGestureRecognizer)
        pannedView.isUserInteractionEnabled = true
    }
    
    private func makeBackground() -> UIView {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return blurEffectView
    }
    
    private func makeQuitButton() -> UIButton {
        let crossImage = UIImage(systemName: "xmark")!
        let crossButton = UIButton(type: .custom)
        crossButton.setImage(crossImage, for: .normal)
        crossButton.addTarget(self, action: #selector(crossButtonTapped(_:)), for: .touchUpInside)
        crossButton.tintColor = .white
        return crossButton
    }
    
    @objc private func crossButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func didPanImage(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let panBeforeDismiss = view.frame.height / 4
        
        UIView.animate(withDuration: 0.333) { [unowned self] in
            quitButton.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
            quitButton.alpha = 0.01
        }
        
        switch sender.state {
        case .changed:
            pannedView.center = CGPoint(x: originalPosition.x + translation.x, y: originalPosition.y + translation.y)
            let progress = 1 - abs(translation.y) / (view.frame.height / 2)
            background.alpha = progress
            UIView.animate(withDuration: 0.333) { [unowned self] in
                pannedView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }
        case .ended:
            if abs(translation.y) > panBeforeDismiss {
                UIView.animate(
                    withDuration: 0.2,
                    animations: { [unowned self] in
                        pannedView.alpha = 0.01
                        pannedView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                    },
                    completion: { [unowned self] _ in
                        modalTransitionStyle = .crossDissolve
                        dismiss(animated: true, completion: nil)
                    }
                )
            }  else {
                UIView.animate(withDuration: 0.333) { [unowned self] in
                    background.alpha = 1
                    pannedView.center = originalPosition
                    pannedView.transform = CGAffineTransform(scaleX: 1, y: 1)
                    quitButton.transform = CGAffineTransform(scaleX: 1, y: 1)
                    quitButton.alpha = 1
                }
            }
        default:
            break
        }
    }
}
