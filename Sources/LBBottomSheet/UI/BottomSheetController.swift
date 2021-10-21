//  Copyright © 2021 Lunabee Studio
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//  BottomSheetController.swift
//  LBBottomSheet
//
//  Created by Lunabee Studio / Date - 12/10/2021 - for the LBBottomSheet Swift Package.
//

import UIKit

/// This class the main component of this package.
/// It is presented modally and embeds the controller you want to present as a bottom sheet.
public final class BottomSheetController: UIViewController {
    override public var modalPresentationStyle: UIModalPresentationStyle {
        get { .overFullScreen }
        set { }
    }

    public var topInset: CGFloat { (theme.grabber?.topMargin ?? 0.0) * 2.0 + (theme.grabber?.size.height ?? 0.0) }

    @IBOutlet private var mainDismissButton: UIButton!
    @IBOutlet private var grabberView: UIView!
    @IBOutlet private var gestureView: UIView!
    @IBOutlet private var topGrabberConstraint: NSLayoutConstraint!
    @IBOutlet private var widthGrabberConstraint: NSLayoutConstraint!
    @IBOutlet private var heightGrabberConstraint: NSLayoutConstraint!
    @IBOutlet private var bottomContainerView: UIView!
    @IBOutlet private var bottomContainerInnerView: UIView!
    @IBOutlet private var bottomContainerInnerViewTranslucentTopConstraint: NSLayoutConstraint!
    @IBOutlet private var bottomContainerInnerViewTopConstraint: NSLayoutConstraint!
    @IBOutlet private var bottomContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet private var bottomContainerBottomConstraint: NSLayoutConstraint!
    @IBOutlet private var bottomContainerLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private var bottomContainerTrailingConstraint: NSLayoutConstraint!

    private weak var bottomSheetPositionDelegate: BottomSheetPositionDelegate?

    private var theme: Theme = Theme()
    private var behavior: Behavior = Behavior()
    private let minTopMargin: CGFloat = 40.0
    private var didAlreadyUpdateHeight: Bool = false

    private var panGesture: UIPanGestureRecognizer?
    private var tapGesture: UITapGestureRecognizer?
    private var isGestureBeingActivated: Bool = false
    private var lastHeightAtPanGestureStart: CGFloat = 0.0
    private var lastContentOffsetAtPanGestureStart: CGPoint?
    private var bottomSheetChild: UIViewController!
    private var isChildAlreadyVisible: Bool = false
    private var defaultMaximumHeight: CGFloat {
        var topMargin: CGFloat = (UIApplication.shared.lbbsKeySceneWindow?.safeAreaInsets.top ?? 0.0)
        if let navController = presentingViewController as? UINavigationController ?? presentingViewController?.navigationController, !behavior.shouldShowAboveNavigationBar {
            topMargin = navController.navigationBar.frame.maxY + 8.0
        }
        return UIScreen.main.bounds.height - topMargin
    }
    private var childHeight: CGFloat {
        let propertiesName: [String] = Mirror.getTypesOfProperties(in: type(of: bottomSheetChild)) ?? []
        if !propertiesName.contains(BottomSheetConstant.preferredHeightVariableName) {
            print("⚠️ [LBBottomSheet] ⚠️: If you use the \"fitContent\" heightMode, you have to declare the following variable in the controller you want to present: \"@objc var preferredHeightInBottomSheet: CGFloat\" returning the height you want the bottom sheet to have.")
            return UIScreen.main.bounds.height * 0.75
        } else {
            var height: CGFloat = bottomSheetChild.value(forKey: BottomSheetConstant.preferredHeightVariableName) as? CGFloat ?? 0.0
            if let grabber = theme.grabber {
                switch grabber.background {
                case .color(_, let isTranslucent), .view(_, let isTranslucent):
                    if !isTranslucent { height += topInset }
                }
            }
            return height
        }
    }
    private var isFirstLoad: Bool = true

