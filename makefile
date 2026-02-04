install:
	bin/composer install

start:
	php -S localhost:8080

test:
	# cd tst && ../vendor/bin/phpunit
	./vendor/bin/phpunit tst
lint:
	$ find . -type f -name '*.php' -exec php -l {} \;
	./vendor/bin/phpcs --extensions=php ./lib/
	./vendor/bin/phpmd ./lib ansi codesize,unusedcode,naming
