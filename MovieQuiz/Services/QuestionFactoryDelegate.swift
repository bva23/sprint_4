//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Владимир Богомолов on 18.03.2023.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
}
