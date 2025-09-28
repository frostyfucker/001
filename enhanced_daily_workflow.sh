#!/bin/bash

# daily.sh v2.0 - Enhanced Daily Workflow System
# Next-level productivity features

set -euo pipefail

# =============================================================================
# ENHANCED CONFIGURATION
# =============================================================================

readonly BASE_DIR="${WORK_BASE_DIR:-$HOME/work}"
readonly CONFIG_FILE="$HOME/.daily_config"
readonly TEMPLATES_DIR="$BASE_DIR/.templates"
readonly PLUGINS_DIR="$BASE_DIR/.plugins"
readonly ARCHIVE_DIR="$BASE_DIR/.archive"

# AI/LLM Integration
AI_ENABLED="${AI_ENABLED:-false}"
AI_PROVIDER="${AI_PROVIDER:-openai}"
AI_MODEL="${AI_MODEL:-gpt-4}"

# Smart features
ENABLE_TIME_TRACKING="${ENABLE_TIME_TRACKING:-false}"
ENABLE_ANALYTICS="${ENABLE_ANALYTICS:-true}"
ENABLE_SEARCH="${ENABLE_SEARCH:-true}"
ENABLE_SYNC="${ENABLE_SYNC:-false}"

# Load config
[[ -f "$CONFIG_FILE" ]] && source "$CONFIG_FILE"

# =============================================================================
# SMART ANALYTICS & INSIGHTS
# =============================================================================

analyze_productivity() {
    local period="${1:-week}"
    local analytics_file="$BASE_DIR/.analytics.json"
    
    log "Generating productivity insights for the past $period..."
    
    # Count tasks completed, notes created, etc.
    local completed_tasks files_created total_words
    
    case "$period" in
        "week")
            completed_tasks=$(find "$BASE_DIR" -name "*.md" -mtime -7 -exec grep -l "\- \[x\]" {} \; | wc -l)
            files_created=$(find "$BASE_DIR" -name "*.md" -mtime -7 | wc -l)
            total_words=$(find "$BASE_DIR" -name "*.md" -mtime -7 -exec wc -w {} + | tail -1 | awk '{print $1}')
            ;;
        "month")
            completed_tasks=$(find "$BASE_DIR" -name "*.md" -mtime -30 -exec grep -l "\- \[x\]" {} \; | wc -l)
            files_created=$(find "$BASE_DIR" -name "*.md" -mtime -30 | wc -l)
            total_words=$(find "$BASE_DIR" -name "*.md" -mtime -30 -exec wc -w {} + | tail -1 | awk '{print $1}')
            ;;
    esac
    
    cat <<EOF

📊 PRODUCTIVITY INSIGHTS - Past $period
======================================
✅ Files with completed tasks: $completed_tasks
📝 Total files created: $files_created  
📖 Total words written: $total_words
⏰ Most productive day: $(get_most_productive_day)
🔥 Current streak: $(get_current_streak) days

💡 SUGGESTIONS:
$(generate_suggestions)
EOF

    # Store analytics for trend analysis
    local today=$(date +%Y-%m-%d)
    echo "{\"date\":\"$today\",\"tasks\":$completed_tasks,\"files\":$files_created,\"words\":$total_words}" >> "$analytics_file"
}

get_most_productive_day() {
    find "$BASE_DIR" -name "daily.md" -mtime -7 -exec wc -l {} + | sort -nr | head -1 | awk '{print $2}' | xargs dirname | xargs basename
}

get_current_streak() {
    local streak=0
    local check_date=$(date +%Y-%m-%d)
    
    for i in {0..30}; do
        local day_path=$(build_path "$check_date")
        if [[ -f "$day_path/daily.md" ]]; then
            ((streak++))
            check_date=$(date -d "$check_date - 1 day" +%Y-%m-%d)
        else
            break
        fi
    done
    echo $streak
}

generate_suggestions() {
    local avg_words_per_day=$(( total_words / 7 ))
    
    if (( avg_words_per_day < 100 )); then
        echo "- Try writing more detailed notes to capture context"
    elif (( avg_words_per_day > 1000 )); then
        echo "- Consider using bullet points to keep notes concise"
    fi
    
    if (( completed_tasks < 3 )); then
        echo "- Break down tasks into smaller, actionable items"
    fi
    
    echo "- Your most productive day was $(get_most_productive_day). What made it special?"
}