    /// Overriden to customize the way the controller is initialized.
    public override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        initGrabberBackgroundView()
        addGesture()
    }

    /// Overriden to customize the way the controller is appearing.
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard isFirstLoad else { return }
        isFirstLoad = false
        preferredHeightInBottomSheetDidUpdate()
        setInitialPosition()
        setupDimmingBackground()
        makeAppearing()
    }

    // TODO: To delete.
    deinit {
        print("\(type(of: self)) deallocated")
    }

    /// Call this function to tell the bottom sheet the embedded controller height did change.
    /// This way, this controller will calculate the new needed height and the bottom sheet layout will be updated.
    public func preferredHeightInBottomSheetDidUpdate() {
        panGesture?.cancel()
        let newHeight: CGFloat = calculateExpectedHeight()
        guard newHeight != bottomContainerHeightConstraint.constant else { return }
        bottomContainerHeightConstraint.constant = newHeight
        if didAlreadyUpdateHeight {
            UIView.animate(withDuration: 0.3) { self.view.layoutIfNeeded() }
        } else {
            view.layoutIfNeeded()
        }
    }

    /// Overriden to update the shadow color in case of light/dark mode change.
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateShadowColors()
    }
    
    /// Overriden to call the position delegate update method after a layout calculation.
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bottomSheetPositionDelegate?.bottomSheetPositionDidUpdate(y: view.frame.height - bottomContainerHeightConstraint.constant - bottomContainerBottomConstraint.constant)
    }

    /// Overriden to customize the way this controller is dismissed.
    public override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        if flag {
            makeDisappearing { super.dismiss(animated: false, completion: completion) }
        } else {
            super.dismiss(animated: false, completion: completion)
        }
    }
}

// MARK: - Controller instantiation -
internal extension BottomSheetController {
    static func controller(bottomSheetChild: UIViewController, bottomSheetRearController: BottomSheetPositionDelegate? = nil, theme: Theme = Theme(), behavior: Behavior = Behavior()) -> BottomSheetController {
        let bottomController: BottomSheetController = UIStoryboard(name: "BottomSheet", bundle: Bundle.module).instantiateInitialViewController() as! BottomSheetController
        bottomController.bottomSheetChild = bottomSheetChild
        bottomController.bottomSheetPositionDelegate = bottomSheetRearController
        bottomController.theme = theme
        bottomController.behavior = behavior
        return bottomController
    }
}

// MARK: - UI configuration -
private extension BottomSheetController {
    func initUI() {
        view.backgroundColor = .clear
        bottomContainerView.layer.cornerRadius = theme.cornerRadius
        bottomContainerView.layer.maskedCorners = theme.maskedCorners
        bottomContainerView.layer.masksToBounds = true
        bottomContainerView.alpha = 0.0

        if let grabber = theme.grabber {
            topGrabberConstraint.constant = grabber.topMargin
            widthGrabberConstraint.constant = grabber.size.width
            heightGrabberConstraint.constant = grabber.size.height
            grabberView.backgroundColor = grabber.color
            grabberView.layer.maskedCorners = grabber.maskedCorners
            grabberView.layer.masksToBounds = true
            switch grabber.cornerRadiusType {
            case .rounded:
                grabberView.layer.cornerRadius = grabber.size.height / 2.0
            case let .fixed(value):
                grabberView.layer.cornerRadius = value
            }
        } else {
            grabberView.isHidden = true
        }

        if let shadow = theme.shadow {
            updateShadowColors()
            view.layer.shadowOffset = shadow.offset
            view.layer.shadowOpacity = shadow.opacity
            view.layer.shadowRadius = shadow.radius
            view.layer.shouldRasterize = true
            view.layer.rasterizationScale = UIScreen.main.scale
        }

        addChildViewController(bottomSheetChild, containerView: bottomContainerInnerView)
        bottomContainerView.backgroundColor = bottomSheetChild.view.backgroundColor

        bottomContainerLeadingConstraint.constant = theme.leadingMargin
        bottomContainerTrailingConstraint.constant = theme.trailingMargin
    }

    func initGrabberBackgroundView() {
        guard let background = theme.grabber?.background else { return }
        switch background {
        case let .color(color, isTranslucent):
            let coloredView: UIView = UIView()
            coloredView.backgroundColor = color
            gestureView.lbbsAddFullSubview(coloredView, belowSubview: grabberView)
            updateBottomChildContainerTopConstraint(isGrabberBackgroundTranslucent: isTranslucent)
        case let .view(view, isTranslucent):
            gestureView.lbbsAddFullSubview(view, belowSubview: grabberView)
            updateBottomChildContainerTopConstraint(isGrabberBackgroundTranslucent: isTranslucent)
        }
    }

