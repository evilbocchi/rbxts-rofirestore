declare namespace RoFirestore {
    interface FirestoreUserInfo {
        apikey: string;
        email: string;
        password: string;
        projectId: string;
    }

    interface AuthenticationResponse {
        idToken: string;
        refreshToken: string;
        expiresIn: string | number;
    }

    interface FirestoreGeoPoint {
        latitude: number;
        longitude: number;
    }

    interface FirestoreArrayValue {
        values?: FirestoreValue[];
    }

    interface FirestoreMapValue {
        fields: FirestoreFields;
    }

    interface FirestoreValue {
        stringValue?: string;
        integerValue?: string;
        doubleValue?: number;
        floatValue?: number;
        booleanValue?: boolean;
        geoPointValue?: FirestoreGeoPoint;
        mapValue?: FirestoreMapValue;
        timestampValue?: string;
        arrayValue?: FirestoreArrayValue;
    }

    type FirestoreFields = Record<string, FirestoreValue>;

    interface FirestoreDocument {
        name?: string;
        fields: FirestoreFields;
        createTime?: string;
        updateTime?: string;
    }

    type RobloxFirestoreValue =
        | string
        | number
        | boolean
        | Color3
        | Vector3
        | BrickColor
        | RobloxFirestoreMap
        | RobloxFirestoreArray
        | undefined;

    type RobloxFirestoreArray = Array<RobloxFirestoreValue>;

    interface RobloxFirestoreMap {
        [key: string]: RobloxFirestoreValue;
    }

    interface FieldsFixerModule {
        convertToRoblox(
            document: FirestoreDocument | { fields: FirestoreFields },
        ): RobloxFirestoreMap | RobloxFirestoreArray;
        convertToGQL<T extends RobloxFirestoreMap | RobloxFirestoreArray>(
            data: T,
        ): T extends RobloxFirestoreArray ? FirestoreValue[] : FirestoreFields;
    }

    interface FirestoreCollection {
        getDocument(docId: string): FirestoreDocument | undefined;
        getDocuments(): FirestoreDocument[] | undefined;
        createDocument(documentData: RobloxFirestoreMap, documentId?: string): FirestoreDocument | undefined;
        updateDocument(documentData: RobloxFirestoreMap, documentId: string): FirestoreDocument | undefined;
        deleteDocument(docId: string): void;
        deleteCollection(): void;
    }

    interface FirestoreApp {
        collection(collectionName: string): FirestoreCollection;
        init(authentication: AuthenticationResponse, userInfo: FirestoreUserInfo, debug?: boolean): this;
        _appendUri(uri: string): string;
        _renewAuth(): void;

        _token: string;
        _refreshToken: string;
        _refreshFrequency: number;
        _apiKey: string;
        _projectId: string;
        _debug: boolean;
        _baseUrl: string;
    }
}

declare module "@rbxts/rofirestore" {
    function firestore(userInfo: RoFirestore.FirestoreUserInfo, debug?: boolean): RoFirestore.FirestoreApp;
    namespace firestore {
        type FirestoreUserInfo = RoFirestore.FirestoreUserInfo;
        type AuthenticationResponse = RoFirestore.AuthenticationResponse;
        type FirestoreGeoPoint = RoFirestore.FirestoreGeoPoint;
        type FirestoreValue = RoFirestore.FirestoreValue;
        type FirestoreFields = RoFirestore.FirestoreFields;
        type FirestoreDocument = RoFirestore.FirestoreDocument;
        type RobloxFirestoreValue = RoFirestore.RobloxFirestoreValue;
        type RobloxFirestoreArray = RoFirestore.RobloxFirestoreArray;
        type RobloxFirestoreMap = RoFirestore.RobloxFirestoreMap;
        type FirestoreCollection = RoFirestore.FirestoreCollection;
        type FirestoreApp = RoFirestore.FirestoreApp;
        type FieldsFixerModule = RoFirestore.FieldsFixerModule;
    }
    export = firestore;
}
