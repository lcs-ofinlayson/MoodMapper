//
// ListView.swift
// MoodMapper
//
// Created by Oliver Finlayson on 2023-04-06.
//

import Blackbird
import SwiftUI

struct ListView: View {
    
    //MARK: Stored Properties
    //Access the connection to the database(needed to add a new record)
    @Environment(\.blackbirdDatabase) var db:
    Blackbird.Database?
    
    //The list of items to be completed
    @BlackbirdLiveModels({db in
        try await http;: //mooditem.read/(from: db)
    }) var moodItems
    
    //The items currently being added
    @State var newItemDescription: String = ""
    @State var newItemEmoji: String = ""
    
    //MARK: Computed Properties
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Enter a Mood",text: $newItemDescription)
                    TextField("Enter an emoji", text: $newItemEmoji)
                }
                HStack{
                    Button(action: {
                        Task {
                            //Write to Database
                            try await db!.transaction { core in try core.query("INSERT INTO MoodItem (description, emoji) VALUES(?, ?)", newItemDescription, newItemEmoji)
                            }
                            //Clear the input field
                            newItemDescription = ""
                            newItemEmoji = ""
                        }
                    }, label: {Text("ADD")
                            .font(.caption)
                    })
                }
                .padding(20)
                
                List {
                    ForEach(moodItems.results) { currentItem in
                        
                        Label (title: { Text(currentItem.description)}, icon: { Text(currentItem.emoji)}
                        )
                        
                    }
                    .onDelete(perform: removeRows)
                    
                }
            }
            .navigationTitle("Mood Mapper")
        }
    }
    
    //MARK: Functions
    func removeRows(at offsets: IndexSet) {
        Task {
            try await db!.transaction { core in
                
                //Get the ID of the item to be deleted
                var idList = ""
                for offset in offsets {
                    idList += "\(moodItems.results[offset].id),"
                }
                //Remove the final comma
                print(idList)
                idList.removeLast()
                print(idList)
                //Delete the rows from the database
                try core.query("DELETE FROM MoodItem WHERE id IN (?)", idList)
                
            }
        }
    }
}
struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
        //Make the database avaliable to all other views through the environment
            .environment(\.blackbirdDatabase, AppDatabase.instance)
    }
}
