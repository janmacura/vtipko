.pragma library
var symbian = 1;
var xhr_error_string = "Vyskytla sa chyba pri spracovaní alebo odoslaní tvojej požiadavky."

function getImageFolder(sameFolder) {
    return sameFolder ? "gfx/symbian/" : "../gfx/symbian/"
}

var Categories = {
    name: "categories",
    columns: [
                 {name: "_id", type: "INTEGER PRIMARY KEY"},
                 {name: "category_name", type: "TEXT"},
                 {name: "category_created", type: "NUMERIC"},
                 {name: "category_edited", type: "NUMERIC"}
             ]
}

var Data = {
    name: "data",
    columns: [
                 {name: "_id", type: "INTEGER PRIMARY KEY"},
                 {name: "name", type: "TEXT"},
                 {name: "text", type: "TEXT"},
                 {name: "rating", type: "NUMERIC"},
                 {name: "ratingcount", type: "NUMERIC"},
                 {name: "created", type: "NUMERIC"},
                 {name: "edited", type: "NUMERIC"},
                 {name: "category_id", type: "NUMERIC"},
                 {name: "author_name", type: "TEXT"}
             ]
}

var Settings = {
    name: "settings",
    columns: [
                 {name: "_id", type: "INTEGER PRIMARY KEY AUTOINCREMENT"},
                 {name: "setting", type: "TEXT UNIQUE"},
                 {name: "value", type: "TEXT"}
             ]
}

var Favorites = {
    name: "favorites",
    columns: [
                 {name: "_id", type: "INTEGER PRIMARY KEY AUTOINCREMENT"},
                 {name: "joke_id", type: "NUMERIC"},
                 {name: "added", type: "NUMERIC"}
             ]

}

function createTable(tx, table_info) {
    var cols = '';
    for(var i=0; i<table_info.columns.length; i++) {
        cols += (cols.length > 0 ? ', ' : '') + (table_info.columns[i].name + ' ' + table_info.columns[i].type);
    }
    tx.executeSql('CREATE TABLE IF NOT EXISTS ' + table_info.name + '(' + cols + ')');
}

function createTables() {
    var db = openDatabase()
    db.transaction(
                function(tx) {
                    createTable(tx, Categories);
                    createTable(tx, Data);
                    createTable(tx, Settings);
                    createTable(tx, Favorites);
                }
                );
}

function loadCategoriesFromFile() {
    var xhr = new XMLHttpRequest();
    var url = "../data/categories";
    xhr.open("GET", url, true);
    xhr.onreadystatechange = function() {
                if (xhr.readyState == 4) {
                    if (xhr.status == 0) {
                        var lines = xhr.responseText.split("\n");
                        var db = openDatabase();
                        db.transaction(
                                    function(tx) {
                                        for (var i = 0; i < lines.length; i++) {
                                            var columns = lines[i].split("|");
                                            var query = "INSERT INTO categories VALUES (" + columns[0] + "," + columns[1] + "," + columns[2] + "," + columns[3] + ")";
                                            var rs = tx.executeSql(query);
                                        }
                                    }
                                    )
                    }
                }
            }
    xhr.send();
}

function openDatabase() {
    var db = openDatabaseSync("database", "1.0", "Vtipalek QML SQL!", 1000000);
    return db;
}

function getCategories(model) {
    var db = openDatabase();

    db.transaction(
                function(tx) {
                    var rs = tx.executeSql('SELECT * FROM categories');

                    for(var i = 0; i < rs.rows.length; i++) {
                        model.append({"category_id": rs.rows.item(i)._id,
                                         "category_name": rs.rows.item(i).category_name,
                                         "category_created": rs.rows.item(i).category_created,
                                         "category_edited": rs.rows.item(i).category_edited})
                    }
                }
                )
}

