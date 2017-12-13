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
    //  Constellation coordinates are adjusted to be relative to their respective region coordinates.
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
    func CreateRegionArray() {
        let labelElement = RegionLabel() as RegionLabel
        
        labelElement.id = 10000001
        labelElement.name = "Derelik"
        labelElement.posX = 3760
        labelElement.posY = 4264
        labelElement.posZ = 0
        RegionLabels.append(labelElement)
        labelElement.id = 10000002
        labelElement.name = "The Forge"
        labelElement.posX = 3664
        labelElement.posY = 2920
        labelElement.posZ = 0
        RegionLabels.append(labelElement)
        labelElement.id = 10000003
        labelElement.name = "Vale of the Silent"
        labelElement.posX = 3944
        labelElement.posY = 2392
        labelElement.posZ = 0
        RegionLabels.append(labelElement)
        labelElement.id = 10000004
        labelElement.name = "UUA-F4"
        labelElement.posX = 5024
        labelElement.posY = 1680
        labelElement.posZ = 0
        RegionLabels.append(labelElement)
        labelElement.id = 10000005
        labelElement.name = "Detorid"
        labelElement.posX = 5408
        labelElement.posY = 5304
        labelElement.posZ = 0
        RegionLabels.append(labelElement)
        labelElement.id = 10000006
        labelElement.name = "Wicked Creek"
        labelElement.posX = 5104
        labelElement.posY = 5040
        labelElement.posZ = 0
        RegionLabels.append(labelElement)
        labelElement.id = 10000007
        labelElement.name = "Cache"
        labelElement.posX = 6288
        labelElement.posY = 4432
        labelElement.posZ = 0
        RegionLabels.append(labelElement)
        labelElement.id = 10000008
        labelElement.name = "Scalding Pass"
        labelElement.posX = 4848
        labelElement.posY = 4832
        labelElement.posZ = 0
        RegionLabels.append(labelElement)
        labelElement.id = 10000009
        labelElement.name = "Insmother"
        labelElement.posX = 5552
        labelElement.posY = 4896
        labelElement.posZ = 0
        RegionLabels.append(labelElement)
        labelElement.id = 10000010
        labelElement.name = "Tribute"
        labelElement.posX = 3432
        labelElement.posY = 2064
        labelElement.posZ = 0
        RegionLabels.append(labelElement)
        labelElement.id = 10000011
        labelElement.name = "Great Wildlands"
        labelElement.posX = 4752
        labelElement.posY = 4336
        labelElement.posZ = 0
        RegionLabels.append(labelElement)
        labelElement.id = 10000012
        labelElement.name = "Curse"
        labelElement.posX = 4472
        labelElement.posY = 4936
        labelElement.posZ = 0
        RegionLabels.append(labelElement)
        labelElement.id = 10000013
        labelElement.name = "Malpais"
        labelElement.posX = 5696
        labelElement.posY = 3072
        labelElement.posZ = 0
        RegionLabels.append(labelElement)
        labelElement.id = 10000014
        labelElement.name = "Catch"
        labelElement.posX = 3480
        labelElement.posY = 5336
        labelElement.posZ = 0
        RegionLabels.append(labelElement)
        labelElement.id = 10000015
        labelElement.name = "Venal"
        labelElement.posX = 3408
        labelElement.posY = 1424
        labelElement.posZ = 0
        RegionLabels.append(labelElement)
        labelElement.id = 10000016
        labelElement.name = "Lonetrek"
        labelElement.posX = 2904
        labelElement.posY = 2584
        labelElement.posZ = 0
        RegionLabels.append(labelElement)
        labelElement.id = 10000017
        labelElement.name = "J7HZ-F"
        labelElement.posX = 4392
        labelElement.posY = 2000
        labelElement.posZ = 0
        RegionLabels.append(labelElement)
        labelElement.id = 10000018
        labelElement.name = "The Spire"
        labelElement.posX = 6152
        labelElement.posY = 3600
        labelElement.posZ = 0
        RegionLabels.append(labelElement)
        labelElement.id = 10000019
        labelElement.name = "A821-A"
        labelElement.posX = 4440
        labelElement.posY = 1592
        labelElement.posZ = 0
        RegionLabels.append(labelElement)
        labelElement.id = 10000020
        labelElement.name = "Tash-Murkon"
        labelElement.posX = 2712
        labelElement.posY = 4728
        labelElement.posZ = 0
        RegionLabels.append(labelElement)
        labelElement.id = 10000021
        labelElement.name = "Outer Passage"
        labelElement.posX = 6616
        labelElement.posY = 3144
        labelElement.posZ = 0
        RegionLabels.append(labelElement)
        labelElement.id = 10000022
        labelElement.name = "Stain"
        labelElement.posX = 3128
        labelElement.posY = 6136
        labelElement.posZ = 0
        RegionLabels.append(labelElement)
        labelElement.id = 10000023
        labelElement.name = "Pure Blind"
        labelElement.posX = 2376
        labelElement.posY = 2080
        labelElement.posZ = 0
        RegionLabels.append(labelElement)
        labelElement.id = 10000025
        labelElement.name = "Immensea"
        labelElement.posX = 4512
        labelElement.posY = 5376
        labelElement.posZ = 0
        RegionLabels.append(labelElement)
        labelElement.id = 10000027
        labelElement.name = "Etherium Reach"
        labelElement.posX = 5304
        labelElement.posY = 3488
        labelElement.posZ = 0
        RegionLabels.append(labelElement)
        labelElement.id = 10000028
        labelElement.name = "Molden Heath"
        labelElement.posX = 4040
        labelElement.posY = 3824
        labelElement.posZ = 0
        RegionLabels.append(labelElement)
        labelElement.id = 10000029
        labelElement.name = "Geminate"
        labelElement.posX = 4224
        labelElement.posY = 2880
        labelElement.posZ = 0
        RegionLabels.append(labelElement)
        labelElement.id = 10000030
        labelElement.name = "Heimatar"
        labelElement.posX = 3640
        labelElement.posY = 3576
        labelElement.posZ = 0
        RegionLabels.append(labelElement)
        labelElement.id = 10000031
        labelElement.name = "Impass"
        labelElement.posX = 4048
        labelElement.posY = 6376
        labelElement.posZ = 0
        RegionLabels.append(labelElement)
        labelElement.id = 10000032
        labelElement.name = "Sinq Laison"
        labelElement.posX = 2968
        labelElement.posY = 3456
        labelElement.posZ = 0
        RegionLabels.append(labelElement)
        labelElement.id = 10000033
        labelElement.name = "The Citadel"
        labelElement.posX = 3216
        labelElement.posY = 2968
        labelElement.posZ = 0
        RegionLabels.append(labelElement)
        labelElement.id = 10000034
        labelElement.name = "The Kalevala Expanse"
        labelElement.posX = 5384
        labelElement.posY = 3040
        labelElement.posZ = 0
        RegionLabels.append(labelElement)
        labelElement.id = 10000035
        labelElement.name = "Deklein"
        labelElement.posX = 2232
        labelElement.posY = 1416
        labelElement.posZ = 0
        RegionLabels.append(labelElement)
        labelElement.id = 10000036
        labelElement.name = "Devoid"
        labelElement.posX = 3264
        labelElement.posY = 4240
        labelElement.posZ = 0
        RegionLabels.append(labelElement)
        labelElement.id = 10000037
        labelElement.name = "Everyshore"
        labelElement.posX = 2832
        labelElement.posY = 3608
        labelElement.posZ = 0
        RegionLabels.append(labelElement)
        labelElement.id = 10000038
        labelElement.name = "The Bleak Lands"
        labelElement.posX = 3128
        labelElement.posY = 4160
        labelElement.posZ = 0
        RegionLabels.append(labelElement)
        labelElement.id = 10000039
        labelElement.name = "Esoteria"
        labelElement.posX = 3672
        labelElement.posY = 7032
        labelElement.posZ = 0
        RegionLabels.append(labelElement)
        labelElement.id = 10000040
        labelElement.name = "Oasa"
        labelElement.posX = 6128
        labelElement.posY = 2808
        labelElement.posZ = 0
        RegionLabels.append(labelElement)
        labelElement.id = 10000041
        labelElement.name = "Syndicate"
        labelElement.posX = 1872
        labelElement.posY = 3200
        labelElement.posZ = 0
        RegionLabels.append(labelElement)
        labelElement.id = 10000042
        labelElement.name = "Metropolis"
        labelElement.posX = 3792
        labelElement.posY = 3424
        labelElement.posZ = 0
        RegionLabels.append(labelElement)
        labelElement.id = 10000043
        labelElement.name = "Domain"
        labelElement.posX = 2824
        labelElement.posY = 4384
        labelElement.posZ = 0
        RegionLabels.append(labelElement)
        labelElement.id = 10000044
        labelElement.name = "Solitude"
        labelElement.posX = 1864
        labelElement.posY = 3640
        labelElement.posZ = 0
        RegionLabels.append(labelElement)
        labelElement.id = 10000045
        labelElement.name = "Tenal"
        labelElement.posX = 3800
        labelElement.posY = 456
        labelElement.posZ = 0
        RegionLabels.append(labelElement)
        labelElement.id = 10000046
        labelElement.name = "Fade"
        labelElement.posX = 2080
        labelElement.posY = 1784
        labelElement.posZ = 0
        RegionLabels.append(labelElement)
        labelElement.id = 10000047
        labelElement.name = "Providence"
        labelElement.posX = 3416
        labelElement.posY = 4936
        labelElement.posZ = 0
        RegionLabels.append(labelElement)
        labelElement.id = 10000048
        labelElement.name = "Placid"
        labelElement.posX = 2280
        labelElement.posY = 3024
        labelElement.posZ = 0
        RegionLabels.append(labelElement)
        labelElement.id = 10000049
        labelElement.name = "Khanid"
        labelElement.posX = 1872
        labelElement.posY = 4792
        labelElement.posZ = 0
        RegionLabels.append(labelElement)
        labelElement.id = 10000050
        labelElement.name = "Querious"
        labelElement.posX = 1568
        labelElement.posY = 5616
        labelElement.posZ = 0
        RegionLabels.append(labelElement)
        labelElement.id = 10000051
        labelElement.name = "Cloud Ring"
        labelElement.posX = 1904
        labelElement.posY = 2640
        labelElement.posZ = 0
        RegionLabels.append(labelElement)
        labelElement.id = 10000052
        labelElement.name = "Kador"
        labelElement.posX = 2512
        labelElement.posY = 4352
        labelElement.posZ = 0
        RegionLabels.append(labelElement)
        labelElement.id = 10000053
        labelElement.name = "Cobalt Edge"
        labelElement.posX = 6592
        labelElement.posY = 2184
        labelElement.posZ = 0
        RegionLabels.append(labelElement)
        labelElement.id = 10000054
        labelElement.name = "Aridia"
        labelElement.posX = 1496
        labelElement.posY = 4360
        labelElement.posZ = 0
        RegionLabels.append(labelElement)
        labelElement.id = 10000055
        labelElement.name = "Branch"
        labelElement.posX = 3232
        labelElement.posY = 616
        labelElement.posZ = 0
        RegionLabels.append(labelElement)
        labelElement.id = 10000056
        labelElement.name = "Feythabolis"
        labelElement.posX = 4576
        labelElement.posY = 6912
        labelElement.posZ = 0
        RegionLabels.append(labelElement)
        labelElement.id = 10000057
        labelElement.name = "Outer Ring"
        labelElement.posX = 1328
        labelElement.posY = 3104
        labelElement.posZ = 0
        RegionLabels.append(labelElement)
        labelElement.id = 10000058
        labelElement.name = "Fountain"
        labelElement.posX = 880
        labelElement.posY = 3824
        labelElement.posZ = 0
        RegionLabels.append(labelElement)
        labelElement.id = 10000059
        labelElement.name = "Paragon Soul"
        labelElement.posX = 3472
        labelElement.posY = 7480
        labelElement.posZ = 0
        RegionLabels.append(labelElement)
        labelElement.id = 10000060
        labelElement.name = "Delve"
        labelElement.posX = 1048
        labelElement.posY = 5744
        labelElement.posZ = 0
        RegionLabels.append(labelElement)
        labelElement.id = 10000061
        labelElement.name = "Tenerifis"
        labelElement.posX = 4712
        labelElement.posY = 6000
        labelElement.posZ = 0
        RegionLabels.append(labelElement)
        labelElement.id = 10000062
        labelElement.name = "Omist"
        labelElement.posX = 5160
        labelElement.posY = 6832
        labelElement.posZ = 0
        RegionLabels.append(labelElement)
        labelElement.id = 10000063
        labelElement.name = "Period Basis"
        labelElement.posX = 1168
        labelElement.posY = 6736
        labelElement.posZ = 0
        RegionLabels.append(labelElement)
        labelElement.id = 10000064
        labelElement.name = "Essence"
        labelElement.posX = 2656
        labelElement.posY = 3352
        labelElement.posZ = 0
        RegionLabels.append(labelElement)
        labelElement.id = 10000065
        labelElement.name = "Kor-Azor"
        labelElement.posX = 2056
        labelElement.posY = 4584
        labelElement.posZ = 0
        RegionLabels.append(labelElement)
        labelElement.id = 10000066
        labelElement.name = "Perrigen Falls"
        labelElement.posX = 5976
        labelElement.posY = 2944
        labelElement.posZ = 0
        RegionLabels.append(labelElement)
        labelElement.id = 10000067
        labelElement.name = "Genesis"
        labelElement.posX = 2352
        labelElement.posY = 3888
        labelElement.posZ = 0
        RegionLabels.append(labelElement)
        labelElement.id = 10000068
        labelElement.name = "Verge Vendor"
        labelElement.posX = 2440
        labelElement.posY = 3360
        labelElement.posZ = 0
        RegionLabels.append(labelElement)
        labelElement.id = 10000069
        labelElement.name = "Black Rise"
        labelElement.posX = 2656
        labelElement.posY = 2736
        labelElement.posZ = 0
        RegionLabels.append(labelElement)
    }  // CreateRegionLabels

}
