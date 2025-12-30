#!/bin/bash

# Script to fix Render deployment by removing Dockerfile

echo "🔧 Fixing Render Deployment..."
echo ""

# Check if we're in the right directory
if [ ! -f "backend/pom.xml" ]; then
    echo "❌ Error: Please run this script from the Meditrack root directory"
    exit 1
fi

# Check git status
echo "📋 Current git status:"
git status --short | grep -i docker || echo "No Docker-related changes"

echo ""
echo "🚀 Committing Dockerfile changes..."

# Remove Dockerfile from git
if [ -f "backend/Dockerfile" ]; then
    echo "Removing Dockerfile from git..."
    git rm backend/Dockerfile
fi

# Add Dockerfile.backup if it exists
if [ -f "backend/Dockerfile.backup" ]; then
    echo "Adding Dockerfile.backup..."
    git add backend/Dockerfile.backup
fi

# Commit
echo "Committing changes..."
git commit -m "Disable Dockerfile for Render deployment - use Java build instead"

echo ""
echo "✅ Changes committed!"
echo ""
echo "📤 Next step: Push to GitHub"
read -p "Do you want to push to GitHub now? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Pushing to GitHub..."
    git push origin main
    echo ""
    echo "✅ Pushed to GitHub!"
    echo ""
    echo "📝 Next steps:"
    echo "1. Go to Render dashboard"
    echo "2. DELETE your current service"
    echo "3. Create NEW service with these settings:"
    echo "   - Root Directory: backend"
    echo "   - Runtime: Java"
    echo "   - Build Command: mvn clean package -DskipTests"
    echo "   - Start Command: java -jar target/*.jar"
    echo ""
    echo "See FIX_RENDER_NOW.md for detailed instructions"
else
    echo ""
    echo "⚠️  Remember to push manually:"
    echo "   git push origin main"
    echo ""
    echo "Then follow steps in FIX_RENDER_NOW.md"
fi

