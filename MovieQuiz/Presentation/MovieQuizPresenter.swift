//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Владимир Богомолов on 17.04.2023.
//

import UIKit

final class MovieQuizPresenter {
    private var currentQuestionIndex: Int = 0
    let questionsAmount: Int = 10
    var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewController?
    var correctAnswers: Int = 0
    var questionFactory: QuestionFactoryProtocol?

    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }

    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }

    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }

    func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(image: UIImage(data: model.image) ?? UIImage(), question: model.text, questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }

    func yesButtonClicked() {
        didAnswer(isYes: true)
    }

    func noButtonClicked() {
        didAnswer(isYes: false)
    }

    private func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = isYes
        viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }

    func didRecieveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }

    func showNextQuestionOrResults() {
        viewController?.imageView.layer.borderWidth = 0
        viewController?.noButton.isEnabled = true
        viewController?.yesButton.isEnabled = true

        if self.isLastQuestion() {
            showFinalResults()
        } else {
            self.switchToNextQuestion()
            viewController?.questionFactory?.requestNextQuestion()
            viewController?.noButton.isEnabled = true
            viewController?.yesButton.isEnabled = true
        }
    }

    func showFinalResults() {
        viewController?.statisticService?.store(correct: correctAnswers, total: self.questionsAmount)

        guard let statisticService = viewController?.statisticService else {
            return
        }
        guard let bestGame = statisticService.bestGame else {
            return
        }

        let currentGameResultLine = "Ваш результат: \(correctAnswers)\\\(self.questionsAmount)"

        let text =
        """
        \(currentGameResultLine)
        Количество сыгранных квизов: \(statisticService.gamesCount)
        Рекорд: \(bestGame.correct)/10 (\(bestGame.date.dateTimeString))
        Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
        """

        let alertModel = AlertModel(
            title: "Этот раунд окончен!",
            message: text,
            buttonText: "Сыграть ещё раз") { [weak self] in
                self?.correctAnswers = 0
                self?.resetQuestionIndex()
                self?.viewController?.questionFactory?.requestNextQuestion()
        }
        viewController?.show(quiz: alertModel)
    }
}
