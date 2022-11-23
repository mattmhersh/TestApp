FROM mcr.microsoft.com/dotnet/aspnet:7.0-alpine AS base
WORKDIR /app
EXPOSE 80
RUN apk update krb5

FROM mcr.microsoft.com/dotnet/sdk:7.0-alpine AS build
WORKDIR /src
COPY ["/TestApp/TestApp.csproj", "TestApp/"]
RUN dotnet restore "TestApp/TestApp.csproj"
COPY . .
WORKDIR "/src/TestApp"
RUN dotnet build "TestApp.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "TestApp.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "TestApp.dll"]
