install:
	bin/composer install

start:
	php -S localhost:8080

test:
	# cd tst && ../vendor/bin/phpunit
	./vendor/bin/phpunit tst

lint:
	# 1. PHP Lint
	find . -type f -name '*.php' -not -path "./vendor/*" -not -path "./data/*" -not -path "./cfg/*" -exec php -l {} \;

	# 2. PHP Code Sniffer (On exclut toute la règle de déclaration des méthodes)
	php vendor/bin/phpcs --standard=PSR12 --extensions=php --exclude=PSR2.Methods.MethodDeclaration,PSR1.Methods.CamelCapsMethodName -n ./lib/

	# 3. PHP Mess Detector
	php vendor/bin/phpmd ./lib ansi codesize,unusedcode,naming
