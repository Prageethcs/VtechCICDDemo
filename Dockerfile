FROM microsoft/dotnet:2.1-aspnetcore-runtime AS base
WORKDIR /app
EXPOSE 51382

FROM microsoft/dotnet:2.1-sdk AS build
WORKDIR /src
COPY demoapi/demoapi.csproj demoapi/
RUN dotnet restore demoapi/demoapi.csproj
COPY . .
WORKDIR /src/demoapi
RUN dotnet build demoapi.csproj -c Release -o /app

FROM build AS publish
RUN dotnet publish demoapi.csproj -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "demoapi.dll"]