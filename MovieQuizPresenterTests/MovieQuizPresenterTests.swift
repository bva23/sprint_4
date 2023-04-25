//
//  MovieQuizPresenterTests.swift
//  MovieQuizPresenterTests
//
//  Created by Владимир Богомолов on 23.04.2023.
//

import Foundation
import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    func show(quiz step: QuizStepViewModel) {
    }

    func show(quiz model: AlertModel) {
    }

    func highlightImageBorder(isCorrect: Bool) {
    }

    func hideImageBorder() {
    }

    func showLoadingIndicator() {
    }

    func hideLoadingIndicator() {
    }

    func showNetworkError(message: String) {
    }
}

final class MovieQuizPresenterTests: XCTestCase {
    func testPresenterConvertModel() throws {
        let viewControllerMock = MovieQuizViewControllerMock()
        let sut = MovieQuizPresenter(viewController: viewControllerMock)

        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: true)
        let viewModel = sut.convert(model: question)

        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, "Question Text")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
}
