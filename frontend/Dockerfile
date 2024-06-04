# Use an official Node.js image as the base image
FROM node:16-alpine

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json (if available)
COPY package*.json ./

# Install dependencies
RUN npm install && npm cache clean --force

# Copy the rest of the application code
COPY . .

# Build the frontend
RUN npm run build

# Expose the port on which your app will run
EXPOSE 3000

# Command to run the application
CMD ["npm", "start"]
