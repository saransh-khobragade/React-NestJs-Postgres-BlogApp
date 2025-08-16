# Blog Application - React + NestJS + PostgreSQL

A modern full-stack blog application built with React (frontend), NestJS (backend), and PostgreSQL database. Features user authentication, blog creation/management, and a responsive UI with dark/light theme support.

## 📋 Prerequisites

- **Docker** and **Docker Compose** installed
- **Node.js** 18+ (for local development)
- **Yarn** package manager

## 🚀 Quick Start

### Option 1: Docker (Recommended)

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd React-NestJs-Postgres-BlogApp
   ```

2. **Start all services**
   ```bash
   ./scripts/build.sh all
   ```

3. **Access the application**
   - Frontend: http://localhost:3000
   - Backend API: http://localhost:8080
   - API Documentation: http://localhost:8080/api
   - pgAdmin: http://localhost:5050 (admin@admin.com / admin)

### Option 2: Local Development

1. **Start the database**
   ```bash
   docker compose up postgres pgadmin -d
   ```

2. **Backend setup**
   ```bash
   cd backend
   yarn install
   yarn start:dev
   ```

3. **Frontend setup**
   ```bash
   cd frontend
   yarn install
   yarn dev
   ```

## 🔧 Development Workflow

### Rebuilding Services

Use the rebuild script for different scenarios:

```bash
# Soft rebuild (config/env changes only)
./scripts/rebuild.sh <service> soft

# Hard rebuild (code/Dockerfile changes)
./scripts/rebuild.sh <service> hard
```

**Examples:**
```bash
# After backend code changes
./scripts/rebuild.sh backend hard

# After environment variable changes
./scripts/rebuild.sh frontend soft

# Rebuild everything
./scripts/rebuild.sh all hard
```

### Available Services
- `frontend` - React application
- `backend` - NestJS API
- `postgres` - PostgreSQL database
- `pgadmin` - Database administration
- `all` - All services

## 📊 API Endpoints

### Authentication
- `POST /auth/signup` - User registration
- `POST /auth/login` - User login

### Users
- `GET /users` - Get all users
- `GET /users/:id` - Get user by ID
- `PUT /users/:id` - Update user
- `DELETE /users/:id` - Delete user

### Blogs
- `GET /blogs` - Get all blogs
- `GET /blogs/:id` - Get blog by ID
- `POST /blogs` - Create new blog
- `PUT /blogs/:id` - Update blog
- `DELETE /blogs/:id` - Delete blog

### Metrics
- `GET /metrics` - Application metrics (Prometheus format)

## 🗄️ Database

### Connection Details
- **Host**: `postgres` (Docker) or `localhost` (local)
- **Port**: `5432`
- **Database**: `test_db`
- **Username**: `postgres`
- **Password**: `password`

### pgAdmin Access
- **URL**: http://localhost:5050
- **Email**: admin@admin.com
- **Password**: admin

## 🧪 Testing

### API Testing
```bash
# Run API smoke tests
./scripts/test-api.sh.sh

# Health check
curl -s http://localhost:8080/api | jq .
```

### Backend Testing
```bash
cd backend
yarn test
yarn test:e2e
```

### Frontend Testing
```bash
cd frontend
yarn type-check
yarn lint
```

## 📝 Environment Variables

### Backend (.env)
```env
NODE_ENV=development
DATABASE_HOST=postgres
DATABASE_PORT=5432
DATABASE_NAME=test_db
DATABASE_USER=postgres
DATABASE_PASSWORD=password
JWT_SECRET=your_jwt_secret
JWT_EXPIRES_IN=1d
```

### Frontend (.env)
```env
VITE_API_URL=http://localhost:8080
FRONTEND_PORT=3000
```

## 🔍 Monitoring & Observability

- **Metrics**: Prometheus-compatible metrics at `/metrics`
- **Logging**: Structured logging with request/response details
- **Tracing**: OpenTelemetry integration for distributed tracing
- **Health Checks**: Built-in health check endpoints

## 🚀 Deployment

### Production Build
```bash
# Build production images
docker compose -f docker-compose.prod.yml up -d

# Or use the build script
./scripts/build.sh all
```

### Environment Setup
1. Set `NODE_ENV=production`
2. Configure production database credentials
3. Set secure JWT secret
4. Enable SSL for database connections

## 📁 Project Structure

```
├── backend/                 # NestJS API
│   ├── src/
│   │   ├── auth/           # Authentication module
│   │   ├── blogs/          # Blog management
│   │   ├── users/          # User management
│   │   ├── metrics/        # Monitoring & metrics
│   │   └── common/         # Shared utilities
│   └── Dockerfile
├── frontend/               # React application
│   ├── src/
│   │   ├── components/     # Reusable UI components
│   │   ├── pages/          # Page components
│   │   ├── services/       # API services
│   │   └── contexts/       # React contexts
│   └── Dockerfile
├── database/               # Database setup
│   ├── init.sql           # Database initialization
│   └── pgadmin-servers.json
├── scripts/               # Build and utility scripts
└── docker-compose.yml     # Service orchestration
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License.

## 🆘 Troubleshooting

### Common Issues

**Database connection failed**
- Ensure PostgreSQL container is running
- Check database credentials in environment variables
- Verify network connectivity between services

**Frontend can't connect to backend**
- Check `VITE_API_URL` environment variable
- Ensure backend service is running on port 8080
- Verify CORS configuration

**Build failures**
- Clear Docker cache: `docker system prune -a`
- Rebuild images: `./scripts/rebuild.sh <service> hard`
- Check for port conflicts

### Useful Commands

```bash
# View service logs
docker compose logs -f <service>

# Restart specific service
docker compose restart <service>

# Clean up containers and volumes
docker compose down -v

# Check service status
docker compose ps
```

For more detailed debugging information, check the individual README files in the `backend/` and `frontend/` directories.