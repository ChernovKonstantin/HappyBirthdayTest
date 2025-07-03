protocol PersistenceService {
    func getBaby() throws -> BabyData
        func saveBaby(_ baby: BabyData) throws
        func deleteBaby() throws
}
