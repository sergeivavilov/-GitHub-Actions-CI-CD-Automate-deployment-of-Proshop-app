FROM node:16

#Set Wokrdir and Copy Context
WORKDIR /app
COPY package*.json ./

#Install Package Dependency
RUN npm install --quiet && npm cache clean --force

#Copy Context To Docker Image
COPY . .

#Expose Image Port
EXPOSE 5000

#Start Backend Server
CMD ["npm", "run", "server"]
