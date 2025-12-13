
# syntax=docker/dockerfile:1

# -------------------------
# Build stage
# -------------------------
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src

# Copy csproj first for better layer caching
COPY BestBikeApp.csproj ./
RUN dotnet restore "./BestBikeApp.csproj"

# Copy everything else and build
COPY . ./
RUN dotnet build "./BestBikeApp.csproj" -c Release -o /app/build

# (Optional but recommended) Run tests if you have test projects in solution
# If you don't have tests, you can remove this line.
RUN dotnet test -c Release --no-build --verbosity normal

# Publish output
RUN dotnet publish "./BestBikeApp.csproj" -c Release -o /app/publish /p:UseAppHost=false


# -------------------------
# Runtime stage
# -------------------------
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS runtime
WORKDIR /app

# ASP.NET Core in containers commonly listens on 8080 (we map host->container later)
ENV ASPNETCORE_URLS=http://+:8080
EXPOSE 8080

COPY --from=build /app/publish ./

# Project name from your solution is BestBikeApp, so output dll is typically BestBikeApp.dll
ENTRYPOINT ["dotnet", "BestBikeApp.dll"]