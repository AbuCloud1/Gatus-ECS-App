# Simple Branch Strategy (No Confusion!)

## Branch Names = Directory Names

### Main Branch (Production)
- **Branch**: `main`
- **Directory**: `terraform/environments/prod`
- **Purpose**: Production environment
- **Deployment**: Auto-deploys to production

### Staging Branch (Staging)
- **Branch**: `staging`
- **Directory**: `terraform/environments/staging`
- **Purpose**: Staging environment
- **Deployment**: Auto-deploys to staging

### Dev Branch (Development)
- **Branch**: `dev`
- **Directory**: `terraform/environments/dev`
- **Purpose**: Development environment
- **Deployment**: Auto-deploys to development

## Simple Rule

**Push to `dev` branch = Deploy to dev environment**
**Push to `staging` branch = Deploy to staging environment**
**Push to `main` branch = Deploy to production environment**

## How to Use

### Development Workflow
1. **Work on `dev` branch** → Deploys to dev environment
2. **Test in dev** → Make sure everything works
3. **Push to `staging` branch** → Deploys to staging environment
4. **Test in staging** → Final validation
5. **Merge to `main` branch** → Deploys to production environment

### Branch Protection
- **Main branch**: Protected (requires pull request)
- **Staging branch**: Direct push allowed
- **Dev branch**: Direct push allowed

## No More Confusion!

- **Branch name** = **Directory name** = **Environment name**
- **3 branches total**: `main`, `staging`, `dev`
- **3 environments total**: `prod`, `staging`, `dev`
- **Simple mapping**: Push to branch = Deploy to environment
