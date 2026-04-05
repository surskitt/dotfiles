#!/bin/bash

  ####                     ####
####  Default User Settings  ####
  ####                     ####

# Threads - requires env_parallel, in threaded mode setting both to "0" calls env_parallel without a jobs option, which should use all available threads
threads_used="0"                   # maximum number of threads to use
threads_unused="0"                 # number of threads to leave unused

# SoX command construction: $sox_bits and $sox_dither are unset for 24 bit outputs, and $sox_rate is unset for 24/44 and 24/48 sources
# $> sox -V${sox_verbosity_level} $sox_global_opts $sox_format_opts_infile INPUT.flac $sox_format_opts_outfile $sox_bits OUTPUT.flac $sox_rate RATE $sox_dither

# sox binary to use - if set to an invalid path the script will exit, and sox is automatically detected when unset
sox=""                             # an absolute path is not necessarily required, but is recommended

# sox verbosity level, this is the argument used for sox's "-V" option, it must only be set with either "0", "1", "2", "3", or "4"
sox_verbosity_level=""             # defaults to "2" if unset or invalid, disables "redo_clipped_dithers" when set to "0" or "1"

# 'global' sox options, excluding "-V" which has its own setting above
sox_global_opts="-G -R"

# sox 'format options' applicable to the input file
sox_format_opts_infile=""

# sox 'format options' applicable to the output file, excluding '-b' which is set automatically, and follows $sox_format_opts_outfile in sox's invocation
sox_format_opts_outfile=""

# SoX dither                       # "dither" is recommended, but noise-shaped dither ("dither -s") may help with sources for which -G/--guard is
sox_dither="dither"                # not sufficient to prevent clipping, and any other valid dither effect command may be set here

# secondary SoX dither command     # If sox is successful but dither-related clipping is detected, and the "redo_clipped_dithers" script option is enabled, sox is run
sox_clipped_dither="dither -s"     # a second time using this alternate dither command. Defaults to "dither -s" if unset. Sox will likely fail if command is invalid.

# SoX rate
sox_rate="rate -v -L"              # Set any valid rate effect command for SoX here, "rate -v -L" is recommended

# FLAC Padding - set to "0" to disable adding padding to output files - NB: without padding tag edits require completely rewriting the entire flac file
flac_padding="4096"                # length in bytes of the padding block added by metaflac to converted files (+4 more bytes for padding block header)

# Automator users on MacOS may have issues where depedencies installed via Homebrew, like sox, are not discoverable by default in the environment which Automator runs the script.
# The location for Homebrew binaries currently defaults to a "bin" folder found in either /usr/local (Intel Macs), or /opt/homebrew (Apple Silicon Macs). With Homebrew installed you
# should be able to test if either of these is the case by running "brew --prefix" in Terminal, to print the location applicable on your system. If either default value is returned,
# leave homebrew_bin empty/unset below (or use the -W option if you want to keep a non-standard default set here), and your Homebrew programs should be successfully detected. If you
# want to use Homebrew programs in a non-standard prefix (which is not recommended by the Homebrew project for normal users), you can set homebrew_bin below with the path to the
# applicable "bin" folder, or provide the folder as the argument to the -w option.
homebrew_bin=""                    # leave empty/unset to check both default Homebrew prefix locations

# env_parallel and env_parallel.bash overrides - specify absolute path(s) here if either file is not detected
env_parallel_command="env_parallel"    # default: "env_parallel"       --- both       must    detected    use          threads
env_parallel_bash="env_parallel.bash"  # default: "env_parallel.bash"  ---      files      be          to     multiple

# custom output directory name
custom_outdir="defaults"           # use "defaults" for script defaults, or set name to use for all output folders

# Script Features - setting the value for options below to "1" enables them, any other text (or lack thereof) between the double-quotes disables
threads_off="0"                    # use single threaded mode

recurse_all_subdirs="1"            # find/use as potential sources, all flac files at any tree depth under any directories provided as command line arguments
                                   # when disabled only flac files found in the specific directories provided as arguments, and their immediate subdirectories, are used

embed_artwork="1"                  # embed in target flac(s), the first PICTURE block embedded in corresponding source flac(s)

use_24_44_and_24_48_input="1"      # output 16/44 and 16/48 from 24/44 and 24/48 sources
use_24_88_and_24_96_output="0"     # output 24/88.2 and 24/96 from 24/176.4 and 24/192 sources

redo_clipped_dithers="1"           # if clipping is detected on one or more samples while downconverting, try again using the alternate dither command defined by the
                                   # "sox_clipped_dither" option, or by the argument to "--dd" at runtime, or with the default alternate (dither -s) when using "--sox-clipped-dither"

use_SOURCE_FFP_tag="1"             # create a tag containing the md5sum for the source file's decompressed audio stream, AKA the FLAC Fingerprint
use_SOURCE_SPECS_tag="1"           # create a tag detailing the source file's bit depth and sample rate
use_SOX_COMMAND_tag="1"            # create a tag detailing the SoX command used to convert the file

use_progress_bar="0"               # use GNU Parallel's progress bar (no effect in single thread mode)

use_colours="1"                    # use colours and bold text in console text outputs

# 'increase_verbosity' and 'sox_emits' both require 'verbose_output' to be enabled, or '-i' / '--info' to be passed on the command line
verbose_output="1"                 # print per-file conversion details to stdout during operation
increase_verbosity="0"             # print additional success messages
sox_emits="1"                      # emit any output from sox to stdout & stderr

  ####                       ####
####  End of Default Settings  ####
  ####                       ####


