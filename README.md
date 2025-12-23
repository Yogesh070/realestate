# realestate

### Setup

```bash
# Copy the example file
cp .env.example .env
```
Edit .env and replace YOUR_API_KEY_HERE with your actual Google Maps API key

#### Run the app

```bash
# Run the app (default device)
rps

# Run on specific platform
rps run:ios
rps run:android

# Build for production
rps build apk
rps build ios
rps build web
```

#### Utilities
- `rps clean` - Clean build files and get dependencies
- `rps ls` - List all available scripts