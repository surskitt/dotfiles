for f in ~/.profile.d/*; do
    . "${f}"
done

unset LS_COLORS
