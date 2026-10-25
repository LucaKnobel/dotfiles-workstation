
#!/usr/bin/env bash
set -euo pipefail

# Export portable GNOME settings to the dotfiles repository.
#
# Reads the current GNOME configuration from dconf and updates:
#   - gnome/settings.ini    Desktop preferences and shortcuts
#   - gnome/app-layout.ini  Application folders and grid layout
#
# Only selected, portable settings are exported. Session history,
# window geometry, personal paths, and hardware-specific settings
# are excluded.
#
# Existing configuration files are updated only when their content
# changes. No settings are applied to GNOME and no Git commits
# are created automatically.
#
# Usage: ./scripts/export-gnome.sh

REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
GNOME_DIR="$REPO_ROOT/gnome"

SETTINGS="$GNOME_DIR/settings.ini"
APP_LAYOUT="$GNOME_DIR/app-layout.ini"

# Check dependencies and configuration files.
command -v dconf >/dev/null 2>&1 || {
    echo "ERROR: dconf is not installed." >&2
    exit 1
}

for file in "$SETTINGS" "$APP_LAYOUT"; do
    [[ -f "$file" ]] || {
        echo "ERROR: Missing configuration file: $file" >&2
        exit 1
    }
done

# Determine whether a setting is portable across devices.
is_portable() {
    local section="$1"
    local key="$2"

    case "$section" in
        desktop/interface|desktop/input-sources|desktop/calendar|\
        desktop/media-handling|desktop/peripherals/keyboard|\
        desktop/peripherals/mouse|desktop/peripherals/touchpad|\
        desktop/wm/keybindings|desktop/wm/preferences|\
        desktop/session|desktop/search-providers|\
        desktop/screen-time-limits|desktop/break-reminders/*|\
        desktop/a11y/*|mutter|shell/keybindings|\
        shell/app-switcher|nautilus/icon-view|\
        nautilus/list-view|nautilus/preferences|papers/default|\
        settings-daemon/plugins/color|\
        settings-daemon/plugins/media-keys|\
        settings-daemon/plugins/media-keys/custom-keybindings/*)
            ;;

        desktop/screensaver)
            [[ "$key" == "lock-delay" ]] || return 1
            ;;

        calculator)
            case "$key" in
                base|button-mode|source-units|target-units|unit-category)
                    ;;
                *)
                    return 1
                    ;;
            esac
            ;;

        *)
            return 1
            ;;
    esac

    # Exclude transient and machine-specific values.
    case "$key" in
        mru-sources|migrated-gtk-settings|window-*|last-*|\
        picture-uri|picture-uri-dark)
            return 1
            ;;
    esac

    return 0
}

# Determine whether a setting belongs to the application layout.
is_app_layout() {
    local section="$1"
    local key="$2"

    case "$section" in
        desktop/app-folders|desktop/app-folders/folders/*)
            return 0
            ;;

        shell)
            [[ "$key" == "app-picker-layout" ||
               "$key" == "favorite-apps" ]]
            ;;

        *)
            return 1
            ;;
    esac
}

# Replace a configuration file only if its content has changed.
update_file() {
    local target="$1"
    local temporary="$2"

    chmod --reference="$target" "$temporary"

    if cmp -s "$target" "$temporary"; then
        echo "Unchanged: ${target#"$REPO_ROOT"/}"
    else
        mv -f -- "$temporary" "$target"
        echo "Updated: ${target#"$REPO_ROOT"/}"
    fi
}

# Export selected settings from the current dconf database.
export_gnome() {
    local section=""
    local line key value
    local settings_section=""
    local layout_section=""
    local settings_count=0
    local layout_count=0

    local temp_settings temp_layout temp_dump

    temp_settings="$(mktemp "$GNOME_DIR/.settings.XXXXXX")"
    temp_layout="$(mktemp "$GNOME_DIR/.app-layout.XXXXXX")"
    temp_dump="$(mktemp "$GNOME_DIR/.dconf-dump.XXXXXX")"

    # Remove temporary files when the function finishes.
    trap 'rm -f -- "$temp_settings" "$temp_layout" "$temp_dump"' RETURN

    # Read dconf before modifying any configuration files.
    dconf dump /org/gnome/ > "$temp_dump"

    if [[ ! -s "$temp_dump" ]]; then
        echo "ERROR: GNOME dconf export is empty." >&2
        return 1
    fi

    printf '# Portable GNOME desktop settings\n\n' > "$temp_settings"
    printf '# GNOME application folders and grid layout\n\n' > "$temp_layout"

    while IFS= read -r line || [[ -n "$line" ]]; do

        # Ignore comments and empty lines.
        [[ -z "$line" || "$line" == \#* ]] && continue

        # Identify the current dconf section.
        if [[ "$line" =~ ^\[([^]]+)\]$ ]]; then
            section="${BASH_REMATCH[1]}"
            continue
        fi

        [[ -n "$section" && "$line" == *=* ]] || continue

        key="${line%%=*}"
        value="${line#*=}"

        # Export portable desktop settings.
        if is_portable "$section" "$key"; then

            if [[ "$settings_section" != "$section" ]]; then
                if [[ -n "$settings_section" ]]; then
                    printf '\n' >> "$temp_settings"
                fi

                printf '[%s]\n' "$section" >> "$temp_settings"
                settings_section="$section"
            fi

            printf '%s=%s\n' "$key" "$value" >> "$temp_settings"
            ((settings_count+=1))

        # Export application folders and grid layout.
        elif is_app_layout "$section" "$key"; then

            if [[ "$layout_section" != "$section" ]]; then
                if [[ -n "$layout_section" ]]; then
                    printf '\n' >> "$temp_layout"
                fi

                printf '[%s]\n' "$section" >> "$temp_layout"
                layout_section="$section"
            fi

            printf '%s=%s\n' "$key" "$value" >> "$temp_layout"
            ((layout_count+=1))
        fi

    done < "$temp_dump"

    # Ensure that both exports contain data.
    if ((settings_count == 0 || layout_count == 0)); then
        echo "ERROR: No matching GNOME configuration found." >&2
        return 1
    fi

    # Update the repository files.
    update_file "$SETTINGS" "$temp_settings"
    update_file "$APP_LAYOUT" "$temp_layout"

    printf '\nExported %d desktop settings and %d layout entries.\n' \
        "$settings_count" "$layout_count"
}

export_gnome

echo "GNOME export completed."
echo "Review changes with: git diff -- gnome/"
