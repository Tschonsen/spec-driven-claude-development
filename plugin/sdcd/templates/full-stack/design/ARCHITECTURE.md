# {{project_name}} — Architecture

_Last updated: {{today}}_

## Repo layout

<Monorepo / split repos. If monorepo, list the top-level directories. If split, list the repos and how they discover each other.>

## Backend layer layout

<Request lifecycle: router → controller → service → repository → DB, or your equivalent.>

## Frontend layer layout

<App shell → routes → feature components → primitives. State model layers: server cache / URL / local / global.>

## External dependencies

- **Storage:** <host / managed / local>
- **Auth provider:** <fill>
- **Observability:** <fill>

## Decisions log

- (Append architectural decisions here. Monorepo-vs-split is a day-one entry.)
