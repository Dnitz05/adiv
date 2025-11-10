# iOS Signing Setup Guide

This guide walks you through configuring iOS code signing for the Smart Divination tarot app.

## Prerequisites

- **Apple Developer Account** (99 USD/year): https://developer.apple.com/programs/
- **Xcode installed** on macOS (required for certificate management)
- **App Bundle ID decided**: e.g., `com.smartdivination.tarot`

## Step 1: Create App ID

1. Go to https://developer.apple.com/account/resources/identifiers/list
2. Click **+** to create a new identifier
3. Select **App IDs** -> **Continue**
4. Select **App** -> **Continue**
5. Fill in:
   - **Description**: Smart Divination Tarot
   - **Bundle ID**: Explicit -> `com.smartdivination.tarot`
   - **Capabilities**: Enable any needed (Push Notifications, In-App Purchase if planned)
6. Click **Continue** -> **Register**

## Step 2: Create Distribution Certificate

### Option A: Using Xcode (Recommended)

1. Open **Xcode** -> **Preferences** -> **Accounts**
2. Add your Apple ID if not already added
3. Select your account -> **Manage Certificates**
4. Click **+** -> **Apple Distribution**
5. Certificate will be created and stored in your Keychain

### Option B: Manual Certificate Request

1. Open **Keychain Access** on macOS
2. **Keychain Access** menu -> **Certificate Assistant** -> **Request a Certificate from a Certificate Authority**
3. Fill in:
   - **User Email**: Your email
   - **Common Name**: Smart Divination Distribution
   - **CA Email**: Leave empty
   - Select **Saved to disk**
4. Save the **CertificateSigningRequest.certSigningRequest** file
5. Go to https://developer.apple.com/account/resources/certificates/list
6. Click **+** -> Select **Apple Distribution** -> **Continue**
7. Upload the CSR file -> **Continue**
8. Download the generated certificate -> Double-click to install in Keychain

## Step 3: Export Distribution Certificate as P12

1. Open **Keychain Access**
2. Select **My Certificates** category
3. Find your **Apple Distribution** certificate (it will have a private key underneath)
4. Right-click -> **Export "Apple Distribution..."**
5. Save as: `distribution-certificate.p12`
6. **Set a strong password** (e.g., `SmartDivination2025!`)
7. Save this file securely - you'll need it for CI/CD

## Step 4: Create Provisioning Profile

1. Go to https://developer.apple.com/account/resources/profiles/list
2. Click **+** to create new profile
3. Select **App Store Connect** (for distribution) -> **Continue**
4. Select your App ID (`com.smartdivination.tarot`) -> **Continue**
5. Select your **Distribution Certificate** -> **Continue**
6. Give it a name: `Smart Divination Tarot App Store`
7. Click **Generate**
8. **Download** the `.mobileprovision` file
9. Double-click to install in Xcode

## Step 5: Configure Flutter Project

### Update `ios/Runner.xcodeproj/project.pbxproj`

You may need to manually edit or use Xcode:

1. Open `smart-divination/apps/tarot/ios/Runner.xcworkspace` in Xcode
2. Select **Runner** project in left panel
3. Select **Runner** target -> **Signing & Capabilities**
4. **Uncheck** "Automatically manage signing"
5. Select **Release** configuration
6. Set:
   - **Provisioning Profile**: Select the profile you created
   - **Team**: Select your Apple Developer team

### Update `ios/Runner/Info.plist`

Verify the Bundle Identifier matches:
```xml
<key>CFBundleIdentifier</key>
<string>com.smartdivination.tarot</string>
```

## Step 6: Create App Store Connect API Key (for CI/CD)

1. Go to https://appstoreconnect.apple.com/access/api
2. Click **+** to generate a new key
3. Fill in:
   - **Name**: Smart Divination CI
   - **Access**: App Manager (or Admin for full access)
