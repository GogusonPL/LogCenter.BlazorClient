FROM mcr.microsoft.com/dotnet/sdk:5.0-buster-slim AS build
WORKDIR /src
COPY LogCenter.BlazorClient.csproj .
RUN dotnet restore "LogCenter.BlazorClient.csproj"
COPY . .
RUN dotnet build "LogCenter.BlazorClient.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "LogCenter.BlazorClient.csproj" -c Release -o /app/publish

FROM nginx:alpine AS final
WORKDIR /usr/share/nginx/html
COPY --from=publish /app/publish/wwwroot .
COPY nginx.conf /etc/nginx/nginx.conf
EXPOSE 80