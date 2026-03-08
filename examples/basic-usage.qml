import QtQuick 2.0

/**
 * Example 1: Basic Usage
 * 
 * This shows the simplest way to use the DebugLogger.
 * To test this, save it as a QML file and reference it in your controller.qml
 */

Item {
    // Import the debug logger
    property QtObject logger

    Component.onCompleted: {
        // Simple messages
        logger.log("App started")
        logger.info("Initializing controls")
        logger.warn("This feature is experimental")
        logger.error("Something went wrong!")

        // With additional data
        logger.log("User action", {
            action: "pressed",
            button: "SYNC",
            deck: 1
        })

        // Common use cases
        logger.debug("Current state", {
            playing: true,
            currentBPM: 120,
            position: 3500
        })
    }

    // Log property changes
    property int currentDeck: 1
    onCurrentDeckChanged: {
        logger.info("Deck changed", {
            newDeck: currentDeck,
            timestamp: Date.now()
        })
    }

    // Log errors
    function handleError(errorMsg, errorCode) {
        logger.error("Error occurred", {
            message: errorMsg,
            code: errorCode,
            time: new Date().toISOString()
        })
    }
}
