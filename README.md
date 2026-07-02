# Golazo ⚽️

World Cup knockout companion — bracket standings, predicted lineups, and
multi-model win predictions. SwiftUI, iOS 26.

## Status — iteration 1 (UI, mocked data)
All screens work against hand-mocked data (`Sources/MockData.swift`); there is no
data pipeline or real prediction model yet. The views read only the model types in
`Sources/Models.swift`, so iteration 2 can swap the mock for a real data/prediction
layer without touching the UI.

- **Bracket** (`ContentView`) — Quarterfinals → Semifinals → Final on one scrolling
  screen. Played rounds show scores; upcoming rounds show a two-flag win-% bar.
- **Team profile** (`TeamProfileView`) — predicted XI on a 4-3-3 pitch + bench.
- **Prediction** (`PredictionDetailView`) — aggregated forecast plus a per-model
  breakdown (Elo, xG/Poisson, market odds, form, neural net) with a Swift Charts view.

Flags render from bundled image assets when present, otherwise fall back to emoji.

## Roadmap
- **Iteration 2:** real fixtures/results feed, actual prediction models, computed win %.

## Build & run
```bash
./run.sh                 # build, launch on Simulator, write Golazo-screenshot.png
./run.sh "iPhone Air"    # or any installed simulator
```
Requires Xcode 26 + XcodeGen (`brew install xcodegen`). `run.sh` regenerates the
project from `project.yml` before building.
