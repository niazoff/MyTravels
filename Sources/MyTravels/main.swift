import Foundation
import Publish
import Plot

struct MyTravels: Website {
  enum SectionID: String, WebsiteSectionID {
    case countries
    case cities
    case about
  }
  
  struct ItemMetadata: WebsiteItemMetadata {
    var arrivalDate: Date
    var departureDate: Date
    var transportation: Transportation
    
    enum Transportation: String, WebsiteItemMetadata {
      case car
      case train
      case plane
    }
  }
  
  var url = URL(string: "https://mytravels.com")!
  var name = "My Travels"
  var description = "Sharing my travels across the world"
  var language: Language { .english }
  var imagePath: Path? { nil }
}

try MyTravels().publish(
  withTheme: .basic,
  deployedUsing: .gitHub("niazoff/MyTravels", useSSH: false),
  additionalSteps: [
    .addItem(Item(
      path: "new-york-city",
      sectionID: .cities,
      metadata: MyTravels.ItemMetadata(
        arrivalDate: Date(),
        departureDate: Date().addingTimeInterval(60 * 60 * 24),
        transportation: .train),
      content: Content(
        title: "New York City",
        description: "The city that never sleeps.")))
  ]
)

extension Theme where Site == MyTravels {
  static var basic: Self {
    Theme(htmlFactory: BasicHTMLFactory())
  }
}

struct BasicHTMLFactory: HTMLFactory {
  func makeIndexHTML(for index: Index, context: PublishingContext<MyTravels>) throws -> HTML {
    HTML(
      .lang(context.site.language),
      .head(for: index, on: context.site),
      .body(
        // Header
        .h1(.text(context.site.name)),
        .h2(.text(context.site.description)),
        // Navigation
        .nav(.ul(
          .forEach(Site.SectionID.allCases) { section in
            .li(.a(
              .href(context.sections[section].path),
              .text(context.sections[section].title)
            ))
          }
        )),
        // Items
        .ul(.forEach(context.allItems(sortedBy: \.date, order: .descending)) { item in
          .li(
            .a(
              .href(item.path),
              .text(item.title)
            ),
            .p(.text(item.description))
          )
        })
      )
    )
  }
  
  func makeSectionHTML(for section: Section<MyTravels>, context: PublishingContext<MyTravels>) throws -> HTML {
    HTML()
  }
  
  func makeItemHTML(for item: Item<MyTravels>, context: PublishingContext<MyTravels>) throws -> HTML {
    HTML()
  }
  
  func makePageHTML(for page: Page, context: PublishingContext<MyTravels>) throws -> HTML {
    HTML()
  }
  
  func makeTagListHTML(for page: TagListPage, context: PublishingContext<MyTravels>) throws -> HTML? {
    nil
  }
  
  func makeTagDetailsHTML(for page: TagDetailsPage, context: PublishingContext<MyTravels>) throws -> HTML? {
    nil
  }
}