4. Click **Generate**
5. **Download** the `.p8` key file immediately (you can only download once!)
6. Note the **Key ID** (e.g., `ABC123XYZ`)
7. Note the **Issuer ID** (shown at the top of the page)

## Step 7: Prepare Files for GitHub Actions

Create a secure location for these files (DO NOT commit to git):

### Files needed:
1. **distribution-certificate.p12** (from Step 3)
2. **certificate-password.txt** (the password you set)
3. **profile.mobileprovision** (from Step 4)
4. **AuthKey_XXXXXX.p8** (from Step 6)
5. **api-key-info.txt** with:
   ```
   Key ID: ABC123XYZ
   Issuer ID: 12345678-1234-1234-1234-123456789012
   ```

### Base64 encode for GitHub Secrets:

On macOS/Linux:
```bash
# Certificate
base64 -i distribution-certificate.p12 -o cert-base64.txt

# Provisioning profile
base64 -i profile.mobileprovision -o profile-base64.txt

# API key
base64 -i AuthKey_ABC123XYZ.p8 -o apikey-base64.txt
```

On Windows (PowerShell):
```powershell
[Convert]::ToBase64String([IO.File]::ReadAllBytes("distribution-certificate.p12")) | Out-File cert-base64.txt
[Convert]::ToBase64String([IO.File]::ReadAllBytes("profile.mobileprovision")) | Out-File profile-base64.txt
[Convert]::ToBase64String([IO.File]::ReadAllBytes("AuthKey_ABC123XYZ.p8")) | Out-File apikey-base64.txt
```

## Step 8: Test Local Build

```bash
cd smart-divination/apps/tarot
flutter build ipa --release \
  --dart-define=API_BASE_URL=https://backend-gv4a2ueuy-dnitzs-projects.vercel.app \
  --dart-define=SUPABASE_URL=YOUR_SUPABASE_URL \
  --dart-define=SUPABASE_ANON_KEY=YOUR_ANON_KEY
```

The IPA file will be at: `build/ios/archive/Runner.xcarchive`

## Step 9: Add Secrets to GitHub Actions

Once you have the base64-encoded files, add these secrets to your GitHub repository:

| Secret Name | Value |
|------------|-------|
| `IOS_CERTIFICATE_BASE64` | Contents of `cert-base64.txt` |
| `IOS_CERTIFICATE_PASSWORD` | The password you set |
| `IOS_PROVISIONING_PROFILE_BASE64` | Contents of `profile-base64.txt` |
| `APP_STORE_CONNECT_KEY_ID` | Key ID from Step 6 |
| `APP_STORE_CONNECT_ISSUER_ID` | Issuer ID from Step 6 |
| `APP_STORE_CONNECT_KEY_BASE64` | Contents of `apikey-base64.txt` |

## Troubleshooting

### "No matching provisioning profile found"
- Ensure Bundle ID matches exactly in all places
- Verify provisioning profile includes your distribution certificate
- Try regenerating the provisioning profile

### "Code signing is required for product type 'Application'"
- Ensure you've selected a provisioning profile in Xcode
- Check that the certificate is valid and in your Keychain

### "Unable to install app on device"
- Development builds need different provisioning (Development, not Distribution)
- For device testing, create a Development provisioning profile with your device UDID

## Security Notes

- **Never commit** P12 files, provisioning profiles, or API keys to git
- Store base64-encoded secrets only in GitHub Secrets or secure vault
- Rotate certificates before expiration (1 year for distribution)
- Revoke API keys if exposed

## Next Steps

After completing this setup:
1. Update `docs/SECRETS.md` with your specific Key IDs
2. Configure GitHub Actions secrets (see Task 3)
3. Test CI/CD build workflow
4. Proceed to App Store Connect submission

## References

- [Apple Code Signing Guide](https://developer.apple.com/support/code-signing/)
- [App Store Connect API](https://developer.apple.com/documentation/appstoreconnectapi)
- [Flutter iOS Deployment](https://docs.flutter.dev/deployment/ios)