    func updateShadowColors() {
        guard let color = theme.shadow?.color.cgColor else { return }
        view.layer.shadowColor = color
    }

    func updateBottomChildContainerTopConstraint(isGrabberBackgroundTranslucent: Bool) {
        bottomContainerInnerViewTranslucentTopConstraint.isActive = isGrabberBackgroundTranslucent
        bottomContainerInnerViewTopConstraint.isActive = !isGrabberBackgroundTranslucent
    }

    func setInitialPosition() {
        bottomContainerBottomConstraint.constant = -calculateExpectedHeight()
        bottomContainerView.alpha = 1.0
        view.layoutIfNeeded()
    }

    func setupDimmingBackground() {
        if behavior.forwardEventsToRearController {
            mainDismissButton.isUserInteractionEnabled = false
            if let rearView = presentingViewController?.view {
                let view: ForwardingEventsView = self.view as! ForwardingEventsView
                view.destinationView = rearView
                view.excludedParentView = bottomContainerView
            }
        } else {
            mainDismissButton.isUserInteractionEnabled = true
        }
    }

    func addGesture() {
        guard behavior.swipeMode != .none else { return }
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerHandler(_:)))
        panGesture?.delegate = self
        view.addGestureRecognizer(panGesture!)
        if theme.grabber?.canTouchToDismiss == true {
            tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureRecognizerHandler(_:)))
            tapGesture?.delegate = self
            view.addGestureRecognizer(tapGesture!)
        }
    }
}

// MARK: - Appearing/Disappearing animations -
private extension BottomSheetController {
    func makeAppearing() {
        bottomContainerHeightConstraint.constant = calculateExpectedHeight()
        bottomContainerBottomConstraint.constant = 0.0
        UIView.animate(withDuration: behavior.appearingAnimationDuration, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.1, options: [.curveEaseOut], animations: {
            self.view.backgroundColor = self.theme.dimmingBackgroundColor
            self.view.layoutIfNeeded()
        }) { _ in
            self.didAlreadyUpdateHeight = true
        }
    }

    func makeDisappearing(_ completion: @escaping () -> ()) {
        bottomContainerBottomConstraint.constant = -bottomContainerHeightConstraint.constant
        UIView.animate(withDuration: behavior.disappearingAnimationDuration, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.1, options: [.curveEaseOut], animations: {
            self.view.backgroundColor = .clear
            self.view.layoutIfNeeded()
        }) { _ in
            completion()
        }
    }
}

