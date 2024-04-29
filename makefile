GREEN=\033[1;32m
NC=\033[0m # No Color

ANDROID_DIR=android
GOOGLE_SERVICE_JSON=google-services.json
GOOGLE_SERVICE_ANDROID=$(ANDROID_DIR)/app/

IOS_DIR=ios
GOOGLE_SERVICE_INFO=GoogleService-Info.plist
GOOGLE_SERVICE_IOS=$(IOS_DIR)/Runner/
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

.PHONY: set-env-dev, set-env-prod, set-env-staging

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