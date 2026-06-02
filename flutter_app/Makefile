#build image docker from Dockerfile flutter
build:
	@docker build . -t flutter_image

# run a container from flutter_image
run:
	@docker run -i --name flutter_box -p 8080:80 -td flutter_image