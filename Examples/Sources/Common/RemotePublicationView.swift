//
//  RemotePublicationView.swift
//  RoomExample
//
//  Created by Naoto Takahashi on 2023/01/16.
//

import SwiftUI
import SkyWayRoom

struct RemotePublicationView: View {
    var skyway: SkyWayViewModel
    var publication: RoomPublication
    @State var subscription: RoomSubscription?
    @State var isSubscribed: Bool = false
    var body: some View {
        HStack{
            Image(systemName: isSubscribed ? "checkmark.circle.fill" : "circle")
                .foregroundColor(isSubscribed ? .green : .gray)
            Text("\(publication.contentType.toString())\npublished by \(publication.publisher!.id)")
                .font(.caption2)
            Spacer()
        }
        .contentShape(Rectangle())
        .onTapGesture {
            Task {
                if isSubscribed {
                    if let sub = subscription {
                        try? await skyway.unsubscribe(subscriptionId: sub.id)
                    }
                }else {
                    self.subscription = try? await skyway.subscribe(publication: publication)
                }
                isSubscribed = !isSubscribed
            }
        }
    }
}

//struct RemotePublicationView_Previews: PreviewProvider {
//    static var previews: some View {
//        var skyway: SkyWayViewModel = .init()
//        RemotePublicationView(skyway: skyway, publication:  publicationId)
//    }
//}
