//
//  DataBase.swift
//  EveDatabase
//
//  Created by Koulutus on 8.11.2017.
//  Copyright © 2017 ?. All rights reserved.
//

/*
 Files needed to use the functionality of this class:
 fmdb folder (remember bridging header!)
 eveDB.db
 System.swift file
 */


import Foundation

class DataBase {
    static let sharedInstance = DataBase();
    private var connectionToFMDB: FMDatabase;
    private let mainPath: URL! = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first;
    private let dbPath: String;
    
    private struct table_system {
        static let ID: String = "system_id";
        static let name: String = "name";
        static let constellationID: String = "constellation_id";
        static let securityStatus: String = "security_status";
        static let pX: String = "positionX";
        static let pY: String = "positionY";
        static let pZ: String = "positionZ";
    }
    
    private struct table_connections {
        static let ID: String = "connection_id";
        static let from: String = "system_from";
        static let to: String = "system_to";
    }
    
    private struct table_region {
        static let ID: String = "region_id";
        static let name: String = "name";
        static let description: String = "description";
    }
    
    private struct table_constellation {
        static let ID: String = "constellation_id";
        static let name: String = "name";
        static let region_id: String = "region_id";
        static let pX: String = "positionX";
        static let pY: String = "positionY";
        static let pZ: String = "positionZ";
    }
    
    private struct table_regionConstellations {
        static let region_id: String = "region_id";
        static let constellation_id: String = "constellation_id";
    }
    
    private struct table_constellationSystems {
        static let constellation_id: String = "constellation_id";
        static let system_id: String = "system_id";
    }
    
    
    func displayDBPath() {
        NSLog(self.dbPath);
    }
    
    init() {
        let databasePath: String? = Bundle.main.path(forResource: "EveDB", ofType: "db");
        
        self.dbPath = databasePath!;
        //NSLog("Database path: \(self.dbPath)");
        
        self.connectionToFMDB = FMDatabase(path: self.dbPath);
        
        displayDBPath();
        /*
         self.dbPath = mainPath.appendingPathComponent("EveDB.db").path;
         
         if !FileManager.default.fileExists(atPath: dbPath){
         self.connectionToFMDB = FMDatabase(path: dbPath);
         
         if (self.connectionToFMDB.open()) {
         connectionToFMDB.executeQuery("PRAGMA foreign_keys = ON", withArgumentsIn: []);
         
         connectionToFMDB.executeStatements( "CREATE TABLE IF NOT EXISTS System(" +
         "system_id INTEGER PRIMARY KEY  NOT NULL  UNIQUE," +
         "name TEXT NOT NULL," +
         "positionX INTEGER NOT NULL," +
         "positionY INTEGER NOT NULL," +
         "positionZ INTEGER NOT NULL);"
         );
         
         connectionToFMDB.executeStatements("CREATE TABLE IF NOT EXISTS Connections(" +
         "connection_id INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL," +
         "system_from INTEGER NOT NULL," +
         "system_to INTEGER NOT NULL," +
         "FOREIGN KEY(system_from) REFERENCES System(system_id)," +
         "FOREIGN KEY(system_to) REFERENCES System(system_id)," +
         "UNIQUE (system_from, system_to) ON CONFLICT IGNORE);"
         );
         
         //insertTestData();
         self.connectionToFMDB.close();
         }
         }else {
         self.connectionToFMDB = FMDatabase(path: dbPath);
         }
         */
    }
    
    private func insertTestData() {
        connectionToFMDB.executeStatements("INSERT INTO System (system_id, name, PositionX, PositionY, PositionZ) VALUES (1, 'system1', 1, 1, 1);");
        connectionToFMDB.executeStatements("INSERT INTO System (system_id, name, PositionX, PositionY, PositionZ) VALUES (2, 'system2', 2, 2, 2);");
        connectionToFMDB.executeStatements("INSERT INTO System (system_id, name, PositionX, PositionY, PositionZ) VALUES (3, 'system3', 3, 3, 3);");
        connectionToFMDB.executeStatements("INSERT INTO Connections (system_from, system_to) VALUES (1 , 2);");
        connectionToFMDB.executeStatements("INSERT INTO Connections (system_from, system_to) VALUES (1 , 3);");
    }
    
    func openDataBase() -> Bool {
        if !FileManager.default.fileExists(atPath: dbPath){ return false }
        if(self.connectionToFMDB.open()){
            do {
                try self.connectionToFMDB.executeQuery("PRAGMA foreign_keys = ON", values: nil);
            } catch {
                NSLog("Database opening failed: \(error.localizedDescription)");
                return false
            }
            return true
        }
        return false
    }
    
