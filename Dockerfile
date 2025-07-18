# Phase 1: build app
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

COPY *.sln .
COPY VideoConverterApi/*.csproj ./VideoConverterApi/
RUN dotnet restore

COPY VideoConverterApi/. ./VideoConverterApi/
WORKDIR /src/VideoConverterApi
RUN dotnet publish -c Release -o /app/publish

# Phase 2: runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app

# ✅ CÀI FFMPEG TRONG CONTAINER
RUN apt-get update && apt-get install -y ffmpeg

COPY --from=build /app/publish .

ENV ASPNETCORE_URLS=http://+:8080
EXPOSE 8080

ENTRYPOINT ["dotnet", "VideoConverterApi.dll"]
