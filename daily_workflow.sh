#!/bin/bash

# daily.sh - Streamlined daily workflow automation
# Usage: ./daily.sh [date] [--template template_name] [--editor editor_name]

set -euo pipefail

# =============================================================================
# CONFIGURATION
# =============================================================================

# Base configuration
readonly BASE_DIR="${WORK_BASE_DIR:-$HOME/work}"
readonly CONFIG_FILE="$HOME/.daily_config"
readonly TEMPLATES_DIR="$BASE_DIR/.templates"

# Default settings (can be overridden in config file or environment)
DEFAULT_EDITOR="${EDITOR:-code}"
DEFAULT_TEMPLATE="standard"
AUTO_GIT="${AUTO_GIT:-true}"
WEEKEND_MODE="${WEEKEND_MODE:-prompt}"

# Load user config if exists
[[ -f "$CONFIG_FILE" ]] && source "$CONFIG_FILE"

# =============================================================================
# UTILITY FUNCTIONS
# =============================================================================

log() {
    echo "$(date '+%H:%M:%S') $*" >&2
}

error() {
    echo "ERROR: $*" >&2
    exit 1
}

# Get ISO week number (more reliable than %W)
get_week() {
    date -d "$1" '+%V'
}

# Smart date parsing
parse_date() {
    local input="$1"
    case "$input" in
        "today"|"") date '+%Y-%m-%d' ;;
        "yesterday") date -d "yesterday" '+%Y-%m-%d' ;;
        "tomorrow") date -d "tomorrow" '+%Y-%m-%d' ;;
        "monday"|"mon") date -d "this monday" '+%Y-%m-%d' ;;
        "tuesday"|"tue") date -d "this tuesday" '+%Y-%m-%d' ;;
        "wednesday"|"wed") date -d "this wednesday" '+%Y-%m-%d' ;;
        "thursday"|"thu") date -d "this thursday" '+%Y-%m-%d' ;;
        "friday"|"fri") date -d "this friday" '+%Y-%m-%d' ;;
        *) 
            # Try to parse as date
            if date -d "$input" '+%Y-%m-%d' 2>/dev/null; then
                date -d "$input" '+%Y-%m-%d'
            else
                error "Invalid date: $input"
            fi
            ;;
    esac
}

# =============================================================================
# DIRECTORY STRUCTURE & PATH BUILDING
# =============================================================================

build_path() {
    local target_date="$1"
    local year month day_name week_num
    
    year=$(date -d "$target_date" '+%Y')
    month=$(date -d "$target_date" '+%m-%B')  # "01-January"
    day_name=$(date -d "$target_date" '+%A')
    week_num=$(get_week "$target_date")
    
    echo "$BASE_DIR/$year/$month/week-$week_num/$day_name"
}

ensure_directory() {
    local dir_path="$1"
    if [[ ! -d "$dir_path" ]]; then
        log "Creating directory: $dir_path"
        mkdir -p "$dir_path"
        
        # Initialize with .gitkeep if using git
        if [[ "$AUTO_GIT" == "true" ]] && git rev-parse --git-dir >/dev/null 2>&1; then
            touch "$dir_path/.gitkeep"
        fi
    fi
}

# =============================================================================
# TEMPLATE SYSTEM
# =============================================================================

init_templates() {
    mkdir -p "$TEMPLATES_DIR"
    
    # Standard daily template
    cat > "$TEMPLATES_DIR/standard.md" <<'EOF'
# {{DATE}} - {{DAY_NAME}}

## Focus Areas
- [ ] 
- [ ] 
- [ ] 

## Notes


## Links & References


## End of Day Review
- **Completed:**
- **Blocked by:**
- **Tomorrow's priority:**

---
*Created: {{TIMESTAMP}}*
EOF

    # Meeting template
    cat > "$TEMPLATES_DIR/meeting.md" <<'EOF'
# Meeting Notes - {{DATE}}

**Meeting:** 
**Attendees:** 
**Duration:** 

## Agenda


## Discussion


## Action Items
- [ ] 
- [ ] 

## Follow-up


---
*Meeting date: {{TIMESTAMP}}*
EOF

    # Project template
    cat > "$TEMPLATES_DIR/project.md" <<'EOF'
# Project Work - {{DATE}}

**Project:** 
**Current Sprint/Phase:** 

## Today's Objectives
- [ ] 
- [ ] 

## Code/Technical Notes


## Decisions Made


## Next Steps


---
*Work session: {{TIMESTAMP}}*
EOF
}

load_template() {
    local template_name="$1"
    local target_date="$2"
    local template_file="$TEMPLATES_DIR/$template_name.md"
    
    if [[ ! -f "$template_file" ]]; then
        log "Template '$template_name' not found, using standard"
        template_file="$TEMPLATES_DIR/standard.md"
    fi
    
    local day_name timestamp formatted_date
    day_name=$(date -d "$target_date" '+%A')
    formatted_date=$(date -d "$target_date" '+%B %d, %Y')
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    # Template variable substitution
    sed -e "s/{{DATE}}/$formatted_date/g" \
        -e "s/{{DAY_NAME}}/$day_name/g" \
        -e "s/{{TIMESTAMP}}/$timestamp/g" \
        "$template_file"
}

