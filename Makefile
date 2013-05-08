R	:= R --no-save --no-restore
RSCRIPT	:= Rscript
DELETE	:= rm -fR

.SILENT:
.PHONEY: clean roxygenize package windows install test check

usage:
	echo "Available targets:"
	echo ""
	echo " clean         - Clean everything up"
	echo " roxygenize    - roxygenize into pkg/"
	echo " package       - build source package"
	echo " install       - install the package"
	echo " test          - run unit tests"
	echo " html          - build static html documentation"
	echo " check         - run R CMD check on the package"

clean:
	echo "Cleaning up ..."
	${DELETE} src/*.o src/*.so pkg.Rcheck
	${DELETE} pkg
	${DELETE} .RData .Rhistory

roxygenize: clean
	echo "Roxygenizing package ..."
	${RSCRIPT} ./tools/roxygenize
	echo "Setting version ..."
	${RSCRIPT} ./tools/set-version
	find pkg -depth -type d -name .svn -exec rm -rf {} \;

package: roxygenize
	echo "Building package file ..."
	${R} CMD build pkg/
 
install: roxygenize
	echo "Installing package ..."
	${R} CMD INSTALL pkg

test: install
	echo "Testing package ..."
	${RSCRIPT} ./test_all.R

html: install
	echo "Generating html docs..."
	${DELETE} html-docs
	mkdir html-docs
	${RSCRIPT} ./tools/generate-html-docs

check: roxygenize
	echo "Running R CMD check ..."
	${R} CMD check pkg

  
