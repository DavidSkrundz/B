#!/usr/bin/env bash

major=0
minor=0
patch=0


function checkVersion {
	git rev-parse "v$major.$minor.$patch^{tag}" >/dev/null 2>&1
	return $?
}

function nextVersion {
	let patch+=1
	if checkVersion
	then
		return $?
	else
		let patch=0
		let minor+=1
		if checkVersion
		then
			return $?
		else
			let patch=0
			let minor=0
			let major+=1
			checkVersion
			return $?
		fi
	fi
}

function checkout {
	echo "Building v$major.$minor.$patch"
	git checkout "v$major.$minor.$patch^{tag}" >/dev/null 2>&1
}

function build {
	make clean
	make install
	return $?
}


if  [[ $1 = "--update" ]]; then
	major=`bin/bc --version | sed -nEe 's/^.*Version ([0-9]+)\.([0-9]+)\.([0-9]+).*$/\1/p'`
	minor=`bin/bc --version | sed -nEe 's/^.*Version ([0-9]+)\.([0-9]+)\.([0-9]+).*$/\2/p'`
	patch=`bin/bc --version | sed -nEe 's/^.*Version ([0-9]+)\.([0-9]+)\.([0-9]+).*$/\3/p'`
fi

while nextVersion
do
	checkout
	if ! build
	then
		echo "Build failed"
		exit 1
	fi
done
