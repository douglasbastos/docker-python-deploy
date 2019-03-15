build:
	docker build -f Dockerfile -t douglasbastos/python-deploy . 

push:
	docker push douglasbastos/python-deploy
