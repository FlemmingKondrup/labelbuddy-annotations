labelbuddy_databases := $(shell find . -type f -name '*.labelbuddy')
annotation_files := $(patsubst %.labelbuddy, %.jsonl, $(labelbuddy_databases))

.PHONY: all annotations database csv book book-full

all: annotations

annotations: $(annotation_files)

database:
	python3 ./scripts/make_database.py

csv: analysis/data/detailed_annotation.csv

analysis/data/detailed_annotation.csv: analysis/data/database.sqlite3
	sqlite3 -header -csv $< "select * from detailed_annotation;" > $@

$(annotation_files): %.jsonl: %.labelbuddy
	labelbuddy $< --export-docs $@ --no-text --labelled-only

book:
	python3 scripts/make_repo_stats_figure.py
	python3 analysis/book_helpers/add_project_pages.py
	LABELREPO_CSS_AVAILABLE=1 \
	LABELREPO_REPOSITORY_URL="https://github.com/neurodatascience/labelbuddy-annotations/" \
	jupyter-book build -W analysis/book

book-full: database csv
	rm -rf analysis/book/_build/
	rm -rf analysis/book/projects/
	python3 analysis/book_helpers/add_project_pages.py
	python3 scripts/make_repo_stats_figure.py
	LABELREPO_CSS_AVAILABLE=1 \
	LABELREPO_REPOSITORY_URL="https://github.com/neurodatascience/labelbuddy-annotations/" \
	jupyter-book build -W analysis/book