# =============================================================================
# INTELLIGENT SEARCH & RETRIEVAL
# =============================================================================

smart_search() {
    local query="$*"
    local results_file="/tmp/daily_search_results"
    
    log "Searching for: '$query'"
    
    # Full-text search across all markdown files
    if command -v rg &> /dev/null; then
        # Use ripgrep if available (much faster)
        rg -i --type md --heading --line-number "$query" "$BASE_DIR" > "$results_file" 2>/dev/null || true
    else
        # Fallback to grep
        grep -r -i -n --include="*.md" "$query" "$BASE_DIR" > "$results_file" 2>/dev/null || true
    fi
    
    if [[ -s "$results_file" ]]; then
        echo "🔍 SEARCH RESULTS for '$query':"
        echo "================================="
        
        # Format results with context
        while IFS=: read -r file line content; do
            local date_path=$(echo "$file" | grep -o '[0-9]\{4\}/[0-9]\{2\}-[A-Z][a-z]*/week-[0-9]*/[A-Z][a-z]*' || echo "")
            echo "📅 $date_path"
            echo "   Line $line: $content"
            echo
        done < "$results_file"
        
        # Offer to open most recent match
        local latest_file=$(head -1 "$results_file" | cut -d: -f1)
        if [[ -n "$latest_file" ]]; then
            read -rp "Open most recent match? (y/n): " open_choice
            [[ "$open_choice" =~ ^[Yy]$ ]] && "${DEFAULT_EDITOR:-nano}" "$latest_file"
        fi
    else
        echo "No results found for '$query'"
        
        # Suggest similar searches
        echo "💡 Try searching for:"
        echo "  - Related terms or synonyms"
        echo "  - Partial matches (fewer keywords)"
        echo "  - Date-based search: daily.sh --date 'last monday'"
    fi
    
    rm -f "$results_file"
}

# =============================================================================
# AI-POWERED FEATURES
# =============================================================================

ai_daily_summary() {
    if [[ "$AI_ENABLED" != "true" ]]; then
        log "AI features disabled. Enable with AI_ENABLED=true in config"
        return
    fi
    
    local today_file="$1"
    local summary_prompt="Please analyze this daily log and provide:
1. A brief summary of what was accomplished
2. Identified patterns or themes
3. Suggestions for tomorrow's priorities
4. Any potential blockers to watch out for

Daily log content:
$(cat "$today_file" 2>/dev/null || echo "No content yet")"
    
    log "Generating AI summary..."
    
    # This would integrate with your preferred AI API
    # Example for OpenAI (requires API key and curl/jq)
    if command -v curl &> /dev/null && [[ -n "${OPENAI_API_KEY:-}" ]]; then
        local ai_response=$(curl -s -X POST "https://api.openai.com/v1/chat/completions" \
            -H "Authorization: Bearer $OPENAI_API_KEY" \
            -H "Content-Type: application/json" \
            -d "{
                \"model\": \"$AI_MODEL\",
                \"messages\": [{\"role\": \"user\", \"content\": \"$summary_prompt\"}],
                \"max_tokens\": 300
            }" | jq -r '.choices[0].message.content' 2>/dev/null)
        
        if [[ -n "$ai_response" && "$ai_response" != "null" ]]; then
            echo "🤖 AI INSIGHTS:"
            echo "==============="
            echo "$ai_response"
        fi
    else
        echo "AI summary requires curl, jq, and OPENAI_API_KEY environment variable"
    fi
}

ai_suggest_tasks() {
    local context_files=$(find "$(dirname "$1")" -name "*.md" -exec cat {} \;)
    local prompt="Based on recent work notes, suggest 3-5 specific, actionable tasks for today:

Context:
$context_files"
    
    # Similar AI integration as above
    log "AI task suggestions would appear here..."
}

# =============================================================================
# TIME TRACKING INTEGRATION
# =============================================================================

start_time_tracking() {
    if [[ "$ENABLE_TIME_TRACKING" != "true" ]]; then
        return
    fi
    
    local task_name="$1"
    local time_file="$BASE_DIR/.time_tracking"
    local start_time=$(date +%s)
    
    echo "$start_time|$task_name|start" >> "$time_file"
    log "⏱️  Started tracking: $task_name"
}