    func closeDatabase() {
        self.connectionToFMDB.close();
    }
    
    func addSystem(system: System) -> Bool {
        var succesfull: Bool = false;
        
        if openDataBase() {
            succesfull = connectionToFMDB.executeStatements("INSERT INTO System (" +
                "system_id, name, PositionX, PositionY, PositionZ) VALUES (" +
                "\(system.id), '\(system.name)', \(system.pX), \(system.pY), \(system.pZ));"
            );
            closeDatabase();
        }
        
        return succesfull;
    }
    
    func addConnection (from: Int, to: Int) -> Bool {
        var succesfull: Bool = false;
        
        if from == to {
            NSLog("Error, system cannot be connected to itself.");
            return false
        }
        
        if openDataBase() {
            succesfull = connectionToFMDB.executeStatements(
                "INSERT INTO Connections (system_from, system_to) " +
                    "SELECT \(from), \(to) WHERE NOT EXISTS(" +
                "SELECT system_from, system_to FROM Connections WHERE system_from=\(to) AND system_to=\(from));"
            );
            closeDatabase();
        }
        
        return succesfull
    }
    
    func addRegion (region: Region) {
        if openDataBase() {
            connectionToFMDB.executeStatements(
                "INSERT INTO Region (\(table_region.ID), \(table_region.name), \(table_region.description)) " +
                "VALUES (\(region.id), '\(region.name)', '\(region.description)');"
            );
            closeDatabase();
        }
    }
    
    func addConstellationToRegion (constellationID: Int, regionID: Int) {
        if openDataBase() {
            connectionToFMDB.executeStatements(
                "INSERT INTO regionConstellations (\(table_regionConstellations.region_id), \(table_regionConstellations.constellation_id)) " +
                "VALUES (\(regionID), \(constellationID));"
            );
            closeDatabase();
        }
    }
    
    func addConstellation (constellation: Constellation) {
        if openDataBase() {
            connectionToFMDB.executeStatements(
                "INSERT INTO Constellation (\(table_constellation.ID), \(table_constellation.name), \(table_constellation.region_id), \(table_constellation.pX), \(table_constellation.pY), \(table_constellation.pZ)) " +
                "VALUES (\(constellation.id), '\(constellation.name)', \(constellation.region), \(constellation.pX), \(constellation.pY), \(constellation.pZ));"
            );
            closeDatabase();
        }
    }
    
    func addSystemToConstellation (systemID: Int, constellationID: Int) {
        if openDataBase() {
            connectionToFMDB.executeStatements(
                "INSERT INTO constellationSystems (\(table_constellationSystems.constellation_id), \(table_constellationSystems.system_id)) " +
                "VALUES (\(constellationID), \(systemID));"
            );
            closeDatabase();
        }
    }

    private func generateSystem(result: FMResultSet) -> System {
        let system = System(id: Int(result.int(forColumn: table_system.ID)),
                            name: result.string(forColumn: table_system.name)!,
                            constellationID: Int(result.int(forColumn: table_system.constellationID)),
                            securityStatus: Double(result.double(forColumn: table_system.securityStatus)),
                            pX: Int(result.int(forColumn: table_system.pX)),
                            pY: Int(result.int(forColumn: table_system.pY)),
                            pZ: Int(result.int(forColumn: table_system.pZ)));
        return system
    }
    
    func getSystemByID(ID: Int) -> System? {
        var system: System?;
        
        if openDataBase() {
            let sqlStatement: String = "SELECT * FROM System WHERE system_id=?;";
            
            if let resultSet: FMResultSet = connectionToFMDB.executeQuery(sqlStatement, withArgumentsIn: [ID]) {
                if resultSet.next() == true{
                    system = generateSystem(result: resultSet);
                };
                resultSet.close();
            }
            closeDatabase();
        }
        
        return system;
    }
    
