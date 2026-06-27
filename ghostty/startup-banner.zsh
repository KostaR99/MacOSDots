# Show a startup banner only for interactive Ghostty shells.
if [[ -o interactive
  && -z "${GHOSTTY_STARTUP_BANNER_SHOWN:-}"
  && -z "${NO_GHOSTTY_BANNER:-}"
  && ( "${TERM_PROGRAM:-}" == "ghostty" || "${TERM:-}" == xterm-ghostty* )
]]; then
  export GHOSTTY_STARTUP_BANNER_SHOWN=1

  __ghostty_startup_banner() {
    __ghostty_center() {
      emulate -L zsh
      setopt extended_glob

      local line="$1"
      local clean="${line//$'\033'\[[0-9;?]##[[:alpha:]]/}"
      clean="${clean%%[[:space:]]##}"
      local columns="${COLUMNS:-80}"
      local pad=$(( (columns - ${#clean}) / 2 ))

      (( pad < 0 )) && pad=0
      printf '%*s%s\n' "$pad" '' "$line"
    }

    __ghostty_center_block_line() {
      local color="$1"
      local width="$2"
      local line="$3"
      local columns="${COLUMNS:-80}"
      local pad=$(( (columns - width) / 2 ))

      (( pad < 0 )) && pad=0
      printf '%*s%s%-*s%s\n' "$pad" '' "$color" "$width" "$line" "$reset"
    }

    __ghostty_render_wordmark_line() {
      local width="$1"
      local row="$2"
      local total_rows="$3"
      local line="$4"
      local columns="${COLUMNS:-80}"
      local pad=$(( (columns - width) / 2 ))
      local output=""
      local char=""
      local color_index=0
      local row_color=""
      local -a block_colors=(
        $'\033[38;2;16;86;145m'
        $'\033[38;2;24;111;167m'
        $'\033[38;2;45;145;196m'
        $'\033[38;2;101;180;207m'
        $'\033[38;2;231;190;103m'
        $'\033[38;2;222;140;76m'
        $'\033[38;2;218;65;43m'
      )

      (( pad < 0 )) && pad=0
      if (( total_rows > 1 )); then
        color_index=$(( ((row - 1) * (${#block_colors} - 1)) / (total_rows - 1) + 1 ))
      else
        color_index=1
      fi
      row_color="${block_colors[$color_index]}"

      for (( i = 1; i <= ${#line}; i++ )); do
        char="${line[i]}"
        if [[ "$char" == " " ]]; then
          output+=" "
        else
          output+="${row_color}█${reset}"
        fi
      done

      printf '%*s%s\n' "$pad" '' "$output"
    }

    __ghostty_render_mascot() {
      local mascot_path="$HOME/.config/ghostty/qsta-mascot.png"
      local columns="${COLUMNS:-80}"
      local image_width="${QSTA_MASCOT_WIDTH:-48}"
      local image_height="${QSTA_MASCOT_HEIGHT:-22}"

      [[ -r "$mascot_path" && -t 1 ]] || return 1
      command -v chafa >/dev/null 2>&1 || return 1

      chafa --format=kitty \
        --passthrough=auto \
        --animate=off \
        --duration=0 \
        --size="${image_width}x${image_height}" \
        --view-size="${columns}x${image_height}" \
        --align=top,mid \
        "$mascot_path" 2>/dev/null
    }

    local reset=$'\033[0m'
    local orange=$'\033[38;2;218;65;43m'
    local gold=$'\033[38;2;231;190;103m'
    local muted=$'\033[38;2;143;184;202m'
    local host_name="${HOST:-localhost}"
    local os_name="macOS"
    local os_version=""
    local arch=""
    local shell_name="${SHELL##*/}"
    local terminal_name="${TERM_PROGRAM:-${TERM:-terminal}}"
    local figlet_bin=""
    local figlet_font="block"
    local line=""

    [[ -z "$host_name" ]] && host_name="$(hostname -s 2>/dev/null)"
    if command -v sw_vers >/dev/null 2>&1; then
      os_name="$(sw_vers -productName 2>/dev/null)"
      os_version="$(sw_vers -productVersion 2>/dev/null)"
    fi
    arch="$(uname -m 2>/dev/null)"

    local -a logo=(
      "           @@@@@@@@@@@@@@"
      "        @@@@@@@@@@@@@@@@@@@@"
      "      @@@@@@@@@@@@@@@@@@@@@@@@"
      "     @@@@@@@@@@    @@@@@@@@@@"
      "     @@@@@@@@@@@@@@@@@@@@@@@@"
      "      @@@@@@@@@@@@@@@@@@@@@@"
      "      @@@@@@  @@@@@@  @@@@@@"
      "     @@@@@      @@      @@@@@"
    )

    local -a wordmark=()

    if command -v figlet >/dev/null 2>&1; then
      figlet_bin="$(command -v figlet)"
    elif [[ -x /opt/homebrew/bin/figlet ]]; then
      figlet_bin="/opt/homebrew/bin/figlet"
    elif [[ -x /usr/local/bin/figlet ]]; then
      figlet_bin="/usr/local/bin/figlet"
    fi

    if [[ -n "$figlet_bin" ]]; then
      wordmark=("${(@f)$("$figlet_bin" -f "$figlet_font" -w 120 QSTA 2>/dev/null)}")
    fi

    if (( ${#wordmark} == 0 )); then
      wordmark=(
      " @@@@@@    @@@@@@   @@@@@@@@   @@@@@@ "
      "@@@@@@@@  @@@@@@@@  @@@@@@@@  @@@@@@@@"
      "@@    @@  @@           @@     @@    @@"
      "@@    @@  @@           @@     @@    @@"
      "@@    @@  @@@@@@@      @@     @@@@@@@@"
      "@@  @ @@   @@@@@@@     @@     @@@@@@@@"
      "@@   @@@        @@     @@     @@    @@"
      "@@@@@@@@  @@@@@@@@     @@     @@    @@"
      " @@@@@ @@  @@@@@@      @@     @@    @@"
      )
    fi

    local -a info=(
      "Welcome back, ${USER}"
      "$(date '+%a %d %b %Y %H:%M')"
      "${USER}@${host_name}"
      "${os_name} ${os_version} ${arch}"
      "${shell_name} - ${terminal_name}"
    )
    local wordmark_width=0

    for line in "${wordmark[@]}"; do
      (( ${#line} > wordmark_width )) && wordmark_width=${#line}
    done

    printf '\n'
    if ! __ghostty_render_mascot; then
      for line in "${logo[@]}"; do
        __ghostty_center "${orange}${line}${reset}"
      done
    fi
    printf '\n'
    local row=1
    for line in "${wordmark[@]}"; do
      __ghostty_render_wordmark_line "$wordmark_width" "$row" "${#wordmark}" "$line"
      (( row++ ))
    done
    printf '\n'
    for line in "${info[@]}"; do
      __ghostty_center "${muted}${line}${reset}"
    done
    printf '\n'
    unfunction __ghostty_center 2>/dev/null
    unfunction __ghostty_center_block_line 2>/dev/null
    unfunction __ghostty_render_wordmark_line 2>/dev/null
    unfunction __ghostty_render_mascot 2>/dev/null
  }

  __ghostty_startup_banner
  unfunction __ghostty_startup_banner 2>/dev/null
fi