// MARK: - Pan gesture management -
private extension BottomSheetController {
    @objc func panGestureRecognizerHandler(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            processPanGestureBegan(gesture)
            fallthrough
        case .changed:
            processPanGestureChanged(gesture)
        case .ended, .cancelled, .failed:
            processPanGestureEnded(gesture)
        default:
            break
        }
    }

    func processPanGestureBegan(_ gesture: UIPanGestureRecognizer) {
        tapGesture?.cancel()
        isGestureBeingActivated = true
        lastHeightAtPanGestureStart = bottomContainerHeightConstraint.constant
        lastContentOffsetAtPanGestureStart = bottomSheetChild.view.getFirstScrollView()?.contentOffset
    }

    func processPanGestureChanged(_ gesture: UIPanGestureRecognizer) {
        let yTranslation: CGFloat = gesture.translation(in: bottomContainerView).y
        let destinationHeight: CGFloat = lastHeightAtPanGestureStart - yTranslation
        let childHeight: CGFloat = childHeight
        let newHeight: CGFloat
        let newBottom: CGFloat
        let minHeight: CGFloat = behavior.heightMode.minimumHeight(with: childHeight, screenHeight: view.frame.height)
        let maxHeight: CGFloat = behavior.heightMode.maximumHeight(with: childHeight, screenHeight: view.frame.height, defaultMaximumHeight: defaultMaximumHeight)
        if destinationHeight > maxHeight {
            newHeight = maxHeight + behavior.elasticityFunction(destinationHeight - maxHeight)
            newBottom = 0.0
        } else if destinationHeight < minHeight {
            newHeight = minHeight
            newBottom = destinationHeight - minHeight
        } else {
            newHeight = destinationHeight
            newBottom = 0.0
        }
        bottomContainerHeightConstraint.constant = newHeight
        bottomContainerBottomConstraint.constant = newBottom
        view.layoutIfNeeded()
    }

    func processPanGestureEnded(_ gesture: UIPanGestureRecognizer) {
        let yTranslation: CGFloat = gesture.translation(in: bottomContainerView).y
        let yVelocity: CGFloat = gesture.velocity(in: bottomContainerView).y
        let maxHeight: CGFloat = behavior.heightMode.maximumHeight(with: childHeight, screenHeight: view.frame.height, defaultMaximumHeight: defaultMaximumHeight)
        if yTranslation > lastHeightAtPanGestureStart * behavior.heightPercentageThresholdToDismiss || yVelocity > behavior.velocityThresholdToDismiss {
            dismiss(animated: true)
        } else {
            let destinationMaximumHeight: CGFloat = yVelocity < -behavior.velocityThresholdToOpenAtMaxHeight ? maxHeight : calculateExpectedHeight()
            bottomContainerHeightConstraint.constant = destinationMaximumHeight
            bottomContainerBottomConstraint.constant = 0.0
            if let offset = self.lastContentOffsetAtPanGestureStart {
                bottomSheetChild.view.getFirstScrollView()?.contentOffset = offset
                lastContentOffsetAtPanGestureStart = nil
            }
            UIView.animate(withDuration: 0.2) { self.view.layoutIfNeeded() }
        }
        isGestureBeingActivated = false
    }

    func calculateExpectedHeight() -> CGFloat {
        let childHeight: CGFloat = childHeight
        switch behavior.heightMode {
        case .fitContent:
            return min(childHeight, defaultMaximumHeight)
        case let .free(minHeight, maxHeight):
            return min(max(bottomContainerHeightConstraint.constant, minHeight ?? 0.0), maxHeight ?? defaultMaximumHeight)
        case let .specific(values):
            let heightValues: [CGFloat] = values.sortedPointValues(screenHeight: view.frame.height, childHeight: childHeight)
            var matchingValue: CGFloat = 0.0
            for value in heightValues {
                guard abs(bottomContainerHeightConstraint.constant - value) < abs(bottomContainerHeightConstraint.constant - matchingValue) else { break }
                matchingValue = value
            }
            return matchingValue
        }
    }
}

// MARK: - Tap gesture management -
private extension BottomSheetController {
    @objc func tapGestureRecognizerHandler(_ gesture: UITapGestureRecognizer) {
        switch gesture.state {
        case .ended:
            dismiss(animated: true)
        default:
            break
        }
    }
}

// MARK: - Gestures delegates -
extension BottomSheetController: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer === tapGesture {
            return gestureView.frame.contains(gestureRecognizer.location(in: gestureView))
        } else if gestureRecognizer === panGesture {
            switch behavior.swipeMode {
            case .top:
                return gestureView.frame.contains(gestureRecognizer.location(in: gestureView))
            case .full:
                return view.frame.contains(gestureRecognizer.location(in: view))
            default:
                return false
            }
        } else {
            return true
        }
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGesture = panGesture, gestureRecognizer === panGesture {
            if let scrollView = otherGestureRecognizer.view as? UIScrollView {
                // In the case the user is swiping down, we have to check if we let the contained scrollView scrolling or if we have
                // to cancel the scrollView gesture to let the bottomSheet itself being swiped.
                let isSwipingFromGestureView: Bool = gestureView.frame.contains(gestureRecognizer.location(in: gestureView))
                let isTheMainEmbeddedViewAScrollView: Bool = scrollView.superview?.subviews.count == 1
                let isScrollViewAtTheTop: Bool = scrollView.contentOffset.y <= 0.0
                let isUserSwipingDown: Bool = panGesture.translation(in: view).y > 0
                if isSwipingFromGestureView || (isTheMainEmbeddedViewAScrollView && isScrollViewAtTheTop && isUserSwipingDown && behavior.swipeMode == .full) {
                    otherGestureRecognizer.cancel()
                    return true
                } else {
                    return false
                }
            } else {
                return true
            }
        } else {
            return true
        }
    }
}

// MARK: - Actions -
private extension BottomSheetController {
    @IBAction func dismissButtonPressed(_ sender: Any) {
        dismiss(animated: true)
    }
}
