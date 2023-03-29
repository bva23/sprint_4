//
//  AlertPresenterDelegate.swift
//  MovieQuiz
//
//  Created by Владимир Богомолов on 19.03.2023.
//

import UIKit

protocol AlertPresenterDelegate: AnyObject {
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?)
}
