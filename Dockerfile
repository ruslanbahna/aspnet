# Use the .NET SDK image to build the application
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["HelloWorldApi/HelloWorldApi.csproj", "./"]
RUN dotnet restore "HelloWorldApi.csproj"
COPY ["HelloWorldApi/.", "."]
RUN dotnet build "HelloWorldApi.csproj" -c Release -o /app/build

# Publish the application
FROM build AS publish
RUN dotnet publish "HelloWorldApi.csproj" -c Release -o /app/publish

# Use the .NET runtime image to run the application
FROM mcr.microsoft.com/dotnet/aspnet:8.0-jammy-chiseled AS final
EXPOSE 8080
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "HelloWorldApi.dll"]
