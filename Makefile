PRODUCT_NAME := ArchitecturePractice
PROJECT_NAME := ${PRODUCT_NAME}.xcodeproj


xcodegen:
	@mint run yonaskolb/XcodeGen xcodegen generate
bootstrap:
	mint bootstrap
setup:
	mint bootstrap
	make xcodegen
	open ./${PROJECT_NAME}
setup-b:
	mint bootstrap
	make xcodegen
	open ./${PROJECT_NAME}
open:
	open ./${PROJECT_NAME}
