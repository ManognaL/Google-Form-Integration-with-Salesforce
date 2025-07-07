# Google Forms to Salesforce Integration

This project demonstrates how to integrate Google Forms with Salesforce, automatically creating records in a custom Salesforce object when a form is submitted.

## 📋 Overview

When a user submits a Google Form, the integration:
1. Captures the form response data
2. Sends it to a Salesforce REST API endpoint
3. Creates a new record in the `GoogleForm_Records__c` custom object

## 🏗️ Architecture

```
Google Form → Google Apps Script → Salesforce REST API → GoogleForm_Records__c Object
```

## 🔧 Prerequisites

### Salesforce Setup
- Salesforce Developer/Production org
- Custom object `GoogleForm_Records__c` with fields:
  - `Name` (Text)
  - `Last_Name__c` (Text)
  - `Email__c` (Email/Text)
  - `Phone_Number__c` (Number)
- Salesforce Site enabled for REST API access

### Google Setup
- Google account with access to Google Forms and Google Apps Script
- Google Form with fields matching the Salesforce object

## 📁 Project Structure

```
├── google-apps-script/
│   └── Code.gs                 # Google Apps Script code
├── salesforce/
│   └── IntegratingGoogleForm.cls  # Salesforce Apex REST class
└── README.md                   # This file
```

## ⚙️ Setup Instructions

### 1. Salesforce Configuration

#### Create Custom Object
1. Go to **Setup** → **Object Manager**
2. Create a new custom object named `GoogleForm_Records__c`
3. Add the following custom fields:
   - `Last_Name__c` (Text, 255)
   - `Email__c` (Email, 255)
   - `Phone_Number__c` (Number, 18, 0)

#### Deploy Apex Class
1. Go to **Setup** → **Apex Classes**
2. Click **New** and paste the content from `salesforce/IntegratingGoogleForm.cls`
3. Save and deploy

#### Configure Salesforce Site
1. Go to **Setup** → **Sites**
2. Create a new site or use existing one
3. Note the site URL (e.g., `https://yourorg.my.salesforce-sites.com`)

#### Set Remote Site Settings
1. Go to **Setup** → **Remote Site Settings**
2. Click **New Remote Site**
3. Configure:
   - **Remote Site Name**: `GoogleAppsScript`
   - **Remote Site URL**: `https://script.google.com`
   - **Active**: ✓

#### Configure Site Permissions
1. Go to your **Site** → **Public Access Settings**
2. Under **Enabled Apex Class Access**, add `IntegratingGoogleForm`
3. Under **Object Settings**, enable Create/Read access for `GoogleForm_Records__c`
4. Set Field-Level Security for all fields (Read/Edit access)

### 2. Google Apps Script Configuration

#### Create Apps Script Project
1. Go to [Google Apps Script](https://script.google.com)
2. Create a new project
3. Replace the default code with content from `google-apps-script/Code.gs`

#### Update Configuration
1. Replace the Salesforce URL in the script with your site URL:
   ```javascript
   var response = UrlFetchApp.fetch('https://YOUR-SITE-URL.my.salesforce-sites.com/services/apexrest/IntegratingGoogleForm/', options);
   ```

#### Set Up Trigger
1. Click **Triggers** (clock icon)
2. Click **+ Add Trigger**
3. Configure:
   - **Function**: `onFormSubmit`
   - **Event source**: `From form`
   - **Event type**: `On form submit`
4. Save the trigger

### 3. Google Form Setup

Create a Google Form with questions that match your field mapping:
- "First Name" → `firstName`
- "Last Name" → `lastName`
- "Email" → `email`
- "Phone" → `phoneNumber`

#### Link Form to Script
1. In your Google Form, click **More** (three dots)
2. Select **Script editor**
3. This should open your Apps Script project
4. If not, manually link by going to **Resources** → **Current project's triggers**

## 🔄 How It Works

### Data Flow
1. **Form Submission**: User submits Google Form
2. **Trigger Activation**: `onFormSubmit` function is triggered
3. **Data Processing**: Script extracts form responses and maps them to payload
4. **API Call**: HTTP POST request sent to Salesforce REST endpoint
5. **Record Creation**: Salesforce creates new `GoogleForm_Records__c` record

### Field Mapping
| Google Form Question | Script Variable | Salesforce Field |
|---------------------|-----------------|------------------|
| First Name          | `firstName`     | `Name`           |
| Last Name           | `lastName`      | `Last_Name__c`   |
| Email               | `email`         | `Email__c`       |
| Phone               | `phoneNumber`   | `Phone_Number__c`       |

## 🧪 Testing

### Test the Integration
1. Run the `testFormSubmission()` function in Google Apps Script
2. Check the **Logs** (View → Logs) for success/error messages
3. Verify record creation in Salesforce

### Troubleshooting
- Check Google Apps Script logs for errors
- Enable Salesforce Debug logs for the site guest user
- Verify CORS and permissions settings
- Test with the manual test function first

## 📊 Monitoring

### Google Apps Script Logs
- View → Logs in Apps Script editor
- Check for HTTP response codes and error messages

### Salesforce Debug Logs
- Setup → Debug Logs
- Create log for site guest user
- Monitor for API calls and errors

## 🔒 Security Considerations

- Uses Salesforce Site guest user permissions
- No authentication required (public endpoint)
- Consider adding validation/sanitization for production use
- Monitor for spam/abuse if publicly accessible

## 🚀 Deployment

### Production Checklist
- [ ] Test with sample data
- [ ] Verify all field mappings
- [ ] Set up monitoring/logging
- [ ] Configure error handling
- [ ] Test form submission end-to-end
- [ ] Set up backup/recovery procedures

## 📝 Customization

### Adding New Fields
1. Add field to `GoogleForm_Records__c` object
2. Update field mapping in Google Apps Script
3. Add field extraction in Salesforce Apex class
4. Update form questions to match

### Error Handling
- Both scripts include try-catch blocks
- Errors are logged for debugging
- Consider adding email notifications for failures



## 📞 Support

For issues or questions:
1. Check the troubleshooting section
2. Review Salesforce and Google Apps Script documentation
3. Open an issue in this repository

## 🔗 Useful Links

- [Salesforce REST API Documentation](https://developer.salesforce.com/docs/atlas.en-us.api_rest.meta/api_rest/)
- [Google Apps Script Documentation](https://developers.google.com/apps-script)
- [Salesforce Sites Documentation](https://help.salesforce.com/articleView?id=sites_intro.htm)
