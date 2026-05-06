GREEN=\033[1;32m
NC=\033[0m # No Color

ANDROID_DIR=android
GOOGLE_SERVICE_JSON=google-services.json
GOOGLE_SERVICE_ANDROID=$(ANDROID_DIR)/app/

IOS_DIR=ios
GOOGLE_SERVICE_INFO=GoogleService-Info.plist
GOOGLE_SERVICE_IOS=$(IOS_DIR)/Runner/
TAG=Todos
FILE=swagger.json
DEFAULT_DOMAIN=example.com

-include .env_vars

# Project Setup
project-setup:
	@make flutter-clean
	@cp -r hooks/prepare-commit-msg .git/hooks/
	@cp -r hooks/commit-msg .git/hooks/
	@cp -r hooks/pre-commit .git/hooks/
	@chmod +x .git/hooks/prepare-commit-msg
	@chmod +x .git/hooks/commit-msg
	@chmod +x .git/hooks/pre-commit   
	@echo "$(GREEN)Pre commit hook setup successfully$(NC)"

set-env-dev:
	@cp -r env/dev/config.dart lib/
	@cp -r env/dev/$(GOOGLE_SERVICE_JSON) $(GOOGLE_SERVICE_ANDROID)
	@cp -r env/dev/$(GOOGLE_SERVICE_INFO) $(GOOGLE_SERVICE_IOS)

	@cd android && ./gradlew clean && cd .. && yarn cache clean

	@echo "$(GREEN)Successfully copied project dev environment config$(NC)"

set-env-prod:
	@cp -r env/prod/config.dart lib/
	@cp -r env/prod/$(GOOGLE_SERVICE_JSON) $(GOOGLE_SERVICE_ANDROID)
	@cp -r env/prod/$(GOOGLE_SERVICE_INFO) $(GOOGLE_SERVICE_IOS)

	@cd android && ./gradlew clean && cd .. && yarn cache clean

	@echo "$(GREEN)Successfully copied project prod environment config$(NC)"

set-env-staging:
	@cp -r env/staging/config.dart lib/
	@cp -r env/staging/$(GOOGLE_SERVICE_JSON) $(GOOGLE_SERVICE_ANDROID)
	@cp -r env/staging/$(GOOGLE_SERVICE_INFO) $(GOOGLE_SERVICE_IOS)

	@cd android && ./gradlew clean && cd .. && yarn cache clean

	@echo "$(GREEN)Successfully copied project staging environment config$(NC)"

# Environment Setup

flutter-clean:
	@echo "$(GREEN) Cleaning Flutter project...$(NC)"
	@flutter clean
	@echo "$(GREEN) Fetching dependencies...$(NC)"
	@flutter pub get

flutter-fix:
	@echo "$(GREEN) Running Flutter format...$(NC)"
	@dart format .
	@echo "$(GREEN) Running Flutter fix...$(NC)"
	@dart fix --apply
generate:
	@echo "$(GREEN) Generating code...$(NC)"
	@dart run build_runner build --delete-conflicting-outputs

watch:
	@echo "$(GREEN) Watching for changes...$(NC)"
	@dart run build_runner watch --delete-conflicting-outputs

swagger-gen:
	@echo "$(GREEN) Generating features from Swagger...$(NC)"
	@dart generator/swagger_parser.dart $(TAG) $(FILE)


generate_dynamic_links: dynamic_link_setup
	@$(MAKE) app_links_android universal_links_ios host_files

dynamic_link_setup:
	@echo "--- Project Configuration ---"
	@printf "Enter Android Package Name (e.g., com.myapp): "; read pkg; echo "PACKAGE_NAME=$$pkg" > .env_vars
	@printf "Enter iOS Bundle ID (e.g., com.myapp.ios): "; read bundle; echo "BUNDLE_ID=$$bundle" >> .env_vars
	@printf "Enter Domain Name (e.g., myapp.com): "; read dom; echo "DOMAIN=$$dom" >> .env_vars
	@printf "Enter Apple Team ID (from developer portal): "; read team; echo "TEAM_ID=$$team" >> .env_vars
	@printf "Enter App Name: "; read name; echo "APP_NAME=$$name" >> .env_vars
	@echo "Configuration saved to .env_vars"

## 2. Android: Update Manifest
app_links_android:
	@echo "Configuring Android for $(DOMAIN)..."
	@echo '        <intent-filter android:autoVerify="true">' > .tmp_intent
	@echo '            <action android:name="android.intent.action.VIEW" />' >> .tmp_intent
	@echo '            <category android:name="android.intent.category.DEFAULT" />' >> .tmp_intent
	@echo '            <category android:name="android.intent.category.BROWSABLE" />' >> .tmp_intent
	@echo '            <data android:scheme="https" android:host="$(DOMAIN)" />' >> .tmp_intent
	@echo '        </intent-filter>' >> .tmp_intent
	@sed -i '' '/<activity/r .tmp_intent' android/app/src/main/AndroidManifest.xml
	@rm .tmp_intent

## 3. iOS: Update Entitlements
universal_links_ios:
	@echo "Configuring iOS for $(DOMAIN)..."
	@mkdir -p ios/Runner
	@echo '<?xml version="1.0" encoding="UTF-8"?>' > ios/Runner/Runner.entitlements
	@echo '<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">' >> ios/Runner/Runner.entitlements
	@echo '<plist version="1.0">' >> ios/Runner/Runner.entitlements
	@echo '<dict>' >> ios/Runner/Runner.entitlements
	@echo '	<key>aps-environment</key>' >> ios/Runner/Runner.entitlements
	@echo '	<string>development</string>' >> ios/Runner/Runner.entitlements
	@echo '	<key>com.apple.developer.associated-domains</key>' >> ios/Runner/Runner.entitlements
	@echo '	<array>' >> ios/Runner/Runner.entitlements
	@echo '		<string>applinks:$(DOMAIN)</string>' >> ios/Runner/Runner.entitlements
	@echo '	</array>' >> ios/Runner/Runner.entitlements
	@echo '</dict>' >> ios/Runner/Runner.entitlements
	@echo '</plist>' >> ios/Runner/Runner.entitlements

## 4. Host Files: Generate JSONs
host_files:
	@mkdir -p server-configs/.well-known
	
	# iOS AASA
	@echo '{"applinks":{"apps":[],"details":[{"appID":"$(TEAM_ID).$(BUNDLE_ID)","paths":["*"]}]}}' > server-configs/.well-known/apple-app-site-association
	
	# Android Assetlinks
	@printf "Enter your Android SHA256 Fingerprint: "; \
	read fingerprint; \
	echo '[{"relation":["delegate_permission/common.handle_all_urls"],"target":{"namespace":"android_app","package_name":"$(PACKAGE_NAME)","sha256_cert_fingerprints":["'$$fingerprint'"]}}]' > server-configs/.well-known/assetlinks.json
	
	@echo "Verification files generated in /server-configs"

# Usage example: make swagger-gen TAG=Events FILE=swagger.json

.PHONY: project-setup, set-env-dev, set-env-prod, set-env-staging, flutter-clean, flutter-fix, generate, watch, swagger-gen, generate_dynamic_links