function getCategoryJokesCount(category_id) {
    var db = openDatabase();
    var count = 0;
    db.transaction(
                function(tx) {
                    var query = 'SELECT COUNT(*) as count FROM data WHERE category_id=' + category_id;
                    var rs = tx.executeSql(query);
                    if (rs.rows.length > 0)
                        count = rs.rows.item(0).count;
                }
                )
    return count;
}

function getJokesCount() {
    var db = openDatabase();
    var count = 0;
    db.transaction(
                function(tx) {
                    var query = 'SELECT COUNT(*) as count FROM data';
                    var rs = tx.executeSql(query);
                    if (rs.rows.length > 0)
                        count = rs.rows.item(0).count;
                }
                )
    return count;
}

function getCategoriesCount() {
    var db = openDatabase();
    var count = 0;
    db.transaction(
                function(tx) {
                    var query = 'SELECT COUNT(*) as count FROM categories';
                    var rs = tx.executeSql(query);
                    if (rs.rows.length > 0)
                        count = rs.rows.item(0).count;
                }
                )
    return count;
}

function getCategoryJokes(category_id, model) {
    var db = openDatabase();

    db.transaction(
                function(tx) {
                    var query = 'SELECT * FROM data WHERE category_id=' + category_id
                    var rs = tx.executeSql(query);

                    for(var i = 0; i < rs.rows.length; i++) {
                        appendJokeToModel(model, rs.rows.item(i));
                    }
                }
                )
}

function appendJokeToModel(model, joke) {
    model.append({"joke_id": joke._id,
                     "joke_name": joke.name,
                     "joke_text": joke.text,
                     "joke_rating": joke.rating,
                     "joke_rating_count": joke.ratingcount,
                     "joke_created": joke.creted,
                     "joke_edited": joke.edited,
                     "joke_category_id": joke.category_id,
                     "joke_author_name": joke.author_name});
}

function getCategoryNameById(category_id) {
    var db = openDatabase();

    var category_name = "";
    db.transaction(
                function(tx) {
                    var query = 'SELECT category_name FROM categories WHERE _id=' + category_id
                    var rs = tx.executeSql(query);

                    if(rs.rows.length > 0) {
                        category_name = rs.rows.item(0).category_name;
                    }
                }
                )
    return category_name;
}

function getSettingValueByName(setting) {
    var db = openDatabase();

    var value = "0";
    db.transaction(
                function(tx) {
                    var query = 'SELECT value FROM settings WHERE setting=?';
                    var rs = tx.executeSql(query, [setting]);

                    if(rs.rows.length > 0) {
                        value = rs.rows.item(0).value;
                    }
                }
                )
    return value;
}

function setSetting(setting, value) {
    var db = openDatabase();

    var res = "";
    db.transaction(
                function(tx) {
                    var query = 'INSERT OR REPLACE INTO settings (setting, value) VALUES (?,?);';
                    var rs = tx.executeSql(query, [setting, value]);

                    if (rs.rowsAffected > 0) {
                        res = "OK";
                    } else {
                        res = "Error";
                    }
                }
                )
    return res;
}

function synchronize(window) {
    var xhr = new XMLHttpRequest();
    var synctime = getSettingValueByName("synctime");

    var url = "http://www.vtipko.eu/api/getdata?sign=test&synctime=" + parseInt(synctime) + "&device=" + window.deviceinfo.imei;
    console.log(url)
    xhr.open("GET", url, true);
    xhr.onreadystatechange = function() {
                if (xhr.readyState == 4) {
                    if (xhr.status == 200) {
                        var jsonObject = JSON.parse(xhr.responseText);
                        if (jsonObject.status.trim().toLowerCase() == "ok") {
                            var inserted = 0;
                            for (var index in jsonObject.data) {
                                if (insertOrUpdateJoke(jsonObject.data[index]))
                                    inserted++;
                            }
                            if (jsonObject.synctime) {
                                if (inserted > 0)
                                    setSetting("oldsynctime", synctime);
                                setSetting("synctime", jsonObject.synctime);
                            }
                            window.dataSynchronized();
                        } else {
                            window.noNewDataAdded();
                        }
                    } else {
                        window.noNewDataAdded();
                        window.openNotification(xhr_error_string, false, false);
                    }
                }
            }
    xhr.send();
}

