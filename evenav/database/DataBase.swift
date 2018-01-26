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
            var regionIndex : Int = -1
            var regX : Int = origin
            var regY : Int = origin

            let sqlStatement: String = "SELECT * FROM Constellation;";
            do {
                let results = try self.connectionToFMDB.executeQuery(sqlStatement, values: nil)
                
                while results.next() {
                    let newConstellation = ConstellationLabel() as ConstellationLabel
                    newConstellation.id = Int(results.int(forColumn: "constellation_id"))
                    newConstellation.name = results.string(forColumn: "name")!
                    newConstellation.region = Int(results.int(forColumn: "region_id"))
                    
                    //  Getting region coordinates from array.
                    regionIndex = locateRegionById(regionIdToSearch: newConstellation.region)
                    if regionIndex >= 0 {
                        if RegionLabels[regionIndex].name == "Outer Ring" || RegionLabels[regionIndex].name == "Fountain" || RegionLabels[regionIndex].name == "Delve" || RegionLabels[regionIndex].name == "Aridia" || RegionLabels[regionIndex].name == "Querious" || RegionLabels[regionIndex].name == "Period Basis" {
                            //print(RegionLabels[regionIndex].name, RegionLabels[regionIndex].posX, RegionLabels[regionIndex].posY)
                            regX = 5200
                        } else {
                            regX = origin
                        }
                        //regX = RegionLabels[regionIndex].posX
                        regY = RegionLabels[regionIndex].posY
                        //regY = origin
                        newConstellation.pX = regX + (Int(results.int(forColumn: "positionX")) / constellationScale)
                        newConstellation.pY = regY - (Int(results.int(forColumn: "positionY")) / constellationScale)
                        
                        if newConstellation.pX < 1 || newConstellation.pX > 8192 || newConstellation.pY < 1 || newConstellation.pY > 8192 {
                            print("CONST OFF GRID:", newConstellation.name, newConstellation.pX, newConstellation.pY)
                        }
                        
                        newConstellation.pZ = Int(results.int(forColumn: "positionZ")) / constellationScale
                        Constellations.append(newConstellation)
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
                    conIndex = locateConstellationIdByIndex(constellationIdToSearch: newSystem.constellation)
                    if conIndex >= 0 {
                        newSystem.posX = Constellations[conIndex].pX + (Int(results.int(forColumn: "PositionX")) / coordinateScale)
                        newSystem.posY = Constellations[conIndex].pY - (Int(results.int(forColumn: "PositionY")) / coordinateScaleY)
                        newSystem.region = Constellations[conIndex].region
                        Systems.append(newSystem)
                    //} else {
                    //    NSLog("CONSTELLATION NOT FOUND FOR SYSTEM: \(newSystem.name)")
                    }
                }
                results.close();
            }
            catch {
                print(error.localizedDescription)
            }
            
            closeDatabase();
            
            Systems = Systems.sorted(by: {$0.name < $1.name})
        }
        
    }
    
    private func determineConnectionChange(system1: SystemButton, System2: SystemButton) -> Int {
        if system1.region != System2.region {
            return 2;  //Region changes in transition
        }
        if system1.constellation != System2.constellation {
            return 1; //Constellation changes in transition
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
            if systemFrom >= 0 && systemTo >= 0 {
                let newConnection: SystemConnector = SystemConnector();
                newConnection.connection_id = [from[index], to[index]];
                newConnection.sourceX = Systems[systemFrom].posX;
                newConnection.sourceY = Systems[systemFrom].posY;
                newConnection.targetX = Systems[systemTo].posX;
                newConnection.targetY = Systems[systemTo].posY;
                newConnection.gateType = determineConnectionChange(system1: Systems[systemFrom], System2: Systems[systemTo]);
                Connectors.append(newConnection);
            }
        }
    }

    //  Creating region coordinates array.
    //  Region coordinates are absolute coordinates inside UIView.
    func CreateRegionArray() {
        let labelR01 = RegionLabel() as RegionLabel
        labelR01.id = 10000001
        labelR01.name = "Derelik"
        labelR01.posX = 3760
        labelR01.posY = 4264
        labelR01.posZ = 0
        RegionLabels.append(labelR01)
        let labelR02 = RegionLabel() as RegionLabel
        labelR02.id = 10000002
        labelR02.name = "The Forge"
        labelR02.posX = 3664
        labelR02.posY = 2920
        labelR02.posZ = 0
        RegionLabels.append(labelR02)
        let labelR03 = RegionLabel() as RegionLabel
        labelR03.id = 10000003
        labelR03.name = "Vale of the Silent"
        labelR03.posX = 3944
        labelR03.posY = 2392
        labelR03.posZ = 0
        RegionLabels.append(labelR03)
        /*let labelR04 = RegionLabel() as RegionLabel
        labelR04.id = 10000004
        labelR04.name = "UUA-F4"
        labelR04.posX = 5024
        labelR04.posY = 2000 // 1680
        labelR04.posZ = 0
        RegionLabels.append(labelR04)*/
        let labelR05 = RegionLabel() as RegionLabel
        labelR05.id = 10000005
        labelR05.name = "Detorid"
        labelR05.posX = 5408
        labelR05.posY = 5304
        labelR05.posZ = 0
        RegionLabels.append(labelR05)
        let labelR06 = RegionLabel() as RegionLabel
        labelR06.id = 10000006
        labelR06.name = "Wicked Creek"
        labelR06.posX = 5104
        labelR06.posY = 5040
        labelR06.posZ = 0
        RegionLabels.append(labelR06)
        let labelR07 = RegionLabel() as RegionLabel
        labelR07.id = 10000007
        labelR07.name = "Cache"
        labelR07.posX = 6288
        labelR07.posY = 4432
        labelR07.posZ = 0
        RegionLabels.append(labelR07)
        let labelR08 = RegionLabel() as RegionLabel
        labelR08.id = 10000008
        labelR08.name = "Scalding Pass"
        labelR08.posX = 4848
        labelR08.posY = 4832
        labelR08.posZ = 0
        RegionLabels.append(labelR08)
        let labelR09 = RegionLabel() as RegionLabel
        labelR09.id = 10000009
        labelR09.name = "Insmother"
        labelR09.posX = 5552
        labelR09.posY = 4896
        labelR09.posZ = 0
        RegionLabels.append(labelR09)
        let labelR10 = RegionLabel() as RegionLabel
        labelR10.id = 10000010
        labelR10.name = "Tribute"
        labelR10.posX = 3432
        labelR10.posY = 2064
        labelR10.posZ = 0
        RegionLabels.append(labelR10)
        let labelR11 = RegionLabel() as RegionLabel
        labelR11.id = 10000011
        labelR11.name = "Great Wildlands"
        labelR11.posX = 4752
        labelR11.posY = 4336
        labelR11.posZ = 0
        RegionLabels.append(labelR11)
        let labelR12 = RegionLabel() as RegionLabel
        labelR12.id = 10000012
        labelR12.name = "Curse"
        labelR12.posX = 4472
        labelR12.posY = 4936
        labelR12.posZ = 0
        RegionLabels.append(labelR12)
        let labelR13 = RegionLabel() as RegionLabel
        labelR13.id = 10000013
        labelR13.name = "Malpais"
        labelR13.posX = 5696
        labelR13.posY = 3072
        labelR13.posZ = 0
        RegionLabels.append(labelR13)
        let labelR14 = RegionLabel() as RegionLabel
        labelR14.id = 10000014
        labelR14.name = "Catch"
        labelR14.posX = 3480
        labelR14.posY = 5336
        labelR14.posZ = 0
        RegionLabels.append(labelR14)
        let labelR15 = RegionLabel() as RegionLabel
        labelR15.id = 10000015
        labelR15.name = "Venal"
        labelR15.posX = 3408
        labelR15.posY = 1424
        labelR15.posZ = 0
        RegionLabels.append(labelR15)
        let labelR16 = RegionLabel() as RegionLabel
        labelR16.id = 10000016
        labelR16.name = "Lonetrek"
        labelR16.posX = 2904
        labelR16.posY = 2584
        labelR16.posZ = 0
        RegionLabels.append(labelR16)
        /*let labelR17 = RegionLabel() as RegionLabel
        labelR17.id = 10000017
        labelR17.name = "J7HZ-F"
        labelR17.posX = 4392
        labelR17.posY = 2000
        labelR17.posZ = 0
        RegionLabels.append(labelR17)*/
        let labelR18 = RegionLabel() as RegionLabel
        labelR18.id = 10000018
        labelR18.name = "The Spire"
        labelR18.posX = 6152
        labelR18.posY = 3600
        labelR18.posZ = 0
        RegionLabels.append(labelR18)
        /*let labelR19 = RegionLabel() as RegionLabel
        labelR19.id = 10000019
        labelR19.name = "A821-A"
        labelR19.posX = 4440
        labelR19.posY = 1592
        labelR19.posZ = 0
        RegionLabels.append(labelR19)*/
        let labelR20 = RegionLabel() as RegionLabel
        labelR20.id = 10000020
        labelR20.name = "Tash-Murkon"
        labelR20.posX = 2712
        labelR20.posY = 4728
        labelR20.posZ = 0
        RegionLabels.append(labelR20)
        let labelR21 = RegionLabel() as RegionLabel
        labelR21.id = 10000021
        labelR21.name = "Outer Passage"
        labelR21.posX = 6616
        labelR21.posY = 3144
        labelR21.posZ = 0
        RegionLabels.append(labelR21)
        let labelR22 = RegionLabel() as RegionLabel
        labelR22.id = 10000022
        labelR22.name = "Stain"
        labelR22.posX = 3128
        labelR22.posY = 6136
        labelR22.posZ = 0
        RegionLabels.append(labelR22)
        let labelR23 = RegionLabel() as RegionLabel
        labelR23.id = 10000023
        labelR23.name = "Pure Blind"
        labelR23.posX = 2376
        labelR23.posY = 2080
        labelR23.posZ = 0
        RegionLabels.append(labelR23)
        let labelR25 = RegionLabel() as RegionLabel
        labelR25.id = 10000025
        labelR25.name = "Immensea"
        labelR25.posX = 4512
        labelR25.posY = 5376
        labelR25.posZ = 0
        RegionLabels.append(labelR25)
        let labelR27 = RegionLabel() as RegionLabel
        labelR27.id = 10000027
        labelR27.name = "Etherium Reach"
        labelR27.posX = 5304
        labelR27.posY = 3488
        labelR27.posZ = 0
        RegionLabels.append(labelR27)
        let labelR28 = RegionLabel() as RegionLabel
        labelR28.id = 10000028
        labelR28.name = "Molden Heath"
        labelR28.posX = 4040
        labelR28.posY = 3824
        labelR28.posZ = 0
        RegionLabels.append(labelR28)
        let labelR29 = RegionLabel() as RegionLabel
        labelR29.id = 10000029
        labelR29.name = "Geminate"
        labelR29.posX = 4224
        labelR29.posY = 2880
        labelR29.posZ = 0
        RegionLabels.append(labelR29)
        let labelR30 = RegionLabel() as RegionLabel
        labelR30.id = 10000030
        labelR30.name = "Heimatar"
        labelR30.posX = 3640
        labelR30.posY = 3576
        labelR30.posZ = 0
        RegionLabels.append(labelR30)
        let labelR31 = RegionLabel() as RegionLabel
        labelR31.id = 10000031
        labelR31.name = "Impass"
        labelR31.posX = 4048
        labelR31.posY = 6376
        labelR31.posZ = 0
        RegionLabels.append(labelR31)
        let labelR32 = RegionLabel() as RegionLabel
        labelR32.id = 10000032
        labelR32.name = "Sinq Laison"
        labelR32.posX = 2968
        labelR32.posY = 3456
        labelR32.posZ = 0
        RegionLabels.append(labelR32)
        let labelR33 = RegionLabel() as RegionLabel
        labelR33.id = 10000033
        labelR33.name = "The Citadel"
        labelR33.posX = 3216
        labelR33.posY = 2968
        labelR33.posZ = 0
        RegionLabels.append(labelR33)
        let labelR34 = RegionLabel() as RegionLabel
        labelR34.id = 10000034
        labelR34.name = "The Kalevala Expanse"
        labelR34.posX = 5384
        labelR34.posY = 3040
        labelR34.posZ = 0
        RegionLabels.append(labelR34)
        let labelR35 = RegionLabel() as RegionLabel
        labelR35.id = 10000035
        labelR35.name = "Deklein"
        labelR35.posX = 2232
        labelR35.posY = 1416
        labelR35.posZ = 0
        RegionLabels.append(labelR35)
        let labelR36 = RegionLabel() as RegionLabel
        labelR36.id = 10000036
        labelR36.name = "Devoid"
        labelR36.posX = 3264
        labelR36.posY = 4240
        labelR36.posZ = 0
        RegionLabels.append(labelR36)
        let labelR37 = RegionLabel() as RegionLabel
        labelR37.id = 10000037
        labelR37.name = "Everyshore"
        labelR37.posX = 2832
        labelR37.posY = 3608
        labelR37.posZ = 0
        RegionLabels.append(labelR37)
        let labelR38 = RegionLabel() as RegionLabel
        labelR38.id = 10000038
        labelR38.name = "The Bleak Lands"
        labelR38.posX = 3128
        labelR38.posY = 4160
        labelR38.posZ = 0
        RegionLabels.append(labelR38)
        let labelR39 = RegionLabel() as RegionLabel
        labelR39.id = 10000039
        labelR39.name = "Esoteria"
        labelR39.posX = 3672
        labelR39.posY = 7032
        labelR39.posZ = 0
        RegionLabels.append(labelR39)
        let labelR40 = RegionLabel() as RegionLabel
        labelR40.id = 10000040
        labelR40.name = "Oasa"
        labelR40.posX = 6128
        labelR40.posY = 2808
        labelR40.posZ = 0
        RegionLabels.append(labelR40)
        let labelR41 = RegionLabel() as RegionLabel
        labelR41.id = 10000041
        labelR41.name = "Syndicate"
        labelR41.posX = 1872
        labelR41.posY = 3200
        labelR41.posZ = 0
        RegionLabels.append(labelR41)
        let labelR42 = RegionLabel() as RegionLabel
        labelR42.id = 10000042
        labelR42.name = "Metropolis"
        labelR42.posX = 3792
        labelR42.posY = 3424
        labelR42.posZ = 0
        RegionLabels.append(labelR42)
        let labelR43 = RegionLabel() as RegionLabel
        labelR43.id = 10000043
        labelR43.name = "Domain"
        labelR43.posX = 2824
        labelR43.posY = 4384
        labelR43.posZ = 0
        RegionLabels.append(labelR43)
        let labelR44 = RegionLabel() as RegionLabel
        labelR44.id = 10000044
        labelR44.name = "Solitude"
        labelR44.posX = 1864
        labelR44.posY = 3640
        labelR44.posZ = 0
        RegionLabels.append(labelR44)
        let labelR45 = RegionLabel() as RegionLabel
        labelR45.id = 10000045
        labelR45.name = "Tenal"
        labelR45.posX = 3800
        labelR45.posY = 1200 // 456
        labelR45.posZ = 0
        RegionLabels.append(labelR45)
        let labelR46 = RegionLabel() as RegionLabel
        labelR46.id = 10000046
        labelR46.name = "Fade"
        labelR46.posX = 2080
        labelR46.posY = 1784
        labelR46.posZ = 0
        RegionLabels.append(labelR46)
        let labelR47 = RegionLabel() as RegionLabel
        labelR47.id = 10000047
        labelR47.name = "Providence"
        labelR47.posX = 3416
        labelR47.posY = 4936
        labelR47.posZ = 0
        RegionLabels.append(labelR47)
        let labelR48 = RegionLabel() as RegionLabel
        labelR48.id = 10000048
        labelR48.name = "Placid"
        labelR48.posX = 2280
        labelR48.posY = 3024
        labelR48.posZ = 0
        RegionLabels.append(labelR48)
        let labelR49 = RegionLabel() as RegionLabel
        labelR49.id = 10000049
        labelR49.name = "Khanid"
        labelR49.posX = 1872
        labelR49.posY = 4792
        labelR49.posZ = 0
        RegionLabels.append(labelR49)
        let labelR50 = RegionLabel() as RegionLabel
        labelR50.id = 10000050
        labelR50.name = "Querious"
        labelR50.posX = 1568
        labelR50.posY = 5616
        labelR50.posZ = 0
        RegionLabels.append(labelR50)
        let labelR51 = RegionLabel() as RegionLabel
        labelR51.id = 10000051
        labelR51.name = "Cloud Ring"
        labelR51.posX = 1904
        labelR51.posY = 2640
        labelR51.posZ = 0
        RegionLabels.append(labelR51)
        let labelR52 = RegionLabel() as RegionLabel
        labelR52.id = 10000052
        labelR52.name = "Kador"
        labelR52.posX = 2512
        labelR52.posY = 4352
        labelR52.posZ = 0
        RegionLabels.append(labelR52)
        let labelR53 = RegionLabel() as RegionLabel
        labelR53.id = 10000053
        labelR53.name = "Cobalt Edge"
        labelR53.posX = 6592
        labelR53.posY = 2184
        labelR53.posZ = 0
        RegionLabels.append(labelR53)
        let labelR54 = RegionLabel() as RegionLabel
        labelR54.id = 10000054
        labelR54.name = "Aridia"
        labelR54.posX = 1496
        labelR54.posY = 4360
        labelR54.posZ = 0
        RegionLabels.append(labelR54)
        let labelR55 = RegionLabel() as RegionLabel
        labelR55.id = 10000055
        labelR55.name = "Branch"
        labelR55.posX = 3232
        labelR55.posY = 1000 // 616
        labelR55.posZ = 0
        RegionLabels.append(labelR55)
        let labelR56 = RegionLabel() as RegionLabel
        labelR56.id = 10000056
        labelR56.name = "Feythabolis"
        labelR56.posX = 4576
        labelR56.posY = 6912
        labelR56.posZ = 0
        RegionLabels.append(labelR56)
        let labelR57 = RegionLabel() as RegionLabel
        labelR57.id = 10000057
        labelR57.name = "Outer Ring"
        labelR57.posX = 1328
        labelR57.posY = 3104
        labelR57.posZ = 0
        RegionLabels.append(labelR57)
        let labelR58 = RegionLabel() as RegionLabel
        labelR58.id = 10000058
        labelR58.name = "Fountain"
        labelR58.posX = 4000 // 880
        labelR58.posY = 3824
        labelR58.posZ = 0
        RegionLabels.append(labelR58)
        let labelR59 = RegionLabel() as RegionLabel
        labelR59.id = 10000059
        labelR59.name = "Paragon Soul"
        labelR59.posX = 3472
        labelR59.posY = 7480
        labelR59.posZ = 0
        RegionLabels.append(labelR59)
        let labelR60 = RegionLabel() as RegionLabel
        labelR60.id = 10000060
        labelR60.name = "Delve"
        labelR60.posX = 1048
        labelR60.posY = 5744
        labelR60.posZ = 0
        RegionLabels.append(labelR60)
        let labelR61 = RegionLabel() as RegionLabel
        labelR61.id = 10000061
        labelR61.name = "Tenerifis"
        labelR61.posX = 4712
        labelR61.posY = 6000
        labelR61.posZ = 0
        RegionLabels.append(labelR61)
        let labelR62 = RegionLabel() as RegionLabel
        labelR62.id = 10000062
        labelR62.name = "Omist"
        labelR62.posX = 5160
        labelR62.posY = 6832
        labelR62.posZ = 0
        RegionLabels.append(labelR62)
        let labelR63 = RegionLabel() as RegionLabel
        labelR63.id = 10000063
        labelR63.name = "Period Basis"
        labelR63.posX = 2168
        labelR63.posY = 6736
        labelR63.posZ = 0
        RegionLabels.append(labelR63)
        let labelR64 = RegionLabel() as RegionLabel
        labelR64.id = 10000064
        labelR64.name = "Essence"
        labelR64.posX = 2656
        labelR64.posY = 3352
        labelR64.posZ = 0
        RegionLabels.append(labelR64)
        let labelR65 = RegionLabel() as RegionLabel
        labelR65.id = 10000065
        labelR65.name = "Kor-Azor"
        labelR65.posX = 2056
        labelR65.posY = 4584
        labelR65.posZ = 0
        RegionLabels.append(labelR65)
        let labelR66 = RegionLabel() as RegionLabel
        labelR66.id = 10000066
        labelR66.name = "Perrigen Falls"
        labelR66.posX = 5976
        labelR66.posY = 2944
        labelR66.posZ = 0
        RegionLabels.append(labelR66)
        let labelR67 = RegionLabel() as RegionLabel
        labelR67.id = 10000067
        labelR67.name = "Genesis"
        labelR67.posX = 2352
        labelR67.posY = 3888
        labelR67.posZ = 0
        RegionLabels.append(labelR67)
        let labelR68 = RegionLabel() as RegionLabel
        labelR68.id = 10000068
        labelR68.name = "Verge Vendor"
        labelR68.posX = 2440
        labelR68.posY = 3360
        labelR68.posZ = 0
        RegionLabels.append(labelR68)
        let labelR69 = RegionLabel() as RegionLabel
        labelR69.id = 10000069
        labelR69.name = "Black Rise"
        labelR69.posX = 2656
        labelR69.posY = 2736
        labelR69.posZ = 0
        RegionLabels.append(labelR69)
    }  // CreateRegionLabels

}
