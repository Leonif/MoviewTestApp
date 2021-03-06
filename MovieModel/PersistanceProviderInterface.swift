//
//  PersistanceProviderInterface.swift
//  MovieModel
//
//  Created by Nifantiev Leonid Dev on 06.03.2021.
//

public protocol PitchPersistenceProviderInterface {
  func fetchAllRecords<Entity: Persistanble>() -> [Entity]
  func fetchRecord<Entity: Persistanble>(with id: String) -> Entity?
  func saveRecord<Entity: Persistanble>(saveCode: @escaping (Entity) -> Void, completion: @escaping (Bool) -> Void)
  
  func removeRecord<Entity: Persistanble>(with id: String, from: Entity.Type)
  func removeAllRecord<Entity:Persistanble>(_: Entity.Type, callback: @escaping () -> Void)
}