# =============================================================================
# GIT INTEGRATION
# =============================================================================

git_auto_commit() {
    if [[ "$AUTO_GIT" == "true" ]] && git rev-parse --git-dir >/dev/null 2>&1; then
        local file_path="$1"
        local commit_msg="Daily log: $(basename "$(dirname "$file_path")")/$(basename "$file_path")"
        
        git add "$file_path" 2>/dev/null || true
        if git diff --staged --quiet 2>/dev/null; then
            log "No changes to commit"
        else
            git commit -m "$commit_msg" >/dev/null 2>&1 || log "Commit failed (non-critical)"
        fi
    fi
}

# =============================================================================
# WEEKEND/HOLIDAY HANDLING
# =============================================================================

handle_weekend() {
    local target_date="$1"
    local day_name
    day_name=$(date -d "$target_date" '+%A')
    
    if [[ "$day_name" =~ ^(Saturday|Sunday)$ ]]; then
        case "$WEEKEND_MODE" in
            "skip")
                log "Weekend detected, skipping workflow"
                exit 0
                ;;
            "prompt")
                echo "It's $day_name. Continue with workflow? (y/n)"
                read -r response
                [[ "$response" =~ ^[Yy] ]] || exit 0
                ;;
            "allow")
                log "Weekend workflow enabled"
                ;;
        esac
    fi
}

# =============================================================================
# MAIN WORKFLOW
# =============================================================================

show_help() {
    cat <<EOF
Daily Workflow Manager

USAGE:
    daily.sh [DATE] [OPTIONS]

DATES:
    today, tomorrow, yesterday
    monday, tuesday, etc. (this week)
    2024-01-15, jan 15, etc.

OPTIONS:
    --template NAME     Use specific template (standard, meeting, project)
    --editor EDITOR     Override default editor
    --help             Show this help

EXAMPLES:
    daily.sh                    # Today with default template
    daily.sh tomorrow           # Tomorrow's log
    daily.sh --template meeting # Today with meeting template
    daily.sh friday --template project

CONFIGURATION:
    Edit $CONFIG_FILE to customize defaults
EOF
}

main() {
    local target_date template_name editor_cmd
    target_date="today"
    template_name="$DEFAULT_TEMPLATE"
    editor_cmd="$DEFAULT_EDITOR"
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --help|-h)
                show_help
                exit 0
                ;;
            --template)
                template_name="$2"
                shift 2
                ;;
            --editor)
                editor_cmd="$2"
                shift 2
                ;;
            --init)
                log "Initializing templates and directory structure..."
                init_templates
                mkdir -p "$BASE_DIR"
                log "Initialization complete. Edit $CONFIG_FILE to customize."
                exit 0
                ;;
            -*)
                error "Unknown option: $1"
                ;;
            *)
                target_date="$1"
                shift
                ;;
        esac
    done
    
    # Initialize templates if they don't exist
    [[ -d "$TEMPLATES_DIR" ]] || init_templates
    
    # Parse and validate date
    target_date=$(parse_date "$target_date")
    handle_weekend "$target_date"
    
    # Build paths
    local work_dir daily_file
    work_dir=$(build_path "$target_date")
    daily_file="$work_dir/daily.md"
    
    # Setup
    ensure_directory "$work_dir"
    
    # Create daily file if it doesn't exist
    if [[ ! -f "$daily_file" ]]; then
        log "Creating daily log with template: $template_name"
        load_template "$template_name" "$target_date" > "$daily_file"
    fi
    
    # Open in editor
    log "Opening: $daily_file"
    log "Directory: $work_dir"
    
    # Change to work directory and open file
    cd "$work_dir"
    "$editor_cmd" "daily.md"
    
    # Auto-commit if configured
    git_auto_commit "$daily_file"
    
    # Quick actions menu
    echo
    echo "Quick actions:"
    echo "1) Open directory in file manager"
    echo "2) Create new file in today's directory"
    echo "3) Show recent files"
    echo "4) Exit"
    
    read -rp "Choice (1-4): " choice
    case "$choice" in
        1) 
            if command -v xdg-open >/dev/null; then
                xdg-open "$work_dir"
            elif command -v open >/dev/null; then
                open "$work_dir"
            fi
            ;;
        2)
            read -rp "Filename: " filename
            "${editor_cmd:-nano}" "$work_dir/$filename"
            ;;
        3)
            echo "Recent files in current week:"
            find "$work_dir/.." -name "*.md" -mtime -7 -ls 2>/dev/null || echo "No recent files found"
            ;;
    esac
    
    log "Workflow complete!"
}

# =============================================================================
# EXECUTION
# =============================================================================

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi