# fifa

FIFA World Cup 2026 schedule viewer (IST), grouped by day, next game highlighted.

## Usage

```fish
fish ./fifa.fish
```

Requires `jq`, `awk`, and `date`. The interactive (terminal) view also needs `tput` and `less`.

## Output

ASCII table with day groupings. The next upcoming match is highlighted, and its day header uses a distinct color. When run in a terminal, the view is centered on the next match's day.

## Files

| File | Purpose |
| --- | --- |
| fifa.fish | Standalone fish script |
| fifa.json | Match data (JSON) |
