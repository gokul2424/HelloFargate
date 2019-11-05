#FROM microsoft/dotnet:2.1-aspnetcore-runtime AS base
#WORKDIR /app
#EXPOSE 57140
#EXPOSE 44316
#
#FROM microsoft/dotnet:2.1-sdk AS build
#WORKDIR /src
#COPY ["HelloFargate/HelloFargate.csproj", "HelloFargate/"]
#RUN dotnet restore "HelloFargate/HelloFargate.csproj"
#COPY . .
#WORKDIR "/src/HelloFargate"
#RUN dotnet build "HelloFargate.csproj" -c Release -o /app
#
#FROM build AS publish
#RUN dotnet publish "HelloFargate.csproj" -c Release -o /app
#
#FROM base AS final
#WORKDIR /app
#COPY --from=publish /app .
#ENTRYPOINT ["dotnet", "HelloFargate.dll"]


FROM microsoft/dotnet:2.1-aspnetcore-runtime AS base
WORKDIR /app
EXPOSE 80

FROM microsoft/dotnet:2.1-sdk AS build
WORKDIR /src
COPY *.csproj ./
RUN dotnet restore
COPY . .
WORKDIR /src
RUN dotnet build -c Release -o /app

FROM build AS publish
RUN dotnet publish -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "HelloFargate.dll"]
