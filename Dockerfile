# base
FROM microsoft/dotnet:latest
#FROM microsoft/dotnet:1.0.1-core # This is good for deployed apps as it will be minimal 

# set up package cache
RUN curl -o /tmp/packagescache.tar.gz https://dist.asp.net/packagecache/aspnetcore.packagecache-1.0.1-debian.8-x64.tar.gz && \
    mkdir /packagescache && cd /packagescache && \
    tar xvf /tmp/packagescache.tar.gz && \
    rm /tmp/packagescache.tar.gz && \
    cd /

# set env var for packages cache
ENV DOTNET_HOSTING_OPTIMIZATION_CACHE /packagescache

# set up network (doesn't work on heroku) 
EXPOSE 5000/tcp

ENV ASPNETCORE_URLS http://*:5000
#ENV ASPNETCORE_URLS http://+:80

# copy my app from current directory to target on container 
COPY . /app 
WORKDIR /app
 
# Build and run the app, with watcher, when the container spins up
RUN ["dotnet", "restore"]
RUN ["dotnet", "build"]
ENTRYPOINT ["dotnet", "watch", "run"]

#required for heroku
#CMD infinite-plateau-20150 --bind 0.0.0.0:$PORT wsgi 
#CMD dotnet aspnetcore-dev.dll --server.urls=0.0.0.0:$PORT 


######################################################################## 
# USAGE - build image, and expose ports, the current app folder: 
# 		docker build -t mydemos:aspnetcorehelloworld .
#		docker run -i -p 8080:5000 -v $(pwd):/app -t mydemos:aspnetcorehelloworld 

# REFERENCE: https://github.com/aspnet/aspnet-docker/blob/master/1.0.1/jessie/product/Dockerfile