_print_usage() {
	command -v cat >/dev/null 2>&1 || { _error "'cat' not found (?!), no '--help' for you!" ;return 1 ; }
	cat <<EOF
${bold}USAGE:${default}

$0 [OPTION [ARGUMENT]]... [--] FILE_OR_FOLDER [FILE_OR_FOLDER]...


${bold}OPTIONS:${default}

${bold}Script:${default}
-h, -H, --help                           Print this help text and exit.
--                                       End of options. Following arguments taken as files/folders for conversion.

-e, --8896                               Output 24/88.2 and 24/96 from 24/176.4 and 24/192 sources.
-E, --no-8896                            Don't output 24/88.2 and 24/96 from 24/176.4 and 24/192 (but do output 16/44 and 16/48).

-f, --4448                               Output 16/44 and 16/48 from 24/44 and 24/48 sources.
-F, --no-4448                            Don't use 24/44 and 24/48 sources.

-i, --info                               Print each filename and some basic status information while running, and errors.
-I, --info-off                           Only print start/end messages (numbers of source/target files, overall success/failure), and errors.

-k, --colour                             Use colours and bold text in console output.
-K, --no-colour                          Don't use colours or bold text in console output.

-l, --redo-clipped-dithers               When clipping is detected, run sox a second time using the currently configured alternate dither command.
                                         See ${bold}--dd${default} and ${bold}--DD${default} in the SoX section below.
-L, --no-redo-clipped-dithers            Disable re-running sox when clipping is detected on the the first attempt.

-n "ARG", --env-parallel "ARG"           Use the name (or absolute path) "ARG" for "env_parallel". Currently set to: "$env_parallel_command".
-N "ARG", --env-parallel-bash "ARG"      Use the name (or absolute path) "ARG" for "env_parallel.bash". Currently set to: "$env_parallel_bash".

-o, --threads-on                         Use env_parallel for multi-threaded operation.
-O, --threads-off                        Don't use env_parallel, run in single-threaded mode.

-P, --print-defaults                     Print a list of all user options and their current defaults.

-t ARG, --threads ARG                    Number of threads to use. Disables "${bold}-T${default} / ${bold}--unthreads${default}". Set to "0" to use all available threads.
-T ARG, --unthreads ARG                  Number of threads to leave unused. Disables "${bold}-t${default} / ${bold}--threads${default}". Set to "0" to use all available threads.

-u, --recurse                            Find/use as potential sources, all flac files at any tree depth under any directories provided as command line arguments.
-U, --no-recurse                         Only flac files found in the specific directories provided as arguments, and their immediate subdirectories, are used.

-v, --increase-verbosity                 Print additional success messages. Depends on "${bold}-i${default} / ${bold}--info${default}" (verbose_output option).
--no-increase-verbosity                  Do not print additional success messages in verbose output mode.

--version                                Print script version number.

-w "ARG", --homebrew-bin "ARG"           Set the location of your Homebrew binaries for non-default Homebrew prefixes, eg: "/Users/you/homebrew/bin"
-W, --default-homebrew                   Check for Homebrew binaries in the default locations for both Intel and Apple Silicon Macs (default)

-z, --custom-outdir "ARG"                Set name for all output folders to "ARG".
-Z, --default-outdir                     Use the default target-rate-based output folder naming.


${bold}metaflac:${default}
-a, --artwork                            Embed in target flac(s), the first PICTURE block embedded in source flac(s).
-A, --no-artwork                         Do not re-embed source-embedded artwork in target flac(s).

-c, --command-tag                        Tag output with the SoX command (not including file paths/names) used to convert the file.
-C, --no-command-tag                     Do not tag output with the SoX command used to convert the file.

-m, --ffp-tag                            Tag output with the source file's flac fingerprint.
-M, --no-ffp-tag                         Do not tag output with the source file's flac fingerprint.

-p ARG, --padding ARG                    Number of bytes to use for FLAC padding. Set to 0 to disable adding any padding (not recommended).

-s, --source-tag                         Tag output with the source file's bit depth and sample rate.
-S, --no-source-tag                      Do not tag output with the source file's bit depth and sample rate.


${bold}GNU Parallel:${default}
-b, --progress-bar                       Use GNU Parallel's progress bar. No effect in single thread mode.
-B, --no-progress-bar                    Don't use GNU Parallel's progress bar.


${bold}SoX:${default}
-d "ARG", --dither "ARG"                 Dither effect command for SoX, arguments with spaces should be quoted.
-D, --default-dither                     Sets dither command to "${bold}dither${default}".

--dd "ARG", --sox-clipped-dither "ARG"   Use "ARG" as the alternate SoX dither command, in case clipping occurs on the first run.
--DD, --default-clipped-dither           Use the default alternate SoX dither command, "${bold}dither -s${default}", in case of clipping on first run.

-r "ARG", --rate "ARG"                   Rate effect command for SoX, arguments with spaces should be quoted.
-R, --default-rate                       Sets rate command to "${bold}rate -v -L${default}" (very high quality, linear phase response).

--svl "ARG"                              Set SoX's verbosity level option, see "${bold}-V${default}" below, and/or the sox manpage.
--sgo "ARG"                              Set SoX's Global options, see sox manpage for more information. Defaults to "${bold}-G -R${default}".
--sfoi "ARG"                             Set SoX's Format options for the input file, empty by default. See sox manpage.
--sfoo "ARG"                             Set SoX's Format options for the output file, except "${bold}-b${default}" which is set automatically. Empty by default. See sox manpage.

-V "ARG", --sox-verbosity "ARG"          Set SoX's verbosity level, argument must be either "${bold}0${default}", "${bold}1${default}", "${bold}2${default}", "${bold}3${default}", or "${bold}4${default}'.
                                         Levels 0 and 1 disable ${bold}--redo-clipped-dithers${default}, defaults to level 2 if unset or invalid.

-x --sox-emits                           Emit SoX's stdout/stderr as part of per-file status, requires "${bold}-i${default} / ${bold}--info${default}" (verbose_output option), and a
                                         non-zero setting for "${bold}-V${default} / ${bold}--svl${default}" (sox_verbosity_level option).
-X --no-sox-emits                        Do not emit SoX's stdout/stderr.

-y "ARG", --sox "ARG"                    Use "ARG" for sox binary, disable automatic sox detection.
-Y, --default-sox                        Use the sox binary detected by 'command -v sox'.

EOF
}

version="0.9.3-pre"

# ELSE colour vars are never set, every colour-code-containing printf argument will be empty
# colourful printf       # tput is not always present
[ "$use_colours" = "1" ] && {
	    red=$'\033[0;31m'    # "$( tput setaf 1 )"
	  green=$'\033[0;32m'    # "$( tput setaf 2  )"
	 orange=$'\033[0;33m'    # "$( tput setaf 3 )"
	   bold=$'\033[1m'       #     tput srg1 # ??
	default=$'\033[0m'       # "$( tput sgr0 )"
}

_message() {
	case "$1" in
		-n) shift; printf '%s\n'   "$@" ;;
		-N) shift; printf '%s\n\n' "$@" ;;
		 *)        printf '%s'     "$@" ;;
	esac
}
_warning() { printf >&2 '%sWARNING%s: %s\n\n' "${orange}" "${default}" "$@" ; } # NB: these redirects to stderr seem to screw with placement among other messages when using
_error()   { printf >&2 '%sERROR%s: %s\n\n'   "${red}"    "${default}" "$@" ; } #     parallel/env_parallel... occam's razor: env_parallel emits all stdout first, then all stderr. hah!
_st_or_quit() { unset quitnow # "local quitnow" instead? same difference?
				read -n 1 -erp "Press Q/q/A/a to abort, or any other character to continue in single threaded mode: " quitnow
				_message -n
				[[ $quitnow == [QqAa] ]] && { _message -N "Aborting." ;exit 1 ; }
			  }

_message -n

