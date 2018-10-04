FROM node:8

# Change working directory
WORKDIR "/app"

# Install npm production packages 
COPY package.json /app/
RUN cd /app; npm install --production

COPY . /app

ENV NODE_ENV production
ENV PORT 8080

EXPOSE 8080

CMD ["npm", "start"]