function jokeExist(id) {
    var db = openDatabase();

    var exist = false;
    db.transaction(
                function(tx) {
                    var query = 'SELECT _id FROM data WHERE _id=' + id;
                    var rs = tx.executeSql(query);
                    if (rs.rows.length > 0)
                        exist = true
                }
                )
    return exist;
}

function insertOrUpdateJoke(jokeObject) {
    if (jokeExist(jokeObject["id"])) {
        updateJoke(jokeObject);
        return false;
    } else {
        return insertJoke(jokeObject);
    }
}

function insertJoke(jokeObject) {
    console.log("inserting joke " + jokeObject["name"]);
    var res = false;
    var db = openDatabase();
    db.transaction(
                function(tx) {
                    var query = "INSERT INTO data VALUES (?,?,?,?,?,?,?,?,?)";
                    var rs = tx.executeSql(query, [jokeObject["id"],
                                                   jokeObject["name"],
                                                   jokeObject["text"],
                                                   jokeObject["rating"],
                                                   jokeObject["ratingcount"],
                                                   jokeObject["created"],
                                                   jokeObject["edited"],
                                                   jokeObject["category_id"],
                                                   jokeObject["author_name"] ]);
                    if (rs.rowsAffected > 0) {
                        res = true;
                    } else {
                        res = false;
                    }
                }
                )
    return res;
}

function updateJoke(jokeObject) {
    console.log("updating joke " + jokeObject["name"])

    var db = openDatabase();
    db.transaction(
                function(tx) {
                    var query = "UPDATE data SET name = ?, text = ?, rating = ?, ratingcount = ?, created = ?, edited = ?, category_id = ?, author_name = ? WHERE _id = ?";
                    var rs = tx.executeSql(query, [jokeObject["name"],
                                                   jokeObject["text"],
                                                   jokeObject["rating"],
                                                   jokeObject["ratingcount"],
                                                   jokeObject["created"],
                                                   jokeObject["edited"],
                                                   jokeObject["category_id"],
                                                   jokeObject["author_name"],
                                                   jokeObject["id"]
                                           ]);
                }
                )
}

function isJokeFavorite(joke_id) {
    var db = openDatabase();
    var isFavorite = false;
    db.transaction(
                function(tx) {
                    var query = 'SELECT * FROM favorites WHERE joke_id=?;';
                    var rs = tx.executeSql(query, [joke_id]);

                    if (rs.rows.length > 0) {
                        isFavorite = true;
                    } else {
                        isFavorite = false;
                    }
                }
                )
    console.log(isFavorite);
    return isFavorite;
}

function addJokeToFavorites(joke_id) {
    var db = openDatabase();
    var res = false;
    var ts = Math.round((new Date()).getTime() / 1000);

    db.transaction(
                function(tx) {
                    var query = 'INSERT OR REPLACE INTO favorites (joke_id, added) VALUES (?,?);';
                    var rs = tx.executeSql(query, [joke_id, ts]);

                    if (rs.rowsAffected > 0) {
                        res = true;
                    } else {
                        res = false;
                    }
                }
                )
    console.log(res);
    return res;
}

function removeJokeFromFavorites(joke_id) {
    var db = openDatabase();
    var res = false;
    db.transaction(
                function(tx) {
                    var query = 'DELETE FROM favorites WHERE joke_id=?;';
                    var rs = tx.executeSql(query, [joke_id]);

                    if (rs.rowsAffected > 0) {
                        res = true;
                    } else {
                        res = false;
                    }
                }
                )
    console.log(res);
    return res;
}

function getFavoriteJokesCount() {
    var db = openDatabase();
    var count = 0;
    db.transaction(
                function(tx) {
                    var query = 'SELECT COUNT(*) as count FROM favorites';
                    var rs = tx.executeSql(query);
                    if (rs.rows.length > 0)
                        count = rs.rows.item(0).count;
                }
                )
    return count;
}

