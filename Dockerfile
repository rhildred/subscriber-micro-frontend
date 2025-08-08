# Stage 1: Build the Vite application
FROM node:20-alpine AS build-stage

WORKDIR /app

# Copy package.json and package-lock.json to leverage Docker's layer caching
COPY package.json package-lock.json ./
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the Vite application for production
RUN npm run build

# Stage 2: Serve the built application with Nginx
FROM python:alpine AS production-stage

# Copy the built Vite application from the build-stage
COPY --from=build-stage /app/dist /app/dist

# Expose port 80 for Nginx
EXPOSE 8082

WORKDIR /app

COPY ./app.py app.py

RUN pip install pymysql mysql-connector-python fastapi uvicorn pydantic


# Start app
CMD ["python", "app.py"]