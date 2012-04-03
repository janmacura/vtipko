.pragma library
var symbian = 1;
var fontColorGreen = "#70862f"
var fontColorGray = "#323232"
var fontColorBlue = "#3c8dde"
var fontColorButton = "#4b5e12"
var fontColorButtonHover = "#9c165b"

var listHeight = 70;
var headerHeight = 60;

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

function getCategoryNames(model) {
    var db = openDatabase();

    db.transaction(
                function(tx) {
                    var rs = tx.executeSql('SELECT * FROM categories');

                    for(var i = 0; i < rs.rows.length; i++) {
                        model.append({ "name": rs.rows.item(i).category_name })
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
                        model.append({"joke_id": rs.rows.item(i)._id,
                                         "joke_name": rs.rows.item(i).name,
                                         "joke_text": rs.rows.item(i).text,
                                         "joke_rating": rs.rows.item(i).rating,
                                         "joke_rating_count": rs.rows.item(i).ratingcount,
                                         "joke_created": rs.rows.item(i).creted,
                                         "joke_edited": rs.rows.item(i).edited,
                                         "joke_category_id": rs.rows.item(i).category_id,
                                         "joke_author_name": rs.rows.item(i).author_name})
                    }
                }
                )
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

function synchronize(window) {
    var xhr = new XMLHttpRequest();
    var url = "http://www.vtipko.eu/api/getdata?sign=test&synctime=" + window.synctime + "&device=" + window.deviceinfo.uniqueDeviceID;
    xhr.open("GET", url, true);
    xhr.onreadystatechange = function() {
                if (xhr.readyState == 4) {
                    if (xhr.status == 200) {
                        var jsonObject = JSON.parse(xhr.responseText);
                        for (var index in jsonObject.data) {
                            insertOrUpdateJoke(jsonObject.data[index]);
                        }
                        window.dataSynchronized();
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
    } else {
        insertJoke(jokeObject);
    }
}

function insertJoke(jokeObject) {
    console.log("inserting joke " + jokeObject["name"]);

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
                }
                )
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

function printObject(object) {
    var output = '';
    for (var property in object) {
        output += property + ': ' + object[property]+'; ';
    }
    console.log(output);
}
