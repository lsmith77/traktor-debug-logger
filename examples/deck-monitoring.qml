import QtQuick 2.0
import CSI 1.0

/**
 * Example: Real-time Deck State Monitoring
 * 
 * Shows how to track deck state and send it to the debug logger's metadata view.
 * This demonstrates tracking play state, BPM, track info, and more.
 * 
 * Install Logger.qml first:
 *   traktor-mod --install-logger-only
 * 
 * Then add this module to your controller:
 *   DeckMonitor { deckId: 0 }  // For deck A
 *   DeckMonitor { deckId: 1 }  // For deck B
 *   DeckMonitor { deckId: 2 }  // For deck C
 *   DeckMonitor { deckId: 3 }  // For deck D
 * 
 * View the metadata in the browser dashboard at http://localhost:8080
 * (select "Live Metadata" tab to see deck states in real-time)
 */

Module {
    id: deckMonitor
    property int deckId: 0

    // Import logger
    Logger { id: logger }

    // Create property prefix for this deck
    readonly property string pathPrefix: "app.traktor.decks." + (deckId + 1) + "."

    // Track track metadata
    AppProperty { id: propTitle;        path: pathPrefix + "content.title" }
    AppProperty { id: propArtist;       path: pathPrefix + "content.artist" }
    AppProperty { id: propBpm;          path: pathPrefix + "tempo.base_bpm" }
    AppProperty { id: propTempo;        path: pathPrefix + "tempo.tempo_for_display" }
    AppProperty { id: propKey;          path: pathPrefix + "content.musical_key" }
    AppProperty { id: propTrackLength;  path: pathPrefix + "track.content.track_length" }
    AppProperty { id: propElapsedTime;  path: pathPrefix + "track.player.elapsed_time" }
    AppProperty { id: propIsPlaying;    path: pathPrefix + "play" }
    AppProperty { id: propIsSynced;     path: pathPrefix + "sync.enabled" }
    AppProperty { id: propIsLoaded;     path: pathPrefix + "is_loaded" }

    // Send deck state when track loads
    onPropIsLoadedChanged: {
        sendDeckState()
    }

    // Send deck state when play state changes
    onPropIsPlayingChanged: {
        sendDeckState()
    }

    // Send deck state periodically while playing (updates elapsed time)
    Timer {
        interval: 1000
        repeat: true
        running: propIsPlaying.value

        onTriggered: {
            sendDeckState()
        }
    }

    // Send deck state when BPM/tempo changes
    onPropTempoChanged: {
        sendDeckState()
    }

    // Send state to logger
    function sendDeckState() {
        const deckLetter = String.fromCharCode(65 + deckId)
        const minutes = Math.floor(propElapsedTime.value / 60)
        const seconds = Math.floor(propElapsedTime.value % 60)
        const elapsedString = minutes + ":" + (seconds < 10 ? "0" : "") + seconds

        logger.sendDeckState(deckId, {
            deck: deckLetter,
            title: propTitle.value || "(no track)",
            artist: propArtist.value || "(unknown)",
            bpm: Math.round(propBpm.value * 100) / 100,
            tempo: Math.round(propTempo.value * 100) / 100 + "%",
            key: propKey.value || "?",
            elapsed: elapsedString,
            total_length: Math.floor(propTrackLength.value) + "s",
            playing: propIsPlaying.value,
            synced: propIsSynced.value,
            loaded: propIsLoaded.value
        })
    }
}
