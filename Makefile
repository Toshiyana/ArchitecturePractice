PRODUCT_NAME := ArchitecturePractice
PROJECT_NAME := ${PRODUCT_NAME}.xcodeproj
WORKSPACE_NAME := ${PRODUCT_NAME}.xcworkspace

xcodegen:
	@mint run yonaskolb/XcodeGen xcodegen generate

# Install all tool in Mintfile
bootstrap:
	mint bootstrap

# Setup project when not using CocoaPods
setup:
	mint bootstrap
	make xcodegen
	open ./${PROJECT_NAME}
open:
	open ./${PROJECT_NAME}

# Setup project when using CocoaPods
setup-pods:
	mint bootstrap
	make xcodegen
	pod install
	open ./${WORKSPACE_NAME}
setup-pods-bundle:
	mint bootstrap
	make xcodegen
	bundle exec pod install
	open ./${WORKSPACE_NAME}
open-workspace:
	open ./${WORKSPACE_NAME}
