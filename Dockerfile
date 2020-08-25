#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM swr.cn-south-1.myhuaweicloud.com/mcr/aspnet:3.1-alpine AS base
WORKDIR /app
EXPOSE 80

FROM swr.cn-south-1.myhuaweicloud.com/mcr/aspnet:3.1-alpine AS build
WORKDIR /src
COPY ["HelloWorldPrj/HelloWorldPrj.csproj", "HelloWorldPrj/"]
RUN dotnet restore "HelloWorldPrj/HelloWorldPrj.csproj"
COPY . .
WORKDIR "/src/HelloWorldPrj"
RUN dotnet build "HelloWorldPrj.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "HelloWorldPrj.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "HelloWorldPrj.dll"]
