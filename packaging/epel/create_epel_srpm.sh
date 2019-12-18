#!/bin/bash

cleanup() {
  rm -f convert2rhel.spec
  rm -rf dist/
  popd
}

BASEDIR=$(dirname "$0")
pushd ${BASEDIR}/../..

rm -rf dist/ SRPMS/
python2 setup.py sdist

cp ${BASEDIR}/convert2rhel.spec convert2rhel.spec
rpmlint convert2rhel.spec

TIMESTAMP=`date +%Y%m%d%H%MZ -u`
GIT_BRANCH=`git rev-parse --abbrev-ref HEAD`
sed -i "s/1%{?dist}/0.${TIMESTAMP}.${GIT_BRANCH}/g" convert2rhel.spec

rpmbuild -bs convert2rhel.spec --define "debug_package %{nil}" \
    --define "_sourcedir `pwd`/dist" \
    --define "_srcrpmdir `pwd`/SRPMS" || { cleanup; exit 1; }

rpmlint SRPMS/convert2rhel*.rpm

cleanup
