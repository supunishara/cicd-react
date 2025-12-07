#############################################
# STEP 1 — Build the React app
#############################################

# Use official Node image (lightweight)
FROM node:18-alpine AS build

# Set working directory inside container
WORKDIR /app

# Copy only package.json first (helps caching)
COPY package.json package-lock.json ./

# Install dependencies
RUN npm install

# Copy the rest of the project files
COPY . .

# Build production-optimized React app
RUN npm run build


#############################################
# STEP 2 — Serve the built app using nginx
#############################################

# Use official nginx image
FROM nginx:1.23-alpine

# Set directory where nginx serves files
WORKDIR /usr/share/nginx/html

# Remove default nginx files
RUN rm -rf ./*

# Copy React build output from previous stage
COPY --from=build /app/build .

# Expose port 80 so container can serve the application
EXPOSE 80

# Start nginx server (keep it running)
ENTRYPOINT ["nginx", "-g", "daemon off;"]