# runtime options -- letters left: gG jJ qQ
while true ;do
	case "$1" in
		-a|--artwork)
			embed_artwork="1"
			shift
			;;
		-A|--no-artwork)
			embed_artwork="0"
			shift
			;;
		-b|--progress-bar)
			use_progress_bar="1"
			shift
			;;
		-B|--no-progress-bar)
			use_progress_bar="0"
			shift
			;;
		-c|--command-tag)
			use_SOX_COMMAND_tag="1"
			shift
			;;
		-C|--no-command-tag)
			use_SOX_COMMAND_tag="0"
			shift
			;;
		-d|--dither)
			_warning "Validity of the dither effect command is your responsibility. Arguments with spaces should be quoted."
			sox_dither="$2"
			shift 2
			;;
		-D|--default-dither)
			sox_dither="dither"
			shift
			;;
		--dd|--sox-clipped-dither)
			sox_clipped_dither="$2"
			shift 2
			;;
		--DD|--default-clipped-dither)
			sox_clipped_dither="dither -s"
			shift
			;;
		-e|--8896)
			use_24_88_and_24_96_output="1"
			shift
			;;
		-E|--no-8896)
			use_24_88_and_24_96_output="0"
			shift
			;;
		-f|--4448)
			use_24_44_and_24_48_input="1"
			shift
			;;
		-F|--no-4448)
			use_24_44_and_24_48_input="0"
			shift
			;;
		-h|-H|--help)
			_print_usage ;exit
			;;
		-i|--info)
			verbose_output="1"
			shift
			;;
		-I|--info-off)
			verbose_output="0"
			shift
			;;
		-k|--colour)
			use_colours="1"
			shift
			;;
		-K|--no-colour)
			use_colours="0"
			shift
			;;
		-l|--redo-clipped-dithers)
			redo_clipped_dithers="1"
			shift
			;;
		-L|--no-redo-clipped-dithers)
			redo_clipped_dithers="0"
			shift
			;;
		-m|--ffp-tag)
			use_SOURCE_FFP_tag="1"
			shift
			;;
		-M|--no-ffp-tag)
			use_SOURCE_FFP_tag="0"
			shift
			;;
		-n|--env-parallel)
			env_parallel_command="$2"
			shift 2
			;;
		-N|--env-parallel-bash)
			env_parallel_bash="$2"
			shift 2
			;;
		-o|--threads-on)
			threads_off="0"
			shift
			;;
		-O|--threads-off)
			threads_off="1"
			shift
			;;
		-p|--padding)
			flac_padding="$2"
			shift 2
			;;
		-P|--print-defaults) # ?? worth figuring out having all these defaults in an assoc. array and not using "${!var}" ?? not as much as other things probably
			printf '%sCurrent Default User Settings%s:\n' "${bold}" "${default}"
			for var in threads_used threads_unused sox_verbosity_level sox_global_opts sox_format_opts_infile sox_format_opts_outfile sox_dither sox_clipped_dither sox_rate \
									flac_padding homebrew_bin env_parallel_command env_parallel_bash custom_outdir threads_off recurse_all_subdirs embed_artwork \
									use_24_44_and_24_48_input use_24_88_and_24_96_output redo_clipped_dithers use_SOURCE_FFP_tag use_SOURCE_SPECS_tag use_SOX_COMMAND_tag \
									use_progress_bar verbose_output increase_verbosity sox_emits ;do
				printf '%30s %s\n' "${var}:" "${!var}" # https://unix.stackexchange.com/a/222586, https://unix.stackexchange.com/a/631737
			done
			printf '\n'
			exit
			;;
		-r|--rate)
			_warning "Validity of the rate effect command is your responsibility. Arguments with spaces should be quoted."
			sox_rate="$2"
			shift 2
			;;
		-R|--default-rate)
			sox_rate="rate -v -L"
			shift
			;;
		-s|--source-tag)
			use_SOURCE_SPECS_tag="1"
			shift
			;;
		-S|--no-source-tag)
			use_SOURCE_SPECS_tag="0"
			shift
			;;
		--sgo)
			sox_global_opts="$2"
			shift 2
			;;
		--sfoi)
			sox_format_opts_infile="$2"
			shift 2
			;;
		--sfoo)
			sox_format_opts_outfile="$2"
			shift 2
			;;
		-t|--threads)
			threads_used="$2" ;threads_unused="0"
			shift 2
			;;
		-T|--unthreads)
			threads_unused="$2" ;threads_used="0"
			shift 2
			;;
		-u|--recurse)
			recurse_all_subdirs="1"
			shift
			;;
		-U|--no-recurse)
			recurse_all_subdirs="0"
			shift
			;;
		-v|--increase-verbosity)
			increase_verbosity="1"
			shift
			;;
		--no-increase-verbosity)
			increase_verbosity="0"
			shift
			;;
		-V|--sox-verbosity|--svl)
			sox_verbosity_level="$2"
			shift 2
			;;
		--version)
			printf 'downsampler-threaded v%s\n' "$version"
			exit 0
			;;
		-w|--homebrew-bin)
			homebrew_bin="$2"
			shift 2
			;;
		-W|--default-homebrew)
			homebrew_bin=""
			shift
			;;
		-x|--sox-emits)
			sox_emits="1"
			shift
			;;
		-X|--no-sox-emits)
			sox_emits="0"
			shift
			;;
		-y|--sox)
			sox="$2"
			shift 2
			;;
		-Y|--default-sox)
			sox=""
			shift
			;;
		-z|--custom-outdir)
			custom_outdir="$2"
			shift 2
			;;
		-Z|--default-outdir)
			custom_outdir="defaults"
			shift
			;;
		--)
			break
			;;
		-?*)
			_error "Unknown option '$1'." ;_print_usage ;exit 1
			;;
		*)
			break
			;;

	esac
done

# argument(s) required
[[ $# -ge "1" ]] || { _error "Nothing to do, please specify at least one file or folder." ;_print_usage ;exit 1 ; }

# Bash required
[[ -n $BASH_VERSION ]] || { _error "Interpreter does not appear to be Bash, aborting." ;exit 1 ; }

# validate threads
if [[ $threads_off != "1" ]] ;then
	[[ $threads_used   != *[!0123456789]* ]] || { _error "Argument for '-t / --threads / threads_used' must be zero or a positive integer."     ;exit 1 ; }
	[[ $threads_unused != *[!0123456789]* ]] || { _error "Argument for '-T / --unthreads / threads_unused' must be zero or a positive integer." ;exit 1 ; }
fi

# validate flac padding
if [[ $flac_padding != *[!0123456789]* ]] ;then
	if [[ $flac_padding -ge "1" ]] ;then
		[[ $flac_padding -le "512" ]]  && _warning "Using only $flac_padding bytes for FLAC padding. Maybe this is enough for your needs, but it's not very much."
		[[ $flac_padding -gt "8192" ]] && _warning "Using more than 8KB for FLAC padding. Maybe your needs require that much, but it's quite a lot."
	fi
else
	_error "Argument for '-p / --padding / flac_padding' must be zero or a positive integer." ;exit 1
fi

# validate sox verbosity, etc
case $sox_verbosity_level in
	[01])
		[[ $redo_clipped_dithers == "1" ]] && {
		    _warning "redo_clipped_dithers has been disabled, requires sox_verbosity_level 2, 3, or 4, but that's currently set to $sox_verbosity_level."
			redo_clipped_dithers="0"
		}
		;;
	[234])
		true
		;;
	*)
		sox_verbosity_level="2"
		;;
esac

