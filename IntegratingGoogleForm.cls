@RestResource(urlMapping='/IntegratingGoogleForm/*')
global with sharing class IntegratingGoogleForm {

    @HttpPost
    global static String handleFormSubmission() {
        try {
            RestRequest req = RestContext.request;
            String requestBody = req.requestBody.toString();
            
            // Log the incoming request for debugging
            System.debug('Incoming request body: ' + requestBody);

            // Parse the incoming JSON payload
            Map<String, Object> formData = (Map<String, Object>) JSON.deserializeUntyped(requestBody);

            // Extract form data with null checks
            String firstName = formData.get('firstName') != null ? (String)formData.get('firstName') : '';
            String lastName = formData.get('lastName') != null ? (String)formData.get('lastName') : '';
            String email = formData.get('email') != null ? (String)formData.get('email') : '';
            
            // Handle phone number - now as String for Phone field type
            String phoneNumber = null;
            if (formData.get('phoneNumber') != null) {
                String phoneStr = String.valueOf(formData.get('phoneNumber'));
                
                // Basic phone number validation and formatting
                if (!String.isEmpty(phoneStr.trim())) {
                    // Remove extra whitespace
                    phoneStr = phoneStr.trim();
                    
                    // Optional: Add basic phone number validation
                    // Remove non-numeric characters for validation
                    String numericOnly = phoneStr.replaceAll('[^0-9]', '');
                    
                    if (numericOnly.length() >= 10 && numericOnly.length() <= 15) {
                        phoneNumber = phoneStr; // Keep original formatting
                    } else {
                        System.debug('Invalid phone number length: ' + numericOnly.length());
                        // You can choose to either set to null or throw an error
                        phoneNumber = null;
                    }
                }
            }

            // Temporarily removed validation for testing
            System.debug('firstName: ' + firstName);
            System.debug('lastName: ' + lastName);
            System.debug('email: ' + email);
            System.debug('phoneNumber: ' + phoneNumber);

            // Create Google Contact Form record
            GoogleForm_Records__c contactForm = new GoogleForm_Records__c();
            contactForm.Name = firstName;
            contactForm.Last_Name__c = lastName;
            contactForm.Email__c = email;
            contactForm.Phone_Number__c = phoneNumber;

            // Insert the record
            insert contactForm;
            
            // Add proper content type header
            RestContext.response.addHeader('Content-Type', 'application/json');
            
            // Return success response
            return JSON.serialize(new Map<String, Object>{
                'success' => true,
                'message' => 'Record created successfully',
                'recordId' => contactForm.Id
            });
            
        } catch (Exception e) {
            // Error Logging
            System.debug('Error in handleFormSubmission: ' + e.getMessage());
            System.debug('Stack trace: ' + e.getStackTraceString());
            
            // Return error response
            RestContext.response.statusCode = 500;
            return JSON.serialize(new Map<String, Object>{
                'success' => false,
                'message' => 'Error creating record: ' + e.getMessage()
            });
        }
    }
}
