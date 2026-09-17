# NLUX Data Pipeline - Local Installation Summary

## Project Structure

### Backend API (`/nlux/backend`)
- FastAPI server running on port 8000
- Manages the data cache, exports, and API interactions
- Database: `/nlux-project/data-pipeline/nlux.db`

### Data Pipeline (`/data-pipeline`)
- Orchestrates data processing through multiple phases:
  1. **Reconciliation**: Reconcile records from external sources
  2. **Merge**: Merge records representing the same entity
  3. **Export**: Export processed data to various formats

## Installation Status

### Backend API
- ✅ uvicorn server configured
- ✅ Database initialized (nlux.db, nlux.db-shm, nlux.db-wal)
- ✅ App entry point exported (fixed empty __init__.py)
- ⚠️ Running with errors (routes returning 404 - need to check main.py)

### Data Pipeline
- ✅ Python dependencies installed in .venv
- ✅ Pipeline configuration in pipeline/config.py
- ⚠️ No unified entry point - scripts must be run individually

## Running the Backend API

```bash
cd /home/joost/Development/nlux-project/nlux/backend
./start.sh
# or
nohup uvicorn app.main:app --host 0.0.0.0 --port 8000 > backend.log 2>&1 &
```

Test with:
```bash
curl http://localhost:8000/api/stats
```

## Running the Data Pipeline

The pipeline runs in phases using `/run-all.sh` or individual scripts:

### Phase 1: Reconciliation
```bash
python run-reconcile.py <start> <end>
# Example: python run-reconcile.py 0 24
```

### Phase 2: Merge
```bash
python run-merge.py <start> <end>
# Example: python run-merge.py 0 24
```

### Phase 3: Export
```bash
python run-export.py <start> <end>
# Example: python run-export.py 0 24
```

### Full Pipeline
```bash
./run-all.sh --[source]
# where [source] is the source to reconcile (e.g., 'aat')
```

## Project Components

### Pipeline Modules
- **config.py**: Configuration management with dynamic object instantiation
- **process/**: Processing components (Collector, Reconciler, Merger, etc.)
- **sources/**: External source handlers (Fetcher, Harvester, Mapper, etc.)
- **storage/**: Data storage implementations (Postgres, Redis, MarkLogic, filesystem)

### External Sources
Currently supported sources:
- ✅ AAT (Authority Control for Cultural Works)
- ✅ DNB (Deutsche Nationalbibliothek)
- ✅ Wikidata
- ✅ LCNAF, LCSH, ULAN (Library of Congress)
- ✅ VIAF, Who's on First
- ⏳ Japan NL, BNF, GBIF, ORCID, ROR
- ❌ FAST, Homosaurus, Nomisma, SNAC (not implemented)

## Quick Start

1. **Start the backend API**:
   ```bash
   cd /home/joost/Development/nlux-project/nlux/backend
   ./start.sh
   ```

2. **Run the data pipeline**:
   ```bash
   cd /home/joost/Development/nlux-project/data-pipeline
   ./run-all.sh --aat
   ```

3. **Check backend status**:
   ```bash
   curl http://localhost:8000/api/stats
   ```

## Notes
- The .venv.bak directory in backend contains the uvicorn setup
- Run parallel versions for faster processing (.sh scripts with *_parallel)
- See `run-all.sh` for complete orchestration with progress tracking