# is redo_clipped_dithers enabled while sox_clipped_dither is unset? - use default alternate dither command instead of disabling redo_clipped_dithers
[[ $redo_clipped_dithers == "1" && -z $sox_clipped_dither ]] && {
	printf '%sredo_clipped_dithers%s is enabled but %ssox_clipped_dither%s is unset, %ssetting secondary dither command%s to "%sdither -s%s".\n\n' \
		   "$bold" "$default" "$bold" "$default" "$orange" "$default" "$bold" "$default"
	sox_clipped_dither="dither -s"
}


# ctrl+c exits script, not just sox/whatever --- does this work as expected...?? here's guessing if/when it doesn't, it's a parallel/environment issue
trap "exit 1" INT

# dependencies
# Automator defaults to ignoring Homebrew (its PATH does not include /usr/local/bin or /opt/*/bin)
if [[ -z "$homebrew_bin" ]] ;then
	if [[ -x /usr/local/bin/brew ]] ;then
		homebrew_bin="/usr/local/bin"
	elif [[ -x /opt/homebrew/bin/brew ]] ;then
		homebrew_bin="/opt/homebrew/bin"
	fi
else
	[[ -x "$homebrew_bin"/brew ]] || {
		printf >&2 '%sERROR%s: "homebrew_bin" was set but "brew" command was not found in set location.\n' "$red" "$default"
		printf >&2 '  Try using -W to check both default locations, or provide the correct non-standard path as the argument to -w.\n'
		printf >&2 '  See comments above the "homebrew_bin" option at the top of the script for more details.\n\n'
		exit 1
	}
fi
[[ -n "$homebrew_bin" && $PATH != *"$homebrew_bin"* ]] && PATH=$PATH:"$homebrew_bin" # drop any potential user-supplied trailing slashes from *"$homebrew_bin"* here?
command -v basename >/dev/null 2>&1 || { _error "'basename' not found, aborting." ;exit 1 ; }
command -v dirname  >/dev/null 2>&1 || { _error "'dirname' not found, aborting."  ;exit 1 ; }
case $sox in
	'')
		# messages from sox refer to sox using an absolute path now
		sox="$( command -v sox 2>/dev/null )" || { _error "'sox' not found, aborting."   ;exit 1 ; }
		;;
	?*)
		[[ ! -d "$sox" && -x "$sox" ]] || {
			_error "The 'sox' variable is set, but the path is not to an executable file, aborting."
			exit 1
		}
		;;
esac

# recommends
if [[ $flac_padding != "0" || $use_SOURCE_SPECS_tag == "1" || $use_SOX_COMMAND_tag == "1" || $use_SOURCE_FFP_tag == "1" || $embed_artwork == "1" ]] ;then
	command -v metaflac >/dev/null 2>&1 || { _error "'metaflac' not found, aborting." ;exit 1 ; }
	metaflac_enabled="1"
fi

if [[ $threads_off == "1" ]] ;then
	_message -n "${orange}Running in single thread mode${default}."
elif command -v "$env_parallel_command" >/dev/null 2>&1 && command -v "$env_parallel_bash" >/dev/null 2>&1 ;then
	[[ $use_progress_bar == "1" ]] && parallel_progress_bar[0]="--bar"
	if [[ $threads_unused -gt "0" && $threads_used -gt "0" ]] ;then
		_warning "The options 'threads_used' and 'threads_unused' are mutually exclusive."
		_st_or_quit
		threads_off="1"
	else
		[[ $threads_used -gt "0" ]]   && paralleljobs[0]="-j $threads_used"
		[[ $threads_unused -gt "0" ]] && paralleljobs[0]="-j -$threads_unused"
	fi
else
	command -v "$env_parallel_command" >/dev/null 2>&1 || { _error "'env_parallel' not found - looking for this name/path: '$env_parallel_command'"
															_message -N "Try using '-n / --env-parallel' or an absolute path for 'env_parallel' in the 'Default User Settings' section."
															envparfail="1" ; }
	command -v "$env_parallel_bash" >/dev/null 2>&1 || { _error "'env_parallel.bash' not found - looking for this name/path: '$env_parallel_bash'"
														 _message -N "Try using '-N / --env-parallel-bash' or an absolute path for 'env_parallel_bash' in the 'Default User Settings' section."
														 envparfail="1" ; }
	[[ $envparfail == "1" ]] && _st_or_quit
	_message -n "${orange}Running in single thread mode${default}."
	threads_off="1"
fi

if command -v realpath >/dev/null 2>&1 ;then realpath="realpath --" ;elif command -v grealpath >/dev/null 2>&1 ;then realpath="grealpath --"
else
	_absolute_path() { ( cd -P -- "$( dirname -- "$1" )" 2>/dev/null && printf '%s/%s\n' "$PWD" "$( basename -- "$1" )" ) ; }
	realpath="_absolute_path"
fi

# handle file/folder arguments
user_args=( "$@" )
if [[ $recurse_all_subdirs == "1" ]] ;then
	if shopt -s globstar nullglob >/dev/null 2>&1 ;then
		for arg in "${user_args[@]}" ;do
			[[ -d $arg ]] && user_args+=( "$arg"/**/*.[Ff][Ll][Aa][Cc] )
		done
		shopt -u globstar nullglob
	elif command -v find >/dev/null 2>&1 ;then # is there a better test to use here that can determine if the 'find' command found has the -print0 option?
		for arg in "${user_args[@]}" ;do
			[[ -d $arg ]] && {
				#readarray -d '' dir_flacs < <( find "$arg" -type f -iname "*.flac" -print0 ) # not much of a bash<4 fallback if it needs bash 4
				dir_flacs=()                 # https://stackoverflow.com/a/23357277
				while IFS= read -r -d '' ;do # https://unix.stackexchange.com/questions/209123/understanding-ifs-read-r-line -- it says "understanding" right there in the title
					dir_flacs+=( "$REPLY" )
				done < <( find "$arg" -type f -iname "*.flac" -print0 )
				user_args+=( "${dir_flacs[@]}" )
			}
		done
	else
		_error "Could not enable globstar (Bash 4+), and could not find 'find' command, aborting."
		_message -N "If all else fails, try disabling 'recurse_all_subdirs' with '-U / --no-recurse'."
		exit 1
	fi