stop_time_tracking() {
    if [[ "$ENABLE_TIME_TRACKING" != "true" ]]; then
        return
    fi
    
    local time_file="$BASE_DIR/.time_tracking"
    local end_time=$(date +%s)
    
    # Find the last started task
    local last_entry=$(tail -1 "$time_file" 2>/dev/null || echo "")
    if [[ -n "$last_entry" && "$last_entry" =~ start$ ]]; then
        local start_time=$(echo "$last_entry" | cut -d'|' -f1)
        local task_name=$(echo "$last_entry" | cut -d'|' -f2)
        local duration=$(( end_time - start_time ))
        local duration_min=$(( duration / 60 ))
        
        echo "$end_time|$task_name|stop|${duration_min}m" >> "$time_file"
        log "⏹️  Stopped tracking: $task_name (${duration_min} minutes)"
    fi
}

show_time_summary() {
    local time_file="$BASE_DIR/.time_tracking"
    if [[ ! -f "$time_file" ]]; then
        echo "No time tracking data available"
        return
    fi
    
    echo "⏰ TIME SUMMARY - Today"
    echo "======================"
    
    # Parse and summarize today's time entries
    local today_date=$(date +%Y-%m-%d)
    while IFS='|' read -r timestamp task action duration; do
        if [[ "$action" == "stop" ]]; then
            local task_time=$(date -d "@$timestamp" +%H:%M)
            echo "✓ $task: $duration (completed at $task_time)"
        fi
    done < "$time_file"
}

# =============================================================================
# WEEKLY/MONTHLY REVIEWS
# =============================================================================

generate_weekly_review() {
    local week_dir="$(dirname "$(build_path "$(date +%Y-%m-%d)")")"
    local review_file="$week_dir/WEEK_REVIEW.md"
    
    log "Generating weekly review..."
    
    cat > "$review_file" <<EOF
# Week Review - Week $(date +%W), $(date +%Y)

## Weekly Goals vs. Achievements
$(extract_weekly_goals "$week_dir")

## Key Accomplishments
$(extract_completed_tasks "$week_dir")

## Learnings & Insights
- 
- 

## Challenges & Blockers
$(extract_blockers "$week_dir")

## Next Week's Focus
- [ ] 
- [ ] 
- [ ] 

## Metrics
- Days worked: $(count_work_days "$week_dir")
- Tasks completed: $(count_completed_tasks "$week_dir")
- Files created: $(count_files "$week_dir")

---
*Generated: $(date)*
EOF
    
    "${DEFAULT_EDITOR:-nano}" "$review_file"
}

extract_weekly_goals() {
    find "$1" -name "daily.md" -exec grep -h "^- \[ \]" {} \; 2>/dev/null | sort | uniq -c | sort -nr | head -10
}

extract_completed_tasks() {
    find "$1" -name "daily.md" -exec grep -h "^- \[x\]" {} \; 2>/dev/null | sed 's/^- \[x\] /✓ /'
}

extract_blockers() {
    find "$1" -name "daily.md" -exec grep -A5 -i "blocked\|blocker\|stuck" {} \; 2>/dev/null | grep -v "^--$"
}

# =============================================================================
# PLUGIN SYSTEM
# =============================================================================

