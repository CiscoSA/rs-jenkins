# Build Stage
ARG NODE_VERSION=20.18.0
FROM node:${NODE_VERSION}-alpine AS build
WORKDIR /home/node/app

# Copy dependency files first to leverage Docker cache
COPY package*.json yarn.lock ./

# Install dependencies and set up permissions
RUN yarn install --frozen-lockfile \
    && yarn cache clean --all \
    && mkdir -p node_modules/.cache \
    && chmod -R 777 node_modules/.cache

# Copy the rest of the application code
COPY --chown=node:node . .


# Production Stage
FROM node:${NODE_VERSION}-alpine AS prod

# Set non-root user for security
USER node
WORKDIR /home/node/app

# Copy built application from build stage
COPY --from=build --chown=node:node /home/node/app .

# Set environment variables
ENV PORT=3000
ENV NODE_ENV=production
ENV NODE_OPTIONS=--max_old_space_size=4096

# Expose port
EXPOSE ${PORT}

# Build
RUN yarn run build

# Start application
CMD ["node", "server/index.js"]