else
	for arg in "${user_args[@]}" ;do
		if [[ -d $arg ]] ; then
			user_args+=( "$arg"/*.[Ff][Ll][Aa][Cc] )
			for subdir in "$arg"/* ;do
				if [[ -d $subdir ]] ;then
					user_args+=( "$subdir"/*.[Ff][Ll][Aa][Cc] )
				fi
			done
		fi
	done
fi

# get absolute paths, drop any duplicates
for arg in "${user_args[@]}" ;do
	absolute_args+=( "$( $realpath "$arg" )" )
done
#readarray -t unique_args < <( printf '%s\n' "${absolute_args[@]}" | sort -u  )
while IFS= read -r -d '' ;do
	unique_args+=( "$REPLY" )
done < <( printf '%s\0' "${absolute_args[@]}" |sort -zu )

_message "Reading input file(s)... "

# just the flacs, just the 24 bit flacs
for arg in "${unique_args[@]}" ;do
	[[ ! -d $arg && $arg == *.[Ff][Ll][Aa][Cc] ]] && [[ $( "$sox" --i -b -- "$arg" ) -eq "24" ]] && absolute_flac_names+=( "$arg" )
done

# candidate flacs must exist
[[ ${#absolute_flac_names[@]} -ge "1" ]] || { _error "No candidate FLAC files found, aborting." ;exit 1 ; }

# source data
for index in "${!absolute_flac_names[@]}" ;do
	flac_filenames[$index]="$( basename -- "${absolute_flac_names[$index]}" )"
	absolute_flac_dirs[$index]="$( dirname -- "${absolute_flac_names[$index]}" )"
	flac_sample_rates[$index]="$( "$sox" --i -r -- "${absolute_flac_names[$index]}" )"
done

_message "Found ${#absolute_flac_names[@]} candidate FLAC file(s). Configuring output... "

# target data
for index in "${!absolute_flac_names[@]}" ;do

	target_bits_opt[$index]="-b 16"
	target_dither_cmd[$index]="$sox_dither"
	case ${flac_sample_rates[$index]} in
		44100|48000)
			(( use_24_44_and_24_48_input == 1 )) || continue
			target_sample_rates[$index]=""
			target_rate_cmd[$index]=""
			target_folders[$index]="${absolute_flac_dirs[$index]}/unresampled-16bit"
			;;
		88200)
			target_sample_rates[$index]="44100"
			target_folders[$index]="${absolute_flac_dirs[$index]}/resampled-16-44"
			;;
		96000)
			target_sample_rates[$index]="48000"
			target_folders[$index]="${absolute_flac_dirs[$index]}/resampled-16-48"
			;;
		176400)
			if (( use_24_88_and_24_96_output == 1 )) ;then
				target_bits_opt[$index]=""
				target_sample_rates[$index]="88200"
				target_dither_cmd[$index]=""
				target_folders[$index]="${absolute_flac_dirs[$index]}/resampled-24-88"
			else
				target_sample_rates[$index]="44100"
				target_folders[$index]="${absolute_flac_dirs[$index]}/resampled-16-44"
			fi
			;;
		192000)
			if (( use_24_88_and_24_96_output == 1 )) ;then
				target_bits_opt[$index]=""
				target_sample_rates[$index]="96000"
				target_dither_cmd[$index]=""
				target_folders[$index]="${absolute_flac_dirs[$index]}/resampled-24-96"
			else
				target_sample_rates[$index]="48000"
				target_folders[$index]="${absolute_flac_dirs[$index]}/resampled-16-48"
			fi
			;;
		*)
			continue
			;;
	esac
	[[ -n ${target_sample_rates[$index]} ]] && target_rate_cmd[$index]="${sox_rate} ${target_sample_rates[$index]}"

	# don't set target_flacs[$index] unless the flac at this index has already matched one of the rules above
	if [[ -n ${target_folders[$index]} ]] ;then
		[[ -n $custom_outdir && $custom_outdir != "defaults" ]] && target_folders[$index]="${absolute_flac_dirs[$index]}/${custom_outdir[0]}"
		target_flacs[$index]="${target_folders[$index]}/${flac_filenames[$index]}"
	fi
done

# target flacs must exist
[[ ${#target_flacs[@]} -ge "1" ]] || { _error "No targets for conversion, aborting." ;exit 1 ; }

# are any target flacs ALSO source flacs??
# do any targets already exist??
#   and what if they are/do?
# ?
# option to overwrite existing / force overwrite
# only we can't have the tier3->tier2 thread writing while the tier2->tier1 is reading...
# will they share an array index?
#

# where all the output-producing and output-modifying actions happen
_execute() {
	index="$1"

	local outerr status clipping_message artwork bits output1 output2 output3 return_code \
		  sox1 sox1_colour sox1_outerr dither1 dither1_colour sox_command \
		  sox2 sox2_colour sox2_outerr dither2 dither2_colour dither2_success \
		  metaflac_status metaflac_status_colour metaflac_failure metaflac_error

	[[ ! -d ${target_folders[$index]} ]] && mkdir -p -- "${target_folders[$index]}"


	## run sox
	if outerr="$( "$sox" -V${sox_verbosity_level} $sox_global_opts $sox_format_opts_infile "${absolute_flac_names[$index]}" $sox_format_opts_outfile ${target_bits_opt[$index]} "${target_flacs[$index]}" ${target_rate_cmd[$index]} ${target_dither_cmd[$index]} 2>&1 )" ;then
		# sox 1 is successful

		# test/debug - force fake clipping to be detected on sox1
		# printf -v outerr -- 'fake sox1 output\nsox WARN dither: dither clipped a ton of samples!\n'

		[ -n "$outerr" ] && [ "$sox_emits" = "1" ] &&
			# awk indents (each line of) $soxout, but in some modes, sox uses a carriage return on a
			# repeatedly-emitted (and newline-omitted) single line of its per-file stdout (an ongoing status/progress display)
			# sed replaces each carriage return with a carriage return followed by the same number of spaces awk indents all the other lines to
			printf -v sox1_outerr -- '

    %s*%s SoX 1 had this output:
      %s----------%s
%s
      %s----------%s' \
				   "$bold" "$default" "$bold" "$default" "$( printf -- '%s' "$outerr" |awk -- '{ print "      " $0 }' |sed -- 's/\r/\r      /g' )" "$bold" "$default"

		if [ -z "${target_bits_opt[$index]}" ] ;then
			# this is a tier 2 output - no dither is applied for 24b --> 24b
			status="9"
			printf -v sox1 --    'OK' ;printf -v sox1_colour -- '%s' "$green"
			printf -v dither1 -- 'N/A'
			printf -v sox2 --    'N/A'
			printf -v dither2 -- 'N/A'

		elif [[ $outerr != *"WARN dither: dither clipped"* ]] ;then
			# this is a tier 1 output and dither 1 didn't clip
			status="8"
			printf -v sox1 --    'OK' ;printf -v sox1_colour --    '%s' "$green"
			printf -v dither1 -- 'OK' ;printf -v dither1_colour -- '%s' "$green"
			printf -v sox2 --    'N/A'
			printf -v dither2 -- 'N/A'

		elif [[ $redo_clipped_dithers != "1" ]] ; then
			# dither 1 did clip, but redoing clipped dithers is disabled
			status="4"
			printf -v sox1 --    'OK'       ;printf -v sox1_colour --    '%s' "$green"
			printf -v dither1 -- 'CLIPPED'  ;printf -v dither1_colour -- '%s' "$orange"
			printf -v sox2 --    'DISABLED' ;printf -v sox2_colour --    '%s' "$orange"
			printf -v dither2 -- 'N/A'      #;printf -v dither2_colour -- '%s' ""
			printf -v clipping_message -- '

    %s*%s Dither clipped on the first SoX run, and trying again with an alternate dither command is currently disabled.' "$orange" "$default"

		else
			# this is a tier 1 output and dither 1 did clip
			if outerr="$( "$sox" -V${sox_verbosity_level} $sox_global_opts $sox_format_opts_infile "${absolute_flac_names[$index]}" $sox_format_opts_outfile ${target_bits_opt[$index]} "${target_flacs[$index]}" ${target_rate_cmd[$index]} ${sox_clipped_dither} 2>&1 )" ;then
				# sox 2 is successful

				# test/debug - force fake clipping to be detected on sox2
				# printf -v outerr -- 'fake sox2 output\nsox WARN dither: dither clipped a ton of samples!\n'

				[ -n "$outerr" ] && [ "$sox_emits" = "1" ] &&
					printf -v sox2_outerr -- '

    %s*%s SoX 2 had this output:
      %s----------%s
%s
      %s----------%s' "$bold" "$default" "$bold" "$default" "$( printf -- '%s' "$outerr" |awk -- '{ print "      " $0 }' |sed -- 's/\r/\r      /g' )" "$bold" "$default"

				if [[ $outerr != *"WARN dither: dither clipped"* ]] ;then
					# dither 2 didn't clip
					status="7"
					printf -v sox1 --    'OK'      ;printf -v sox1_colour --    '%s' "$green"
					printf -v dither1 -- 'CLIPPED' ;printf -v dither1_colour -- '%s' "$orange"
					printf -v sox2 --    'OK'      ;printf -v sox2_colour --    '%s' "$green"
					printf -v dither2 -- 'OK'      ;printf -v dither2_colour -- '%s' "$green"
					(( increase_verbosity == 1 )) &&
						printf -v dither2_success -- '

    %s*%s Dither clipped on the first SoX run, but did not clip on the second while using alternate dither command: "%s"' "$green" "$default" "$sox_clipped_dither"

				else
					# dither 2 clipped
					status="3"
					printf -v sox1 --    'OK'      ;printf -v sox1_colour --    '%s' "$green"
					printf -v dither1 -- 'CLIPPED' ;printf -v dither1_colour -- '%s' "$orange"
					printf -v sox2 --    'OK'      ;printf -v sox2_colour --    '%s' "$green"
					printf -v dither2 -- 'CLIPPED' ;printf -v dither2_colour -- '%s' "$orange"

					printf -v clipping_message -- '

    %s*%s Dither clipped on both runs, you can use a different dither command with the "-d / --dither" option, to try a different noise-shaping filter.
    %s*%s For more information on noise-shaping filters, see the manpage for sox, under EFFECTS --> Supported Effects --> dither.' \
						   "$orange" "$default" "$orange" "$default"
					# list dither commands used in sox1 and/if sox2 runs
					# emit sox2_outerr? or a message about sox_emits if (( ! sox_emits )) ?
				fi

			else
				# sox 2 failed
				status="2"
				printf -v sox1 --    'OK'      ;printf -v sox1_colour --    '%s' "$green"
				printf -v dither1 -- 'CLIPPED' ;printf -v dither1_colour -- '%s' "$orange"
				printf -v sox2 --    'FAILED'  ;printf -v sox2_colour --    '%s' "$red"
				printf -v dither2 -- 'N/A'
				printf -v metaflac_status -- 'N/A'

				printf -v sox2_outerr -- '

    %s*%s SoX 2 failed with the following output, aborting any follow-up tasks for this file.
    %s*%s It'\''s likely "sox_clipped_dither" is set with an invalid dither command.
      %s----------%s
%s
      %s----------%s' \
					   "$red" "$default" "$orange" "$default" \
					   "$red" "$default" \
					   "$( printf -- '%s' "$outerr" |awk -- '{ print "      " $0 }' |sed -- 's/\r/\r      /g' )" "$red" "$default"

			fi
		fi
	else
		# sox 1 failed
		status="1"
		printf -v sox1 --    'FAILED' ;printf -v sox1_colour -- '%s' "$red"
		printf -v dither1 -- 'N/A'
		printf -v sox2 --    'N/A'
		printf -v dither2 -- 'N/A'
		printf -v metaflac_status -- 'N/A'

		printf -v sox1_outerr -- '

    %s*%s SoX 1 failed with the following output, aborting any follow-up tasks for this file.
      %s----------%s
%s
      %s----------%s' \
			   "$red" "$default" "$red" "$default" \
			   "$( printf -- '%s' "$outerr" |awk -- '{ print "      " $0 }' |sed -- 's/\r/\r      /g' )" "$red" "$default"
		# until _fail_logger 'sox1' "${target_flacs[$index]}" ;do
		# 	sleep 2s
		# done
	fi


	## run metaflac
	if [ "$metaflac_enabled" = "1" ] ;then

		[[ "$status" == [98734] ]] && {

			[ "$embed_artwork" == "1" ] && {

				artwork="${target_flacs[$index]}.metaflac.img"
				# put "metaflac --export" into a proper if statement and set metaflac_artwork="_something_" when export fails/no artwork? ... use "2" to signify no embedded artwork in source?
				metaflac --export-picture-to="$artwork" -- "${absolute_flac_names[$index]}" >/dev/null 2>&1 && # export failure is the best(? good even?) test for artwork existence? so far...
					if outerr="$( metaflac --import-picture-from="$artwork" -- "${target_flacs[$index]}" 2>&1 )" ;then
						rm -- "$artwork"
					else
						metaflac_failure="embedded artwork"
					fi
			}

			[ "$flac_padding" != "0" ] && [ -z "$metaflac_failure" ] && {

				outerr="$( metaflac --add-padding="$flac_padding" -- "${target_flacs[$index]}" 2>&1 )" ||
					metaflac_failure="padding"

				# test/debug - force fake metaflac failure
				# outerr="$( metaflac --add-padding="$flac_padding" -- "${target_flacs[$index]}" 2>&1 )" && {
				# 	metaflac_failure="padding" ;printf -v outerr -- 'fake metaflac failure\nfoo bar baz\n'
				# }
			}

			[ "$use_SOX_COMMAND_tag" == "1" ] && [ -z "$metaflac_failure" ] && {

				if [ "$status" = "8" ] || [ "$status" = "9" ] ; then
					sox_command=( sox -V${sox_verbosity_level} $sox_global_opts $sox_format_opts_infile INPUT.flac $sox_format_opts_outfile ${target_bits_opt[$index]} OUTPUT.flac ${target_rate_cmd[$index]} ${target_dither_cmd[$index]} )
					outerr="$( metaflac --set-tag=SOX_COMMAND="${sox_command[*]}" -- "${target_flacs[$index]}" 2>&1 )" ||
						metaflac_failure="SOX_COMMAND tag"

				elif [ "$status" = "7" ] || [ "$status" = "3" ] ; then
					sox_command=( sox -V${sox_verbosity_level} $sox_global_opts $sox_format_opts_infile INPUT.flac $sox_format_opts_outfile ${target_bits_opt[$index]} OUTPUT.flac ${target_rate_cmd[$index]} ${sox_clipped_dither} )
					outerr="$( metaflac --set-tag=SOX_COMMAND="${sox_command[*]}" -- "${target_flacs[$index]}" 2>&1 )" ||
						metaflac_failure="SOX_COMMAND tag"
				fi
			}

			[ "$use_SOURCE_SPECS_tag" == "1" ] && [ -z "$metaflac_failure" ] && {

				outerr="$( metaflac --set-tag=SOURCE_SPECS="24 bit, ${flac_sample_rates[$index]} Hz" -- "${target_flacs[$index]}" 2>&1 )" ||
					metaflac_failure="SOURCE_SPECS tag"
			}

			[ "$use_SOURCE_FFP_tag" == "1" ] && [ -z "$metaflac_failure" ] && {

				outerr="$( metaflac --set-tag=SOURCE_FFP="$( metaflac --show-md5sum "${absolute_flac_names[$index]}" )" -- "${target_flacs[$index]}" 2>&1 )" ||
					metaflac_failure="SOURCE_FFP tag"
			}

			# set metaflac status variables and colours
			if [[ -z $metaflac_failure ]] ;then
				printf -v metaflac_status -- 'OK'
				printf -v metaflac_status_colour -- '%s' "$green"
				status="${status}0"

			else
				printf -v metaflac_status -- 'FAILED'
				printf -v metaflac_status_colour -- '%s' "$red"

				# assume for now that if metaflac fails, there will always be some output
				# [ -n "$metaflac_outerr" ] &&
				printf -v metaflac_error -- '

    %s*%s metaflac failed to add %s, and had the following output. Aborting any further metaflac tasks for this file.
      %s----------%s
%s
      %s----------%s' \
					   "${red}" "${default}" "$metaflac_failure" \
					   "${red}" "${default}" "$( printf '%s' "$outerr" |awk -- '{ print "      " $0 }' )" \
					   "${red}" "${default}"
				status="${status}1"
			fi
		}
	else # no metaflac-requiring script features are enabled
		printf -v metaflac_status -- '%s' "Disabled"
		status="${status}2"
	fi


	## print messages, or don't
	if [ "$verbose_output" = "1" ] ;then

		printf -v output1 -- '


  %s
    %sInput%s    %sOutput%s    %sSoX (1)%s | %sDither%s    %sSoX (2)%s | %sDither%s    %smetaflac%s' \
			   "${target_flacs[$index]}" \
			   "$bold" "$default" "$bold" "$default" "$bold" "$default" "$bold" "$default" "$bold" "$default" "$bold" "$default" "$bold" "$default"

		bits="${target_bits_opt[$index]#-b }"
		printf -v output2 -- '
    24/%-4s  %s/%-7s %s%6s%s | %s%-7s%s %s%9s%s | %s%-9s%s %s%s%s' \
			   "$(( ${flac_sample_rates[$index]} / 1000 ))" "${bits:-24}" "$(( ${target_sample_rates[$index]:-${flac_sample_rates[$index]}} / 1000 ))" \
			   "$sox1_colour" "$sox1" "$default" "$dither1_colour" "$dither1" "$default" \
			   "$sox2_colour" "$sox2" "$default" "$dither2_colour" "$dither2" "$default" \
			   "$metaflac_status_colour" "$metaflac_status" "$default"

		printf -v output3 -- '%s%s%s%s%s' \
			   "$sox1_outerr" "$sox2_outerr" "$dither2_success" "$metaflac_error" "$clipping_message"

		printf '%s%s%s' "$output1" "$output2" "$output3"

	elif [ "$verbose_output" = "2" ] ;then
		# Alternative per-file status-output arrangements can be placed here. A number of vars are set during operations based on the success or failure
		# of the the first sox run, the second sox run if the first's dither had clipped samples, and metaflac when enabled.
		printf '\n\n  secondary output style not implemented, you should set verbose_output to "1" (or "0")'

	else # (( ! verbose_output )) / only emit details about imperfect results

		case $status in
			1)
				# sox1 failure
				printf -v output1 -- '%s' "$sox1_outerr"
				;;
			2)
				# sox2 failure
				printf -v output1 -- '%s%s' "$sox1_outerr" "$sox2_outerr"
				;;
			91 | 81 | 71 )
				# sox success, no clipping, but metaflac failure
				printf -v output1 -- '%s' "$metaflac_error"
				;;
			30)
				# clipping on both sox runs, but metaflac OK
				printf -v output1 -- '%s' "$clipping_message"
				;;
			31)
				# clipping on both sox runs, and metaflac failed
				printf -v output1 -- '%s%s' "$clipping_message" "$metaflac_error"
				;;
			# else? something about disabled metaflac?
		esac

		[ -n "$output1" ] && {
			printf '\n\n\n  %s%s' "${target_flacs[$index]}" "$output1"
		}
	fi

	# exit codes ... hopefully !> half-irrelevant
	# STATUS  RETURN  DESCRIPTION
	# 70      0       sox2 succeeds without clipping, metaflac succeeds
	# 80      0       sox1 succeeds without clipping, metaflac succeeds
	# 90      0       sox1 succeeds, no dither, metaflac succeeds
	# 1       1       sox1 fails, metaflac aborted
	# 2       2       sox2 fails, metaflac aborted
	# 30      30      sox1 and sox2 succeed but with clipping, metaflac succeeds
	# 31      31      sox1 and sox2 succeed but with clipping, metaflac fails
	# 40      40      sox1 succeeds but with clipping, sox2 is disabled, metaflac succeeds
	# 41      41      sox1 succeeds but with clipping, sox2 is disabled, metaflac fails
	# 71      71      sox2 succeeds without clipping, metaflac fails
	# 81      81      sox1 succeeds without clipping, metaflac fails
	# 91      91      sox2 succeeds, no dither, metaflac fails
	# ?2      ?2      yada yada yada, metaflac disabled

	# set _execute return code, and tally non-specific failures for single-thread (and hopefully future bash-multiprocess)
	case $status in # rename $status -> $return_code and then just re-set it to "0" on success, or leave it as-is
		9[02] | 8[02] | 7[02] )
			return_code="0"
			;;
		1 | 2 | 91 | 81 | 71 | 30 | 31 | 40 | 41 | ?2 )
			imperfect_indexes+=( "$index" ) # still not valid under gnuparallel, but should help bring the single-thread non-verbose status back in working order
			return_code="$status"
			;;
		# ok to go overboard doling out the return codes here/earlier, stop thinking about this until later
		# as long as [ success = 0 && non-success != 0 ] then this is fine for now!
	esac

	# (for single-thread, and hopefully future bash-multiprocess) tally specific failures
	# ... ideally outside _execute
	[[ $status == [12] ]] && sox_failures+=( "$index" )
	[[ $status == [3789]1 ]] && metaflac_failures+=( "$index" )
	[[ $status == 3[012] ]] && sox2_clipped_dithers+=( "$index" )
	[[ $status == 4[012] ]] && sox1_clipped_sox2_disabled+=( "$index" )

	[[ $return_code = "0" ]] && {
		# AT YOUR OWN RISK, especially if you didn't get this from the 'main' branch,
		# do the extra stuff you want to do when everything went well, eg:
		# rm -- "${absolute_flac_names[$index]}"
		# mkspectrograms.sh -- "${target_flacs[$index]}"
		# run_program -on "${target_flacs[$index]}" > "${target_folders[$index]}"/program_log.txt 2>&1
		# what have you
		true # this "true" is only required when no other commands are added/uncommented here
	}

	return "$return_code"

} # end of _execute

# _fail_logger() {
# 	if ln -s -t /tmp downsampler-lockfile >/dev/null 2>&1 ;then

# 		# ctrl+c unlinks $lockfile (?) -- from a function called in another function, run probably with gnu parallel?
# 		trap 'unlink "${torrents}/${lockfile}"' INT   # have to test this trap, function run in the function run in parallel...

# 		printf '[%s] %s\n' "$1" "$2" >> "$log_file"
# 		unlink /tmp/downsampler-lockfile
# 		return 0
# 	else
# 		return 1
# 	fi
# }

# use the _execute function, with threads, or without, to output ${target_flacs[@]}
if [[ $threads_off == "1" ]] ;then
	printf -- 'Converting %s target(s) with SoX...' "${#target_flacs[@]}"
	#_message -N "Converting ${#target_flacs[@]} target(s) with SoX..."
	for index in "${!target_flacs[@]}" ;do
		_execute "$index"
		# case $? in
		# 	etc)
		# 		true # tally exit codes here?
		# 		;;
		# esac
	done

	if [[ -z ${imperfect_indexes[*]} ]] ;then # appease shellcheck/SC2199 by using [*] instead of [@]
		# looks a little weird with 2 prepended newlines when there's no error output in non-verbose mode
		printf -- '\n\n\n%sDone%s. Converted %s target(s) with no apparent failures.\n\n' "$green" "$default" "${#target_flacs[@]}"
		#_message "${green}Done${default}! "
		#_message -N "Converted ${#target_flacs[@]} target(s) with no apparent failures."

	elif [[ ${#imperfect_indexes[@]} -eq ${#target_flacs[@]} ]] ;then
		printf -- '\n\n\n%sDone%s. %sTotal Failure:%s Every target failed at least 1 of their tasks.\n\n' "${red}" "${default}" "${bold}" "${default}"
		#_message "${red}Done.${default} "
		#_error "TOTAL FAILURE: EVERY TARGET failed at least 1 of their tasks!"

	else
		printf -- '\n\n\n%sDone%s. %sPartial Failure%s: At least 1 task failed for %s (out of %s) target(s).\n\n' \
			   "${orange}" "${default}" "$red" "${default}" "${#imperfect_indexes[@]}" "${#target_flacs[@]}"
		#_message "${orange}Done.${default} "
		#_error "PARTIAL FAILURE: At least 1 task failed for ${#imperfect_indexes[@]} (out of ${#target_flacs[@]}) target(s)!"
	fi

	if [[ $verbose_output != "1" ]] && (( ${#imperfect_indexes[@]} )) ;then
		(( ${#sox_failures[@]} ))         && { _message -n "SoX failures:"         ;for index in "${sox_failures[@]}"         ;do printf '  %s\n' "${target_flacs[$index]}" ;printf '\n' ;done ; } # elements are indexes
	    (( ${#metaflac_failures[@]} ))    && { _message -n "metaflac failures:"    ;for index in "${metaflac_failures[@]}"    ;do printf '  %s\n' "${target_flacs[$index]}" ;printf '\n' ;done ; }
		(( ${#sox2_clipped_dithers[@]} )) && { _message -n "dither clipped twice:" ;for index in "${sox2_clipped_dithers[@]}" ;do printf '  %s\n' "${target_flacs[$index]}" ;printf '\n' ;done ; }
	fi

# elif ((use_bash_multiprocess)) ;then
# 	true

else
	printf -- 'Converting %s target(s) with SoX and env_parallel...' "${#target_flacs[@]}"
	#_message -N "Converting ${#target_flacs[@]} target(s) with SoX and env_parallel..."

	source "$env_parallel_bash"

	# obvious(?) line groups... (0: env_parallel) 1: functions   2: source data   3: target data   4: sox options   5: metaflac vars   6: script vars   7: colour vars
	"$env_parallel_command" \
		--env _execute --env _message --env _error \
		--env absolute_flac_names --env flac_sample_rates \
		--env target_flacs --env target_folders --env target_sample_rates --env bits \
		--env sox --env sox_verbosity_level --env sox_global_opts --env sox_format_opts_infile --env sox_format_opts_outfile --env target_bits_opt --env target_rate_cmd --env target_dither_cmd --env sox_clipped_dither \
		--env flac_padding --env use_SOX_COMMAND_tag --env use_SOURCE_SPECS_tag --env use_SOURCE_FFP_tag --env embed_artwork --env redo_clipped_dithers \
		--env metaflac_enabled --env sox_failures --env metaflac_failures --env imperfect_indexes --env verbose_output --env increase_verbosity --env sox_emits \
		--env red --env green --env bold --env orange --env default \
		${parallel_progress_bar[0]} ${paralleljobs[0]} --will-cite _execute ::: "${!target_flacs[@]}"

	parallel_exit_status="$?"
	if [[ $parallel_exit_status -gt "0" ]] ;then       # I *think* I've covered all the possibilities around parallel's exit status... overkill? or missing some key detail?

		if [[ $parallel_exit_status -eq "101" ]] ;then # if only we could get "success=X" exit-status functionality without using '--halt-on-error'! :/
			printf -- '\n\n\n%sDone%s. %sVery Large Failure%s: Over 100 targets failed at least one of their tasks!\n\n' "$red" "$default" "$red" "$default"
			#_message "${red}Done.${default} "
			#_error "HUGE FAILURE: Over 100 targets failed at least 1 of their tasks!"

		elif [[ $parallel_exit_status -eq "255" ]] ;then
			printf -- '\n\n\n%sDone%s. env_parallel reports "255" exit status, meaning "other error", which is, well, it'\''s NOT success!\n\n' "$orange" "$default" >&2
			#_message "${orange}Done.${default} "
			#_error "env_parallel reports '255' exit status, meaning 'other error', meaning... well, it's definitely NOT success!"

		elif [[ $parallel_exit_status -eq ${#target_flacs[@]} ]] ;then
			printf -- '\n\n\n%sDone%s. %sTotal Failure%s: Every target failed at least one of their tasks!\n\n' "${red}" "${default}" "${red}" "${default}" >&2
			#_message "${red}Done.${default} "
			#_error "TOTAL FAILURE: EVERY TARGET failed at least 1 of their tasks!" # if #targets > 100 ;then user gets a different error than this, even if every target failed :/

		else
			printf -- '\n\n\n%sDone%s. %s (out of %s) target(s) failed at least 1 of their tasks!\n\n' "$orange" "$default" "$parallel_exit_status" "${#target_flacs[@]}" >&2
			#_message "${orange}Done.${default} "
			#_error "$parallel_exit_status (out of ${#target_flacs[@]}) target(s) failed at least 1 of their tasks!"
		fi

	else
		printf -- '\n\n\n%sDone%s! Converted %s target(s) with no apparent failures.\n\n' "${green}" "${default}" "${#target_flacs[@]}"
	    #_message -N "${green}Done${default}! Converted ${#target_flacs[@]} target(s) with no apparent failures."
	fi
fi
