#!/bin/bash

# Define the destination directory in your MkDocs project
DEST_DIR="docs"

# URLs of the raw documentation files
TELEMETRY_STREAM_DOCS_URL="https://raw.githubusercontent.com/team-drift/telemetry-stream/main/docs/telemetry-stream.md"
ARDUPILOT_LOGS_PARSING_DOCS_URL="https://raw.githubusercontent.com/team-drift/ardupilot-logs-parsing/main/docs/ardupilot-logs-parsing.md"
KINEMATIC_MODEL_DOCS_URL="https://raw.githubusercontent.com/team-drift/kinematic-model/main/docs/kinematic-model.md"
PTU_SDK_DOCS_URL="https://raw.githubusercontent.com/team-drift/PTU-SDK/main/docs/PTU-SDK.md"

# Fetch Telemetry Stream documentation
curl -o "${DEST_DIR}/telemetry-stream.md" $TELEMETRY_STREAM_DOCS_URL
echo "Telemetry Stream documentation updated."

# Fetch Ardupilot Logs Parsing documentation
curl -o "${DEST_DIR}/ardupilot-logs-parsing.md" $ARDUPILOT_LOGS_PARSING_DOCS_URL
echo "Ardupilot Logs Parsing documentation updated."

# Fetch Kinematic Model documentation
curl -o "${DEST_DIR}/kinematic-model.md" $KINEMATIC_MODEL_DOCS_URL
echo "Kinematic Model documentation updated."

# Fetch PTU-SDK documentation
curl -H "Authorization: token $PTU_SDK_PAT" -o "${DEST_DIR}/PTU-SDK.md" $PTU_SDK_DOCS_URL
echo "PTU-SDK documentation updated."



echo "Documentation updated."
