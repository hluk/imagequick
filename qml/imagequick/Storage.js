function getDatabase(id) {
    return [id ? id + "-" : "", openDatabaseSync("ImageQuick", "1.0", "StorageDatabase", 100000)];
}

function initialize(db) {
    db[1].transaction(
                function(tx) {
                    tx.executeSql('CREATE TABLE IF NOT EXISTS settings(setting TEXT UNIQUE, value TEXT)');
                });
}

function setSettings(db, settings) {
    var res, setting;
    res = false;
    for (setting in settings) {
        db[1].transaction(function(tx) {
                           var rs = tx.executeSql('INSERT OR REPLACE INTO settings VALUES (?,?);',
                                                  [db[0] + setting, settings[setting]]);
                           res = rs.rowsAffected > 0;
                       });
    }
    return res;
}

function getSetting(db, setting) {
    var res;
    db[1].transaction(function(tx) {
                       try {
                           var rs = tx.executeSql('SELECT value FROM settings WHERE setting=?;', [db[0] + setting]);
                           if (rs.rows.length > 0) {
                               res = rs.rows.item(0).value;
                           }
                       } catch(err) {
                       }
                   })
    return res
}
