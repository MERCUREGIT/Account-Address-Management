# Salesforce DX Project: Next Steps

Now that you’ve created a Salesforce DX project, what’s next? Here are some documentation resources to get you started.

## How Do You Plan to Deploy Your Changes?

Do you want to deploy a set of changes, or create a self-contained application? Choose a [development model](https://developer.salesforce.com/tools/vscode/en/user-guide/development-models).

## Configure Your Salesforce DX Project

The `sfdx-project.json` file contains useful configuration information for your project. See [Salesforce DX Project Configuration](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_ws_config.htm) in the _Salesforce DX Developer Guide_ for details about this file.

## Read All About It

- [Salesforce Extensions Documentation](https://developer.salesforce.com/tools/vscode/)
- [Salesforce CLI Setup Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_intro.htm)
- [Salesforce DX Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_intro.htm)
- [Salesforce CLI Command Reference](https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference.htm)

## Project requirements

- Creation a custom object to store addresses as a separate entity for account. Address can be Billing, or Shipping. Address can be marked as main.
- An Account_Address__C object was created and a master to detail relationship established with the parent account standard object.
- Appropriate custom fields such as city_c, country_c, state_c,street_c,PostalCode__c,Address_Type_c , Account__c created.
- Country__c and Address_Type_c are picklist while Country_c is open, Address_Type__C is strict on its values
- Create Apex logic to support following behavior:
- If a user creates a new account and at least one field for the Billing address is not empty, the system must automatically create a new Main Billing Address. The same logic should be applied for Shipping Address :white_check_mark:
One account can have only one main billing address and only one main shipping address  :white_check_mark:
- If a user updates Account Billing Address field changes should be automatically applied to Main Billing Address. Same logic for Shipping Address :white_check_mark:
- If a user updates Main Billing Address changes should be automatically applied to Account Billing Address. The same logic should be applied for Main Shipping Address :white_check_mark:
- Users should be able to create a new billing/shipping address and mark it as main. :white_check_mark:
- On the standard related list component on an account object, display details of the account address, such that a user can see if it is a main shipping/billing address. :white_check_mark:
- Customize a list view for account addresses such that we can see up to 10 fields on the ‘recently viewed list view’ and we should see the same 10 fields on the view all list:white_check_mark:
- Create a list view that will show account addresses created today :white_check_mark:

- Create a custom metadata that will switch off apex triggers :white_check_mark:
3. Create a set of LWC components to display a list of account addresses on the Account Lightning Page. :white_check_mark:
- Component should show following fields: address name, main flag, address type :white_check_mark:
created a parent AddressManager component and its descendant amongst which we have the actionGroup (handles address item related user action such as delete, view and edit)
- implemented the lightning record form to facilitate edit, view and create operations on the UI, this component is hosted by a parent addressForm component
- implemented an addressItem component to display the bits of information for and address to the user on the parent addressManager component
- Used the SLDS for more of the UI styling
  - Implemented an error fallback boundry on the addressManager to handle any possible component errors
  - Component should provide an ability to open specific address for view(standard SF page) :white_check_mark:
  - Component should provide an ability to create a new address:white_check_mark:
  - Component should provide an ability to delete existing address:white_check_mark:
  - Component should provide an ability to modify existing address:white_check_mark:
