//
//  RecommendOutfitViewModel.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 29.12.2025.
//

import Foundation

struct OccasionItem: Identifiable, Equatable {
    let id: String
    let title: String
    let systemIconName: String
}

final class RecommendOutfitViewModel: ObservableObject {

    @Published private(set) var occasions: [OccasionItem] = []
    @Published var selectedOccasionID: String? = nil

    init() {
        occasions = Self.buildOccasions()
        selectedOccasionID = occasions.first?.id
    }

    func select(_ id: String) {
        selectedOccasionID = id
    }

    func generateTapped() {
        // TODO: call backend later
        // selectedOccasionID contains the selected item
    }

    private static func buildOccasions() -> [OccasionItem] {
        [
            // Work / formal
            .init(id: "work_meeting", title: "Work Meeting", systemIconName: "briefcase.fill"),
            .init(id: "office_day", title: "Office Day", systemIconName: "building.2.fill"),
            .init(id: "job_interview", title: "Job Interview", systemIconName: "person.crop.circle.badge.checkmark"),
            .init(id: "conference", title: "Conference", systemIconName: "person.3.fill"),
            .init(id: "presentation", title: "Presentation", systemIconName: "rectangle.3.group.fill"),
            .init(id: "business_dinner", title: "Business Dinner", systemIconName: "fork.knife"),

            // Social
            .init(id: "date_night", title: "Date Night", systemIconName: "wineglass.fill"),
            .init(id: "girls_night", title: "Girls’ Night", systemIconName: "sparkles"),
            .init(id: "party", title: "Party", systemIconName: "party.popper.fill"),
            .init(id: "birthday", title: "Birthday", systemIconName: "birthday.cake.fill"),
            .init(id: "brunch", title: "Brunch", systemIconName: "cup.and.saucer.fill"),
            .init(id: "dinner_out", title: "Dinner Out", systemIconName: "takeoutbag.and.cup.and.straw.fill"),
            .init(id: "coffee_run", title: "Coffee Run", systemIconName: "cup.and.saucer"),
            .init(id: "movie_night", title: "Movie Night", systemIconName: "popcorn.fill"),

            // Events
            .init(id: "wedding_guest", title: "Wedding Guest", systemIconName: "envelope.fill"),
            .init(id: "engagement", title: "Engagement", systemIconName: "gift.fill"),
            .init(id: "baby_shower", title: "Baby Shower", systemIconName: "figure.and.child.holdinghands"),
            .init(id: "graduation", title: "Graduation", systemIconName: "graduationcap.fill"),
            .init(id: "funeral", title: "Ceremony", systemIconName: "flower.fill"),
            .init(id: "holiday_event", title: "Holiday Event", systemIconName: "snowflake"),

            // Casual / daily
            .init(id: "casual_day", title: "Casual Day", systemIconName: "hanger"),
            .init(id: "errands", title: "Errands", systemIconName: "bag.fill"),
            .init(id: "home_relax", title: "At Home", systemIconName: "house.fill"),
            .init(id: "family_visit", title: "Family Visit", systemIconName: "person.2.fill"),
            .init(id: "school_pickup", title: "School Pick-up", systemIconName: "car.fill"),

            // Outdoors / travel
            .init(id: "city_walk", title: "City Walk", systemIconName: "figure.walk"),
            .init(id: "travel_day", title: "Travel Day", systemIconName: "airplane"),
            .init(id: "weekend_trip", title: "Weekend Trip", systemIconName: "suitcase.fill"),
            .init(id: "beach_day", title: "Beach Day", systemIconName: "sun.max.fill"),
            .init(id: "picnic", title: "Picnic", systemIconName: "leaf.fill"),
            .init(id: "festival", title: "Festival", systemIconName: "music.note.list"),

            // Fitness
            .init(id: "gym", title: "Gym", systemIconName: "dumbbell.fill"),
            .init(id: "yoga", title: "Yoga", systemIconName: "figure.yoga"),
            .init(id: "run", title: "Run", systemIconName: "figure.run"),
            .init(id: "hike", title: "Hike", systemIconName: "mountain.2.fill"),

            // Weather / special
            .init(id: "rainy_day", title: "Rainy Day", systemIconName: "cloud.rain.fill"),
            .init(id: "cold_day", title: "Cold Day", systemIconName: "thermometer.snowflake"),
            .init(id: "hot_day", title: "Hot Day", systemIconName: "thermometer.sun.fill")
        ]
    }
}
