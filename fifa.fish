#!/usr/bin/env fish

set -l json (dirname (status -f))/fifa.json

for dep in awk date jq
    if not command -q $dep
        echo "fifa: missing required command: $dep" >&2
        return 1
    end
end

if not test -r $json
    echo "fifa: cannot read data file: $json" >&2
    return 1
end

set -l lines (command jq -r '.[] | [.match, .home, .away, .location, .from_ist, .to_ist, .round, .date, .weekday, .start_epoch] | @tsv' $json \
    | command awk -F '\t' -v now=(date +%s) '
    function rep(c, n,    s) { s = ""; while (n-- > 0) s = s c; return s }
    function pad(i, v) { return align[i] == "r" ? sprintf("%*s", w[i], v) : sprintf("%-*s", w[i], v) }
    function line(    i, s) {
        s = "|"
        for (i = 1; i <= nc; i++) s = s " " pad(i, cell[i]) " |"
        return s
    }
    function emit(s, t) { ln++; if (t && tgt == 0) tgt = ln; print s }
    BEGIN {
        hdr = "\033[7m"; cur = "\033[1;97;48;5;52m"; rst = "\033[0m"
        dur = 2 * 3600
        nc = split("#|Home|Away|Location|From (IST)|To (IST)|Round", H, "|")
        split("r|l|l|l|r|r|l", align, "|")
        for (i = 1; i <= nc; i++) { cell[i] = H[i]; if (length(H[i]) > w[i]) w[i] = length(H[i]) }
    }
    {
        n++
        for (i = 1; i <= nc; i++) { row[n, i] = $i; if (length($i) > w[i]) w[i] = length($i) }
        day[n] = $9 ", " $8
        se[n] = $10
    }
    END {
        hl = 0
        for (r = 1; r <= n; r++) if (se[r] + dur > now) { hl = r; break }
        border = "+"
        for (i = 1; i <= nc; i++) border = border rep("-", w[i] + 2) "+"
        L = length(border)
        emit(border)
        emit(hdr line() rst)
        prev = ""
        for (r = 1; r <= n; r++) {
            if (day[r] != prev) {
                emit(border)
                td = (hl && day[r] == day[hl])
                emit((td ? cur : hdr) "|" sprintf("%-*s", L - 2, " " day[r]) "|" rst, td)
                emit(border)
                prev = day[r]
            }
            for (i = 1; i <= nc; i++) cell[i] = row[r, i]
            if (r == hl) emit(cur line() rst, 1)
            else emit(line())
        }
        emit(border)
        print "TARGET " (tgt ? tgt : 1)
    }
')

set -l target (string replace 'TARGET ' '' -- $lines[-1])
set -e lines[-1]

if not isatty stdout
    printf '%s\n' $lines
    return
end

set -l start (math "$target - floor("(tput lines)" / 2)")
test $start -lt 1; and set start 1

printf '%s\n' $lines | less -R "+$start"g
