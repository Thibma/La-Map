FROM node:16

WORKDIR /usr/src/app

COPY package.json ./
COPY tsconfig.json ./

#COPY src ./src
RUN ls -a
RUN npm install

COPY . .

EXPOSE 3000

CMD ["npm", "run", "dev"]