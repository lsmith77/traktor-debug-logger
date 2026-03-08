import QtQuick 2.0

/**
 * Example 2: Monitoring Deck State Changes
 * 
 * This example shows how to log deck state changes in real-time.
 * Useful for debugging why a deck isn't behaving as expected.
 */

Item {
    id: root

    // Import the debug logger
    property QtObject logger

    // Example: Monitor these properties from app.traktor.decks
    property bool isPlaying: false
    property int currentBPM: 120
    property string trackTitle: "Unknown"
    property int position: 0  // in milliseconds
    property bool isCued: false

    // Log whenever playing state changes
    onIsPlayingChanged: {
        logger.info("Playing state changed", {
            isPlaying: isPlaying,
            deck: 1,
            trackTitle: trackTitle,
            bpm: currentBPM
        })
    }

    // Log BPM changes
    onCurrentBPMChanged: {
        logger.debug("BPM adjusted", {
            newBPM: currentBPM,
            change: currentBPM
        })
    }

    // Log track loads
    onTrackTitleChanged: {
        logger.log("New track loaded", {
            title: trackTitle,
            isPlaying: isPlaying,
            initialBPM: currentBPM
        })
    }

    // Log playback position (but throttle it - don't log every millisecond!)
    Timer {
        interval: 1000  // Log every 1 second instead of constantly
        repeat: true
        running: root.isPlaying

        onTriggered: {
            logger.debug("Playback position", {
                position_ms: root.position,
                position_sec: Math.floor(root.position / 1000),
                isPlaying: root.isPlaying
            })
        }
    }

    // Log cue point hits
    onIsCuedChanged: {
        if (isCued) {
            logger.info("Cue point hit", {
                position: position,
                trackTitle: trackTitle
            })
        }
    }

    // Example: Log complex sequences
    function syncDeckToMaster() {
        logger.log("Syncing to master", {
            deck: 1,
            currentBPM: currentBPM,
            isPlaying: isPlaying,
            trackTitle: trackTitle
        })

        // Simulate adjustment
        currentBPM = 120
        logger.debug("Sync applied", {
            adjustedBPM: currentBPM
        })
    }
}
