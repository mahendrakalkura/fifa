# fifa

FIFA World Cup 2026 schedule viewer (IST), grouped by day, next game highlighted.

## Usage

```fish
fish /path/to/fifa.fish
```

Requires `jq` and `awk`.

## Output

ASCII table with day groupings. The next upcoming match is highlighted. Today's day header uses a distinct color. When run in a terminal, the view is centered on today's games.

## Files

+------------+----------------------------------+
| File       | Purpose                          |
+------------+----------------------------------+
| fifa.fish  | Standalone fish script            |
| fifa.json  | Match data (JSON)                 |
+------------+----------------------------------+
