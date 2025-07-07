function onFormSubmit(e) {
  try {
    // Get all response data
    var formResponse = e.response;
    var itemResponses = formResponse.getItemResponses();
    
    // Create payload object
    var payload = {};
    
    // Loop through each form item to map responses
    for (var i = 0; i < itemResponses.length; i++) {
      var itemResponse = itemResponses[i];
      var question = itemResponse.getItem().getTitle().toLowerCase();
      var answer = itemResponse.getResponse();
      
      // Map questions to your Salesforce fields
      if (question.includes("first name")) {
        payload.firstName = answer;
      } else if (question.includes("last name")) {
        payload.lastName = answer;
      } else if (question.includes("email")) {
        payload.email = answer;
      } else if (question.includes("phone")) {
        payload.phoneNumber = answer;
      }
    }
    
    // Log the payload for debugging
    Logger.log('Payload being sent: ' + JSON.stringify(payload));
    
    // Send data to Salesforce
    var options = {
      'method': 'POST',
      'headers': {
        'Content-Type': 'application/json'
      },
      'payload': JSON.stringify(payload),
      'muteHttpExceptions': true // To see error responses
    };
    
    var response = UrlFetchApp.fetch('https://deloittecom-7ec-dev-ed.my.salesforce-sites.com/services/apexrest/IntegratingGoogleForm/', options);
    var responseText = response.getContentText();
    var responseCode = response.getResponseCode();
    
    Logger.log('Response Code: ' + responseCode);
    Logger.log('Response Text: ' + responseText);
    
    if (responseCode !== 200) {
      Logger.log('Error: HTTP ' + responseCode + ' - ' + responseText);
    }
    
  } catch (error) {
    Logger.log('Error: ' + error.toString());
  }
}

// Test function to manually trigger the form submission (for debugging)
function testFormSubmission() {
  // Create a mock form response for testing
  var mockPayload = {
    firstName: "John",
    lastName: "Doe", 
    email: "john.doe@example.com",
    phoneNumber: "1234567890"
  };
  
  var options = {
    'method': 'POST',
    'headers': {
      'Content-Type': 'application/json'
    },
    'payload': JSON.stringify(mockPayload),
    'muteHttpExceptions': true
  };
  
  var response = UrlFetchApp.fetch('https://deloittecom-7ec-dev-ed.my.salesforce-sites.com/services/apexrest/IntegratingGoogleForm/', options);
  Logger.log('Test Response Code: ' + response.getResponseCode());
  Logger.log('Test Response Text: ' + response.getContentText());
}
