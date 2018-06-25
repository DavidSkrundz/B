#!/usr/bin/env bash

major=0
minor=0
patch=0
keep=0

function usage {
	echo "Usage: ./bootstrap.sh [argument, ...]"
	echo "  -h, --help               Show help"
	echo "  --update                 Update existing B compiler"
	echo "  --keep-old               Preserve each build (eg. bc-0.0.1)"
}

function update {
	if [ ! -e "bin/bc" ]
	then
		echo "No B compiler to update"
		exit 1
	fi
	let major=`bin/bc --version | sed -nEe 's/^.*Version ([0-9]+)\.([0-9]+)\.([0-9]+).*$/\1/p'`
	let minor=`bin/bc --version | sed -nEe 's/^.*Version ([0-9]+)\.([0-9]+)\.([0-9]+).*$/\2/p'`
	let patch=`bin/bc --version | sed -nEe 's/^.*Version ([0-9]+)\.([0-9]+)\.([0-9]+).*$/\3/p'`
}

while [ "$1" != "" ]; do
	PARAM=`echo $1 | awk -F= '{print $1}'`
	VALUE=`echo $1 | awk -F= '{print $2}'`
	case $PARAM in
		-h | --help)
			usage
			exit 0
			;;
		--update)
			update
			;;
		--keep-old)
			let keep=1
			;;
		*)
			echo "ERROR: unknown parameter \"$PARAM\""
			usage
			exit 1
			;;
	esac
	shift
done



function versionExists {
	git rev-parse "v$major.$minor.$patch^{tag}" >/dev/null 2>&1
	return $?
}

function nextVersion {
	let patch+=1
	if versionExists
	then
		return $?
	else
		let patch=0
		let minor+=1
		if versionExists
		then
			return $?
		else
			let patch=0
			let minor=0
			let major+=1
			versionExists
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



while nextVersion
do
	checkout
	if ! build
	then
		echo "Build failed"
		exit 1
	fi
	if [ "$keep" = "1" ]
	then
		cp "bin/bc" "bin/bc-$major.$minor.$patch"
	fi
done

git checkout master
