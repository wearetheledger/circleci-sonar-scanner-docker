build:
	docker build -t wearetheledger/circleci-sonar-scanner .

login:
	docker login -u wearetheledger

push-latest:
	docker push wearetheledger/circleci-sonar-scanner:latest