function getFavoriteJokes(model) {
    var db = openDatabase();

    db.transaction(
                function(tx) {
                    var query = 'SELECT joke_id FROM favorites ORDER BY added DESC;';
                    var rs = tx.executeSql(query);
                    console.log(rs.rows.length);
                    for(var i = 0; i < rs.rows.length; i++) {
                        var query_joke = 'SELECT * FROM data WHERE _id=' + rs.rows.item(i).joke_id;
                        var rs_joke = tx.executeSql(query_joke);
                        if (rs_joke.rows.length > 0) {
                            appendJokeToModel(model, rs_joke.rows.item(0));
                        }
                    }
                }
                )
}

function getBestJokesCount() {
    var db = openDatabase();
    var count = 0;
    db.transaction(
                function(tx) {
                    var query = 'SELECT COUNT(*) as count FROM data';
                    var rs = tx.executeSql(query);
                    if (rs.rows.length > 0)
                        count = rs.rows.item(0).count;
                }
                )
    return count;
}

function getBestJokes(model) {
    var db = openDatabase();

    db.transaction(
                function(tx) {
                    var query = 'SELECT * FROM data ORDER BY rating DESC'
                    var rs = tx.executeSql(query);

                    for(var i = 0; i < rs.rows.length; i++) {
                        appendJokeToModel(model, rs.rows.item(i));
                    }
                }
                )
}

function getNewestJokesCount() {
    var db = openDatabase();
    var synctime = getSettingValueByName("oldsynctime");
    var count = 0;
    db.transaction(
                function(tx) {
                    var query = 'SELECT COUNT(*) as count FROM data WHERE created > ' + synctime;
                    var rs = tx.executeSql(query);
                    if (rs.rows.length > 0)
                        count = rs.rows.item(0).count;
                }
                )
    return count;
}

function getNewestJokes(model) {
    var db = openDatabase();
    var synctime = getSettingValueByName("oldsynctime");
    db.transaction(
                function(tx) {
                    var query = 'SELECT * FROM data WHERE created > ? ORDER BY created DESC'
                    var rs = tx.executeSql(query, [synctime]);

                    for(var i = 0; i < rs.rows.length; i++) {
                        appendJokeToModel(model, rs.rows.item(i));
                    }
                }
                )
}

function getRandomJoke(model) {
    var db = openDatabase();
    db.transaction(
                function(tx) {
                    var query = 'SELECT * FROM data ORDER BY RANDOM() LIMIT 1'
                    var rs = tx.executeSql(query);

                    for(var i = 0; i < rs.rows.length; i++) {
                        appendJokeToModel(model, rs.rows.item(i));
                    }
                }
                )
}

function xhrGet(url, params, text, type, window) {
    var _params = "?";
    for (var property in params) {
        _params += property + '=' + params[property].toString().trim() + '&';
    }
    url = url + _params.substring(0, _params.length - 1);
    console.log(url)

    var http = new XMLHttpRequest();
    http.open("GET", url, true);

    http.onreadystatechange = function() {
                if(http.readyState == 4) {
                    if (http.status == 200) {
                        console.log(http.responseText);
                        window.xhrSuccess(type, true);
                        if (text != "")
                            window.openNotification(text, true, true);
                    } else {
                        window.xhrSuccess(type, false);
                        window.openNotification(xhr_error_string, false, true);
                    }
                }
            }
    http.send();
}

function printObject(object) {
    var output = '';
    for (var property in object) {
        output += property + ': ' + object[property]+'; ';
    }
    console.log(output);
}

function stripslashes (str) {
    return (str + '').replace(/\\(.?)/g, function (s, n1) {
        switch (n1) {
        case '\\':
            return '\\';
        case '0':
            return '\u0000';
        case '':
            return '';
        default:
            return n1;
        }
    });
}
