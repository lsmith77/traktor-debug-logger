import QtQuick 2.0
import CSI 1.0

/**
 * Example: Real-time Master Clock Monitoring
 * 
 * Shows how to track master BPM, tempo, and send to debug logger.
 * 
 * Install Logger.qml first:
 *   install-traktor-mod --install-logger-only
 * 
 * Then add this module to your main controller file:
 *   MasterClockMonitor { }
 * 
 * View the metadata in the browser dashboard at http://localhost:8080
 * (select "Live Metadata" tab to see master state in real-time)
 */

Module {
    id: masterMonitor

    // Import logger
    Logger { id: logger }

    // Track master properties
    AppProperty { id: propMasterBpm;    path: "app.traktor.master.bpm.base_bpm" }
    AppProperty { id: propMasterTempo;  path: "app.traktor.master.bpm.tempo" }

    // Send master state when BPM changes
    onPropMasterBpmChanged: {
        sendMasterState()
    }

    // Send master state when tempo changes
    onPropMasterTempoChanged: {
        sendMasterState()
    }

    // Send state to logger
    function sendMasterState() {
        logger.sendMasterState({
            bpm: Math.round(propMasterBpm.value * 100) / 100,
            tempo: Math.round(propMasterTempo.value * 100) / 100 + "%",
            updated_at: new Date().toISOString()
        })
    }
}
