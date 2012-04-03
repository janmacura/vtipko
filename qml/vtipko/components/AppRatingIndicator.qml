import QtQuick 1.1
import com.nokia.symbian 1.1
import "../js/utils.js" as Util

Item {
    id: root
    signal clicked(int index);
    property variant maximumValue
    property variant ratingValue

    height: background.height
    width: background.width

    property string backgroundImageSource: Util.getImageFolder(false) + "common/star_0.png"
    property string indicatorImageSource: Util.getImageFolder(false) + "common/star_1.png"

    Row {
        id: background
        Repeater {
            model: maximumValue
            Image {
                id: backgroundImage
                source: backgroundImageSource
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        root.clicked(index);
                    }
                }
            }
        }
    }

    Row {
        id: indicator
        Repeater {
            model: ratingValue
            Image {
                id: indicatorImage
                source: indicatorImageSource
            }
        }
    }
}