    /*
     Usage example:
     if let systems = DataBase.sharedInstance.getConnectionsTo(system: system) {
     // Access connected systems array here (ex. for sys in systems {sys.name;}).
     }else {
     // No connected systems found.
     }
     */
    func getConnectionsTo(system: System) -> [System]? {
        var systems: [System]?;
        
        if openDataBase() {
            let sqlStatement: String = "SELECT * FROM System, Connections WHERE " +
                "Connections.system_from=? AND Connections.system_to=System.system_id OR " +
            "Connections.system_from=System.system_id AND Connections.system_to=?;";
            
            if let resultSet: FMResultSet = self.connectionToFMDB.executeQuery(sqlStatement, withArgumentsIn: [system.id, system.id]) {
                while resultSet.next() == true{
                    if systems == nil {systems = [];}
                    systems?.append(generateSystem(result: resultSet));
                }
                resultSet.close();
            }
            closeDatabase();
        }
        
        return systems
    }
    
    //  Function reads constellation data from database and stores it to an array of constellation objects.
    func CreateConstellationsArray() {
        
        if openDataBase() {
            let sqlStatement: String = "SELECT * FROM Constellation;";
            
            do {
                let results = try self.connectionToFMDB.executeQuery(sqlStatement, values: nil)
                
                while results.next() {
                    let newConstellation = ConstellationLabel() as ConstellationLabel
                    newConstellation.id = Int(results.int(forColumn: "constellation_id"))
                    newConstellation.name = results.string(forColumn: "name")!
                    newConstellation.region = Int(results.int(forColumn: "region_id"))
                    newConstellation.pX = origin + Int(results.int(forColumn: "positionX")) / constellationScale
                    newConstellation.pY = origin - Int(results.int(forColumn: "positionY")) / constellationScale
                    newConstellation.pZ = Int(results.int(forColumn: "positionZ")) / constellationScale
                    Constellations.append(newConstellation)
                }
                results.close();
            }
            catch {
                print(error.localizedDescription)
            }
            
            closeDatabase();
        }
        
    }

    //  Function reads systems data from database and stores it to an array of system objects.
    func CreateSystemsArray() {
        var conIndex : Int = -1     // Constellation index.
        
        if openDataBase() {
            //let sqlStatement: String = "SELECT * FROM System;";
            let sqlStatement: String = "SELECT * FROM System INNER JOIN ConstellationSystems ON System.system_id=ConstellationSystems.system_id;";
            
            do {
                let results = try self.connectionToFMDB.executeQuery(sqlStatement, values: nil)
                
                while results.next() {
                    let newSystem = SystemButton() as SystemButton
                    newSystem.id = Int(results.int(forColumn: "system_id"))
                    newSystem.name = results.string(forColumn: "name")!
                    newSystem.constellation = Int(results.int(forColumn: table_constellationSystems.constellation_id));
                    newSystem.securityStatus = Double(results.double(forColumn: table_system.securityStatus));
                    //newSystem.color = UIColor.white

                    conIndex = locateConstellationIdByIndex(constellationIdToSearch: newSystem.constellation)
                    if conIndex >= 0 {
                        newSystem.posX = Constellations[conIndex].pX + (Int(results.int(forColumn: "PositionX")) / coordinateScale)
                        newSystem.posY = Constellations[conIndex].pY - (Int(results.int(forColumn: "PositionY")) / coordinateScaleY)
                        Systems.append(newSystem)
                    } else {
                        NSLog("CONSTELLATION NOT FOUND FOR SYSTEM")
                    }
                }
                results.close();
            }
            catch {
                print(error.localizedDescription)
            }
            
            closeDatabase();
        }
        
    }
    
    private func determineConnectionChange(systemID1: Int, SystemID2: Int) -> Int {
        var region: [Int] = [];
        var constellation: [Int] = [];
        
        if openDataBase() {
            let sqlStatement: String = "SELECT * FROM RegionConstellations INNER JOIN ConstellationSystems ON RegionConstellations.constellation_id=ConstellationSystems.constellation_id WHERE ConstellationSystems.system_id=? OR ConstellationSystems.system_id=?;";
            
            do {
                let results = try self.connectionToFMDB.executeQuery(sqlStatement, values: [systemID1, SystemID2]);
                
                while results.next() {
                    region.append(Int(results.int(forColumn: table_regionConstellations.region_id)));
                    constellation.append(Int(results.int(forColumn: table_constellationSystems.constellation_id)));
                }
                
                results.close();
            }
            catch {
                print(error.localizedDescription)
            }
            
            closeDatabase();
        }
        
        if region.count == 2 && constellation.count == 2 {
            if region[0] != region[1] {
                return 2;  //Region changes in transition
            }
            if constellation[0] != constellation[1] {
                return 1; //Constellation changes in transition
            }
        }
        
        // No region/constellation change in transition
        return 0;
    }
    
