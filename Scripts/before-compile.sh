if [[ -f ./Mintfile ]] ; then
  mint run swiftlint swiftlint --fix --format
else
  echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
fi
