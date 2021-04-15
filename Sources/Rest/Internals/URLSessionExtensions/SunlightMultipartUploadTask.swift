//
//  SunlightMultipartUploadTask.swift
//  UnionBroadcaster
//
//  Created by Bradley on 4/14/21.
//

import Combine
import Foundation

extension URLSession {

  public func sunlightMultipartUploadTaskPublisher(
    for url: URL
  ) -> SunlightMultipartUploadTaskPublisher {
    self.sunlightMultipartUploadTaskPublisher(for: URLRequest(url: url))
  }

  public func sunlightMultipartUploadTaskPublisher(
    for request: URLRequest
  ) -> SunlightMultipartUploadTaskPublisher {
    SunlightMultipartUploadTaskPublisher(request: request, session: self)
  }

  public struct SunlightMultipartUploadTaskPublisher: Publisher {

    public typealias Output = (
      payload: (data: Data?, progress: Progress),
      response: URLResponse?
    )
    public typealias Failure = URLError

    public let request: URLRequest
    public let session: URLSession

    public init(request: URLRequest, session: URLSession) {
      self.request = request
      self.session = session
    }

    public func receive<S>(
      subscriber: S
    ) where S: Subscriber,
            SunlightMultipartUploadTaskPublisher.Failure == S.Failure,
            SunlightMultipartUploadTaskPublisher.Output == S.Input
    {
      let subscription = SunlightMultipartUploadTaskSubscription(
        subscriber: subscriber,
        session: self.session,
        request: self.request
      )
      subscriber.receive(subscription: subscription)
    }
  }
}

extension URLSession {

  final class SunlightMultipartUploadTaskSubscription<
    SubscriberType: Subscriber
  >: Subscription where
    SubscriberType.Input == (
      payload: (data: Data?, progress: Progress),
      response: URLResponse?
    ),
    SubscriberType.Failure == URLError
  {
    private var subscriber: SubscriberType?
    private var session: URLSession
    private var request: URLRequest
    private var task: URLSessionDataTask?

    private var progress: NSKeyValueObservation?

    init(subscriber: SubscriberType, session: URLSession, request: URLRequest) {
      self.subscriber = subscriber
      self.session = session
      self.request = request
    }

    func request(_ demand: Subscribers.Demand) {
      guard demand > 0 else {
        return
      }

      self.task = self.session.dataTask(
        with: request
      ) { [weak self] data, response, error in
        if let error = error as? URLError {
          self?.subscriber?.receive(completion: .failure(error))
          return
        }

        guard let response = response else {
          self?.subscriber?.receive(
            completion: .failure(URLError(.badServerResponse))
          )
          return
        }

        _ = self?.subscriber?.receive((
          payload: (data: data, progress: Progress()),
          response: response
        ))
        self?.subscriber?.receive(completion: .finished)
      }

      if let task = self.task {
        self.progress = task.progress.observe(
          \.fractionCompleted
        ) { progress, _ in
          _ = self.subscriber?.receive((
            payload: (data: nil, progress: progress),
            response: nil
          ))
        }

        task.resume()
      }
    }

    func cancel() {
      if let task = self.task {
        task.cancel()
      }

      if let progress = self.progress {
        progress.invalidate()
      }
    }
  }
}

final class SunlightMultipartUploadTaskSubscriber: Subscriber {
  typealias Input = (
    payload: (data: Data?, progress: Progress),
    response: URLResponse?
  )
  typealias Failure = URLError

  var subscription: Subscription?

  func receive(subscription: Subscription) {
    self.subscription = subscription
    self.subscription?.request(.unlimited)
  }

  func receive(_ input: Input) -> Subscribers.Demand {
    return .unlimited
  }

  func receive(completion: Subscribers.Completion<Failure>) {
    self.subscription?.cancel()
    self.subscription = nil
  }
}
