# name: Agnoster
# Stripped version of Agnoster theme (https://gist.github.com/3712874)
# - vcs branch etc were stripped
# - hostname/username were replaced with emoji

set -g current_bg NONE
set -g segment_separator \uE0B0
set -g right_segment_separator \uE0B0
set -q scm_prompt_blacklist; or set -g scm_prompt_blacklist
set -q max_package_count_visible_in_prompt; or set -g max_package_count_visible_in_prompt 10
# We support trimming the version only in simple cases, such as "1.2.3".
set -q try_to_trim_nix_package_version; or set -g try_to_trim_nix_package_version yes

# ===========================
# Color setting

# You can set these variables in config.fish like:
# set -g color_dir_bg red
# If not set, default color from agnoster will be used.
# ===========================

set -q color_virtual_env_bg; or set -g color_virtual_env_bg white
set -q color_virtual_env_str; or set -g color_virtual_env_str black
set -q color_user_bg; or set -g color_user_bg black
set -q color_user_str; or set -g color_user_str yellow
set -q color_dir_bg; or set -g color_dir_bg blue
set -q color_dir_str; or set -g color_dir_str black
set -q color_status_nonzero_bg; or set -g color_status_nonzero_bg black
set -q color_status_nonzero_str; or set -g color_status_nonzero_str red
set -q glyph_status_nonzero; or set -g glyph_status_nonzero "✘"
set -q color_status_superuser_bg; or set -g color_status_superuser_bg black
set -q color_status_superuser_str; or set -g color_status_superuser_str yellow
set -q glyph_status_superuser; or set -g glyph_status_superuser "🔒"
set -q color_status_jobs_bg; or set -g color_status_jobs_bg black
set -q color_status_jobs_str; or set -g color_status_jobs_str cyan
set -q glyph_status_jobs; or set -g glyph_status_jobs "⚡"
set -q color_status_private_bg; or set -g color_status_private_bg black
set -q color_status_private_str; or set -g color_status_private_str purple
set -q glyph_status_private; or set -g glyph_status_private "⚙"

# ===========================
# Segments functions
# ===========================

function prompt_segment -d "Function to draw a segment"
  set -l bg
  set -l fg
  if [ -n "$argv[1]" ]
    set bg $argv[1]
  else
    set bg normal
  end
  if [ -n "$argv[2]" ]
    set fg $argv[2]
  else
    set fg normal
  end
  if [ "$current_bg" != 'NONE' -a "$argv[1]" != "$current_bg" ]
    set_color -b $bg
    set_color $current_bg
    echo -n "$segment_separator "
    set_color -b $bg
    set_color $fg
  else
    set_color -b $bg
    set_color $fg
    echo -n " "
  end
  set current_bg $argv[1]
  if [ -n "$argv[3]" ]
    echo -n -s $argv[3] " "
  end
end

function prompt_finish -d "Close open segments"
  if [ -n $current_bg ]
    set_color normal
    set_color $current_bg
    echo -n "$segment_separator "
    set_color normal
  end
  set -g current_bg NONE
end


# ===========================
# Theme components
# ===========================

function prompt_virtual_env -d "Display Python or Nix virtual environment"
  set envs

  if test "$CONDA_DEFAULT_ENV"
    set envs $envs "conda[$CONDA_DEFAULT_ENV]"
  end

  if test "$VIRTUAL_ENV"
    set py_env (basename $VIRTUAL_ENV)
    set envs $envs "py[$py_env]"
  end

  # Support for `nix shell` command in nix 2.4+. Only the packages passed on the command line are
  # available in PATH, so it is useful to print them all.
  set nix_packages
  for p in $PATH
    set package_name_version (string match --regex '/nix/store/\w+-([^/]+)/.*' $p)[2]
    if test "$package_name_version"
      set package_name (string match --regex '^(.*)-(\d+(\.\d)+|unstable-20\d{2}-\d{2}-\d{2})' $package_name_version)[2]
      if test "$try_to_trim_nix_package_version" = "yes" -a -n "$package_name"
        set package $package_name
      else
        set package $package_name_version
      end
      if not contains $package $nix_packages
        set nix_packages $nix_packages $package
      end
    end
  end
  if test (count $nix_packages) -gt $max_package_count_visible_in_prompt
    set nix_packages $nix_packages[1..$max_package_count_visible_in_prompt] "..."
  end

  if [ "$IN_NIX_SHELL" = "impure" ]
    # Support for
    #   1) `nix-shell` command 
    #   2) `nix develop` command in nix 2.4+.
    # These commands are typically dumping too many packages into PATH for it be useful to print
    # them. Thus we only print "nix[impure]".
    set envs $envs "nix[impure]"
  else if test "$nix_packages"
    # Support for `nix-shell -p`. Would print "nix[foo bar baz]".
    # We check for this case after checking for "impure" because impure brings too many packages 
    # into PATH.
    set envs $envs "nix[$nix_packages]"
  else if test "$IN_NIX_SHELL"
    # Support for `nix-shell --pure`. Would print "nix[pure]".
    # We check for this case after checking for individual packages because it otherwise might 
    # confuse the user into believing when they are in a pure shell, after they have invoked 
    # `nix shell` from within it.
    set envs $envs "nix[$IN_NIX_SHELL]"
  end

  if test "$envs"
    prompt_segment $color_virtual_env_bg $color_virtual_env_str (string join " " $envs)
  end
end

# I prefer this being stripped and not customized by username/hostname.
# Lookup original version of the agnoster theme from ohmyfish to change back.
function prompt_user -d "Display current user if different from $default_user"
  prompt_segment $color_user_bg $color_user_str 🥦
end

function prompt_dir -d "Display the current directory"
  prompt_segment $color_dir_bg $color_dir_str (prompt_pwd)
end

function prompt_status -d "the symbols for a non zero exit status, root and background jobs"
    if [ $RETVAL -ne 0 ]
      prompt_segment $color_status_nonzero_bg $color_status_nonzero_str $glyph_status_nonzero
    end

    if [ "$fish_private_mode" ]
      prompt_segment $color_status_private_bg $color_status_private_str $glyph_status_private
    end

    # if superuser (uid == 0)
    set -l uid (id -u $USER)
    if [ $uid -eq 0 ]
      prompt_segment $color_status_superuser_bg $color_status_superuser_str $glyph_status_superuser
    end

    # Jobs display
    if [ (jobs -l | wc -l) -gt 0 ]
      prompt_segment $color_status_jobs_bg $color_status_jobs_str $glyph_status_jobs
    end
end

# ===========================
# Apply theme
# ===========================

function fish_prompt
  set -g RETVAL $status
  prompt_status
  prompt_user
  prompt_dir
  prompt_virtual_env
  prompt_finish
end