    // Newer ConnectorArray creator.
    func CreateConnectorArray() {
        var from: [Int] = [];
        var to: [Int] = [];
        
        if openDataBase() {
            let sqlStatement: String = "SELECT * FROM Connections;";
            
            do {
                let results = try self.connectionToFMDB.executeQuery(sqlStatement, values: nil)
                
                while results.next() {
                    from.append(Int(results.int(forColumn: table_connections.from)));
                    to.append(Int(results.int(forColumn: table_connections.to)));
                }
                
                results.close();
            }
            catch {
                print(error.localizedDescription)
            }
            
            closeDatabase();
        }
        
        for index in 0..<from.count {
            let systemFrom = locateSystemById(systemIdToSearch: from[index])
            let systemTo = locateSystemById(systemIdToSearch: to[index])
            let newConnection: SystemConnector = SystemConnector();
            newConnection.connection_id = [from[index], to[index]];
            newConnection.sourceX = Systems[systemFrom].posX;
            newConnection.sourceY = Systems[systemFrom].posY;
            newConnection.targetX = Systems[systemTo].posX;
            newConnection.targetY = Systems[systemTo].posY;
            newConnection.gateType = determineConnectionChange(systemID1: Systems[systemFrom].id, SystemID2: Systems[systemTo].id);
            Connectors.append(newConnection);
        }
    }
    
    //  Create region coordinates array.
    func CreateRegionCoordinates() {
        let coordinateArray = RegionLabel() as RegionLabel
        
        coordinateArray.id = 10000001
        coordinateArray.posX = 1024
        coordinateArray.posY = 1024
        coordinateArray.posZ = 0
        RegionLabels.append(coordinateArray)
        coordinateArray.id = 10000002
        coordinateArray.posX = 1024
        coordinateArray.posY = 2048
        coordinateArray.posZ = 0
        RegionLabels.append(coordinateArray)
        coordinateArray.id = 10000003
        coordinateArray.posX = 1024
        coordinateArray.posY = 2048
        coordinateArray.posZ = 0
        RegionLabels.append(coordinateArray)
        coordinateArray.id = 10000004
        coordinateArray.posX = 1024
        coordinateArray.posY = 2048
        coordinateArray.posZ = 0
        RegionLabels.append(coordinateArray)
        coordinateArray.id = 10000005
        coordinateArray.posX = 1024
        coordinateArray.posY = 2048
        coordinateArray.posZ = 0
        RegionLabels.append(coordinateArray)
        coordinateArray.id = 10000006
        coordinateArray.posX = 1024
        coordinateArray.posY = 2048
        coordinateArray.posZ = 0
        RegionLabels.append(coordinateArray)
        coordinateArray.id = 10000007
        coordinateArray.posX = 1024
        coordinateArray.posY = 2048
        coordinateArray.posZ = 0
        RegionLabels.append(coordinateArray)
        coordinateArray.id = 10000008
        coordinateArray.posX = 1024
        coordinateArray.posY = 2048
        coordinateArray.posZ = 0
        RegionLabels.append(coordinateArray)
/*
     10000009,
     10000010,
     10000011,
     10000012,
     10000013,
     10000014,
     10000015,
     10000016,
     10000017,
     10000018,
     10000019,
     10000020,
     10000021,
     10000022,
     10000023,
     10000025,
     10000027,
     10000028,
     10000029,
     10000030,
     10000031,
     10000032,
     10000033,
     10000034,
     10000035,
     10000036,
     10000037,
     10000038,
     10000039,
     10000040,
     10000041,
     10000042,
     10000043,
     10000044,
     10000045,
     10000046,
     10000047,
     10000048,
     10000049,
     10000050,
     10000051,
     10000052,
     10000053,
     10000054,
     10000055,
     10000056,
     10000057,
     10000058,
     10000059,
     10000060,
     10000061,
     10000062,
     10000063,
     10000064,
     10000065,
     10000066,
     10000067,
     10000068,
     10000069,
     11000001,
     11000002,
     11000003,
     11000004,
     11000005,
     11000006,
     11000007,
     11000008,
     11000009,
     11000010,
     11000011,
     11000012,
     11000013,
     11000014,
     11000015,
     11000016,
     11000017,
     11000018,
     11000019,
     11000020,
     11000021,
     11000022,
     11000023,
     11000024,
     11000025,
     11000026,
     11000027,
     11000028,
     11000029,
     11000030,
     11000031,
     11000032,
     11000033
     ] */
    }  // CreateRegionCoordinates
    
}
