#!/usr/bin/env make
# DESCRIPTION
#	Project utility to install client/server, deploy, etc.
#
# USAGE
#	make install
#
# AUTHOR
#	Édouard Lopez <dev+librarybox@edouard-lopez.com>

ifneq (,)
This makefile requires GNU Make.
endif

# force use of Bash
SHELL := /bin/bash
DATADIR="$$(pwd)"/app/data
TMPDIR="$$(pwd)"/.tmp
EXTRACT_BOOK=${TMPDIR}/books
SCRIPTS=scripts-metadata

.PHONY:	export2json export2rawjson export2csv \
		clean


extract-books-authors:
	sqlite3 -csv -header app/data/data.sqlite3 "SELECT b.id as bid, title, b.sort as sort_book, a.id as aid, a.sort as sort_author, path, name FROM books as b inner join books_authors_link as b_a ON b.id = b_a.book INNER JOIN authors as a ON a.id = b_a.author" | ./node_modules/csvtojson/bin/csvtojson

install:
	printf "install\n"
	npm install && bower install

install-devtools:
	printf "install-devtools\n"
	apt-get install sqlite3 sqlitebrowser nodejs jq
	npm install -g yo bower gulp generator-gulp-angular generator-angular

export2json: ${TMPDIR}/books.json
${TMPDIR}/books.json: .tmp ${TMPDIR}/books.raw.json
	printf "export2json\n"
	cat ${TMPDIR}/books.raw.json \
		| jq "$$(cat ${SCRIPTS}/books/squash-books-data.jq)" \
	> ${TMPDIR}/books.json
	cp {${TMPDIR},${DATADIR}}/books.json

export2rawjson: ${TMPDIR}/books.raw.json
${TMPDIR}/books.raw.json: .tmp ${TMPDIR}/books.csv
	printf "export2rawjson\n"
	cat ${TMPDIR}/books.csv \
		| ./node_modules/csvtojson/bin/csvtojson \
	> ${TMPDIR}/books.raw.json

export2csv: ${TMPDIR}/books.csv
${TMPDIR}/books.csv: .tmp
	printf "export2csv\n"
	sqlite3 -csv -header \
    	${DATADIR}/data.sqlite3 \
    	"$$(cat ${SCRIPTS}/books/list-books.sql)" \
	> ${TMPDIR}/books.csv

.tmp:
	[[ ! -d ${TMPDIR} ]] && mkdir -p ${TMPDIR} || true

clean:
	printf "clean\n"
	rm -f -r ${TMPDIR} ${TMPDIR}/books.{csv,{raw.,}json}