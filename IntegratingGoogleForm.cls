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
            String lastName = formData.get('lastName') != null ? (String)formData.get('lastName') : ''; // Fixed typo
            String email = formData.get('email') != null ? (String)formData.get('email') : '';
            
            // Handle phone number conversion from String to Number
            Decimal phoneNumber = null;
            if (formData.get('phoneNumber') != null) {
                String phoneStr = String.valueOf(formData.get('phoneNumber'));
                // Remove any non-numeric characters (spaces, dashes, parentheses, etc.)
                phoneStr = phoneStr.replaceAll('[^0-9]', '');
                if (!String.isEmpty(phoneStr)) {
                    try {
                        phoneNumber = Decimal.valueOf(phoneStr);
                    } catch (Exception phoneEx) {
                        System.debug('Error converting phone number: ' + phoneEx.getMessage());
                        // Phone number will remain null if conversion fails
                    }
                }
            }

            // Create Google Contact Form record
            GoogleForm_Records__c contactForm = new GoogleForm_Records__c();
            contactForm.Name = firstName + ' ' + lastName; // Combine first and last name for Name field
            contactForm.Last_Name__c = lastName;
            contactForm.Email__c = email;
            contactForm.Phone__c = phoneNumber; // Now properly converted to Number type

            // Insert the record
            insert contactForm;
            
            // Return success response
            return JSON.serialize(new Map<String, Object>{
                'success' => true,
                'message' => 'Record created successfully',
                'recordId' => contactForm.Id
            });
            
        } catch (Exception e) {
            // Error Logging if any
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
