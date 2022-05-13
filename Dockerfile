FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env
WORKDIR /src

# Copy csproj and restore as distinct layers
COPY src/PlatformService/PlatformService.csproj src/
COPY src/PlatformTests/PlatformTests.csproj src/
RUN dotnet restore src/PlatformService.csproj
RUN dotnet restore src/PlatformTests.csproj

# Copy everything else and build
COPY . ./
RUN dotnet publish src/PlatformService.csproj -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/sdk:6.0
WORKDIR /src
COPY --from=build-env /app/out .
ENTRYPOINT ["dotnet", "PlatformService.dll"]