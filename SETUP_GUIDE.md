# 🚀 AI Code Mentor - Setup & Configuration Guide

## Table of Contents
1. [Quick Start](#quick-start)
2. [API Key Configuration](#api-key-configuration)
3. [Platform-Specific Setup](#platform-specific-setup)
4. [Testing the App](#testing-the-app)
5. [Troubleshooting](#troubleshooting)

---

## Quick Start

### Step 1: Install Dependencies

```bash
cd ai_code_mentor
flutter pub get
```

### Step 2: Configure API Key

**IMPORTANT**: Before running the app, you must add your OpenRouter API key.

1. Open `lib/core/constants/api_constants.dart`
2. Find this line:
   ```dart
   static const String apiKey = 'YOUR_API_KEY_HERE';
   ```
3. Replace `YOUR_API_KEY_HERE` with your actual API key:
   ```dart
   static const String apiKey = 'sk-or-v1-xxxxxxxxxxxxx';
   ```

### Step 3: Run the App

```bash
flutter run
```

---

## API Key Configuration

### Getting Your OpenRouter API Key

1. **Sign Up**
   - Visit [https://openrouter.ai/](https://openrouter.ai/)
   - Create an account (free tier available)

2. **Generate API Key**
   - Go to [API Keys](https://openrouter.ai/keys)
   - Click "Create Key"
   - Copy your API key (starts with `sk-or-v1-`)

3. **Add to App**
   - Open `lib/core/constants/api_constants.dart`
   - Replace placeholder with your key
   - Save the file

### Choosing AI Model

You can change which AI model the app uses:

**Location**: `lib/core/constants/api_constants.dart`

```dart
static const String defaultModel = 'openai/gpt-4-turbo-preview';
```

**Recommended Models**:

| Model | Best For | Speed | Quality |
|-------|----------|-------|---------|
| `openai/gpt-4-turbo-preview` | Complex code analysis | Medium | Excellent |
| `openai/gpt-3.5-turbo` | Quick responses | Fast | Good |
| `anthropic/claude-3-opus` | Detailed explanations | Slow | Excellent |
| `anthropic/claude-3-sonnet` | Balanced performance | Medium | Very Good |
| `google/gemini-pro` | General analysis | Fast | Good |

### Customizing System Prompt

The system prompt defines how the AI behaves. You can customize it in `api_constants.dart`:

```dart
static const String systemPrompt = '''
You are an expert AI Code Mentor...
// Modify this to change AI behavior
''';
```

---

## Platform-Specific Setup

### 🤖 Android Setup

#### 1. Permissions

Ensure these permissions are in `android/app/src/main/AndroidManifest.xml`:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- Internet permission for API calls -->
    <uses-permission android:name="android.permission.INTERNET"/>
    
    <!-- Storage permissions for image picker -->
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
    <uses-permission android:name="android.permission.READ_MEDIA_IMAGES"/>
    
    <!-- Camera permission (optional - for camera capture) -->
    <uses-permission android:name="android.permission.CAMERA"/>
    
    <application
        ...
```

#### 2. Network Configuration

For API calls to work, add network security config if needed:

`android/app/src/main/res/xml/network_security_config.xml`:
```xml
<?xml version="1.0" encoding="utf-8"?>
<network-security-config>
    <base-config cleartextTrafficPermitted="false">
        <trust-anchors>
            <certificates src="system" />
        </trust-anchors>
    </base-config>
</network-security-config>
```

#### 3. Minimum SDK

In `android/app/build.gradle`:
```gradle
android {
    defaultConfig {
        minSdkVersion 21  // Minimum required
        targetSdkVersion 34
    }
}
```

---

### 🍎 iOS Setup

#### 1. Permissions

Add to `ios/Runner/Info.plist`:

```xml
<dict>
    <!-- Photo Library Access -->
    <key>NSPhotoLibraryUsageDescription</key>
    <string>We need access to your photo library to upload code screenshots for analysis</string>
    
    <!-- Camera Access (optional) -->
    <key>NSCameraUsageDescription</key>
    <string>We need camera access to capture code screenshots for analysis</string>
    
    <!-- Photo Library Add -->
    <key>NSPhotoLibraryAddUsageDescription</key>
    <string>We need permission to save analyzed code results</string>
</dict>
```

#### 2. Minimum iOS Version

In `ios/Podfile`:
```ruby
platform :ios, '12.0'
```

#### 3. Run Pod Install

```bash
cd ios
pod install
cd ..
```

---

## Testing the App

### Test Case 1: Simple Python Error

1. Go to Home Screen
2. Tap "Paste Code"
3. Enter this code:
```python
def calculate_sum(a, b)
    return a + b

result = calculate_sum(5, 10)
print(result)
```
4. In Error Logs, add:
```
SyntaxError: invalid syntax
```
5. Tap "Analyze with AI"
6. Verify all tabs work correctly

### Test Case 2: JavaScript Bug

```javascript
const numbers = [1, 2, 3, 4, 5];
let sum = 0;

for (let i = 0; i <= numbers.length; i++) {
    sum += numbers[i];
}

console.log(sum);
```

Error: `TypeError: Cannot read property of undefined`

### Test Case 3: History Feature

1. Analyze multiple code snippets
2. Go to History screen
3. Tap on a previous analysis
4. Verify it loads correctly

---

## Troubleshooting

### ❌ Error: "API Key Invalid"

**Problem**: API key not configured or incorrect

**Solutions**:
1. Check `lib/core/constants/api_constants.dart`
2. Verify key starts with `sk-or-v1-`
3. Ensure no extra spaces or quotes
4. Regenerate key on OpenRouter if needed

---

### ❌ Error: "Image Picker Not Working"

**Problem**: Missing platform permissions

**Solutions**:

**Android**:
```bash
# Check AndroidManifest.xml has required permissions
# Rebuild app
flutter clean
flutter pub get
flutter run
```

**iOS**:
```bash
# Check Info.plist has usage descriptions
cd ios
pod install
cd ..
flutter run
```

---

### ❌ Error: "Network Request Failed"

**Problem**: Internet connectivity or API issues

**Solutions**:
1. Check device internet connection
2. Verify API key is valid
3. Check OpenRouter service status
4. Try different AI model
5. Review API usage limits

---

### ❌ Build Errors After Package Update

```bash
flutter clean
flutter pub get
cd ios && pod install && cd ..
flutter run
```

---

### ❌ Dark/Light Theme Not Switching

**Problem**: Theme provider not initialized

**Solution**:
- Restart the app
- Check `main.dart` has `ProviderScope` wrapper
- Clear app data and reinstall

---

## Advanced Configuration

### Changing Request Timeout

In `lib/core/constants/app_constants.dart`:

```dart
static const int apiTimeoutSeconds = 60; // Change as needed
```

### Adjusting History Limit

```dart
static const int maxHistoryItems = 50; // Default: 50
```

### Modifying Code Editor Settings

```dart
static const int maxCodeLength = 50000;  // Max characters
static const int tabSize = 2;            // Tab spacing
```

---

## Performance Tips

1. **Large Code Files**
   - Break into smaller chunks
   - Consider code length limits

2. **Slow Analysis**
   - Try faster AI model (gpt-3.5-turbo)
   - Reduce max_tokens in API request

3. **Memory Issues**
   - Clear history regularly
   - Limit screenshot resolution

---

## Security Best Practices

1. **API Key Storage**
   - Never commit API key to version control
   - Use environment variables in production
   - Consider using flutter_dotenv package

2. **Local Storage**
   - History is stored locally only
   - No data sent to third parties
   - Clear history for sensitive code

---

## Support & Resources

- **OpenRouter Docs**: https://openrouter.ai/docs
- **Flutter Docs**: https://docs.flutter.dev/
- **Riverpod Guide**: https://riverpod.dev/

---

## Next Steps

After setup:
1. ✅ Test with sample code
2. ✅ Explore all features
3. ✅ Customize theme colors
4. ✅ Try different AI models
5. ✅ Build for production

---

**Happy Coding! 🚀**