load_plugins() {
    if [[ -d "$PLUGINS_DIR" ]]; then
        for plugin in "$PLUGINS_DIR"/*.sh; do
            if [[ -f "$plugin" ]]; then
                log "Loading plugin: $(basename "$plugin")"
                source "$plugin"
            fi
        done
    fi
}

create_sample_plugin() {
    mkdir -p "$PLUGINS_DIR"
    
    cat > "$PLUGINS_DIR/jira_integration.sh" <<'EOF'
# JIRA Integration Plugin
jira_create_ticket() {
    local title="$1"
    local description="$2"
    
    # Example JIRA API integration
    echo "Would create JIRA ticket: $title"
    echo "Description: $description"
    
    # Actual implementation would use JIRA REST API
    # curl -X POST "$JIRA_URL/rest/api/2/issue" \
    #     -H "Authorization: Basic $JIRA_AUTH" \
    #     -H "Content-Type: application/json" \
    #     -d '{"fields": {"project": {"key": "'$JIRA_PROJECT'"}, "summary": "'$title'", "description": "'$description'", "issuetype": {"name": "Task"}}}'
}

jira_link_daily_log() {
    local daily_file="$1"
    echo "# JIRA Links" >> "$daily_file"
    echo "- [Related ticket: PROJ-123](https://company.atlassian.net/browse/PROJ-123)" >> "$daily_file"
}
EOF
}

# =============================================================================
# ENHANCED MAIN FUNCTION
# =============================================================================

enhanced_main() {
    load_plugins
    
    # Parse enhanced arguments
    case "${1:-}" in
        --search)
            shift
            smart_search "$@"
            exit 0
            ;;
        --analytics)
            analyze_productivity "${2:-week}"
            exit 0
            ;;
        --review)
            generate_weekly_review
            exit 0
            ;;
        --time)
            case "${2:-}" in
                "start") start_time_tracking "${3:-Current Task}" ;;
                "stop") stop_time_tracking ;;
                "summary") show_time_summary ;;
                *) echo "Usage: daily.sh --time [start|stop|summary]" ;;
            esac
            exit 0
            ;;
        --ai)
            case "${2:-}" in
                "summary") ai_daily_summary "$3" ;;
                "suggest") ai_suggest_tasks "$3" ;;
                *) echo "Usage: daily.sh --ai [summary|suggest] [file]" ;;
            esac
            exit 0
            ;;
    esac
    
    # Run the original main workflow
    original_main "$@"
    
    # Post-workflow enhancements
    local today_file="$work_dir/daily.md"
    
    # Show quick stats
    if [[ "$ENABLE_ANALYTICS" == "true" ]]; then
        echo
        echo "📊 Quick Stats:"
        echo "Current streak: $(get_current_streak) days"
        echo "This week's files: $(find "$(dirname "$work_dir")" -name "*.md" 2>/dev/null | wc -l)"
    fi
    
    # Offer AI insights if enabled
    if [[ "$AI_ENABLED" == "true" ]]; then
        read -rp "Generate AI summary of today's work? (y/n): " ai_choice
        [[ "$ai_choice" =~ ^[Yy]$ ]] && ai_daily_summary "$today_file"
    fi
    
    # Time tracking
    if [[ "$ENABLE_TIME_TRACKING" == "true" ]]; then
        echo
        read -rp "Start time tracking for a task? (y/n): " time_choice
        if [[ "$time_choice" =~ ^[Yy]$ ]]; then
            read -rp "Task name: " task_name
            start_time_tracking "$task_name"
        fi
    fi
}

# Preserve original main function
original_main() {
    # [Original main function code would go here]
    echo "Running original workflow..."
}

# =============================================================================
# ENHANCED HELP
# =============================================================================

show_enhanced_help() {
    cat <<EOF
Daily Workflow Manager v2.0 - Enhanced Edition

BASIC USAGE:
    daily.sh [DATE] [OPTIONS]    # Start daily workflow

ENHANCED FEATURES:
    daily.sh --search TERMS      # Search across all notes
    daily.sh --analytics [week|month]  # Productivity insights
    daily.sh --review            # Generate weekly review
    daily.sh --time start TASK   # Start time tracking
    daily.sh --time stop         # Stop time tracking
    daily.sh --time summary      # Show time summary
    daily.sh --ai summary FILE   # AI-powered summary
    daily.sh --ai suggest FILE   # AI task suggestions

EXAMPLES:
    daily.sh --search "API bug"           # Find all mentions
    daily.sh --analytics month            # Monthly productivity
    daily.sh --time start "Code review"   # Track code review time
    daily.sh --ai summary today.md        # Get AI insights

CONFIGURATION:
    Edit ~/.daily_config to enable features:
    - AI_ENABLED=true (requires API keys)
    - ENABLE_TIME_TRACKING=true
    - ENABLE_ANALYTICS=true
    - ENABLE_SEARCH=true

PLUGINS:
    Place custom .sh files in work/.plugins/ to extend functionality
EOF
}

# Main execution
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    case "${1:-}" in
        --help-enhanced|-he) show_enhanced_help ;;
        *) enhanced_main "$@" ;;
    esac
fi