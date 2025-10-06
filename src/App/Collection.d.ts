declare const collectionFactory: (
    app: RoFirestore.FirestoreApp,
    collectionId: string,
) => RoFirestore.FirestoreCollection;
export = collectionFactory;
