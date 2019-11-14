#!/usr/bin/env bash

uname='root'
pass='root'
db='vtiger'

cat << EOF
Prerequisite:
1. Navigate to the module that you want to create the field in
2. Create custom field with type "Text" (length max 255)

Reference:
https://www.vtexperts.com/how-to-create-contacts-organization-custom-lookup-relatedto-field-in-vtiger/
EOF
read -p "Press enter to continue..."


clear; printf "\nEnter module details:\n"
read -p "Enter module where the custom field is created [eg. Faq]: " originModule
read -p "Enter target relationship module [eg. Accounts (organizations)]: " relModule


clear; printf "\nProcessing DB...\n"
mysql -u$uname -p$pass $db << EOF

-- Get the newly created fieldid
SELECT fieldid INTO @fieldid FROM vtiger_field ORDER BY fieldid DESC LIMIT 1;

-- Update the 'uitype' to '10'
UPDATE vtiger_field SET uitype='10' WHERE fieldid=@fieldid;

-- Insert relationship between modules for that field
INSERT INTO vtiger_fieldmodulerel VALUES(@fieldid, "$originModule", "$relModule", NULL, NULL);

EOF

if [ $? -eq 0 ]; then
    echo "DB updated successfully!"
else
    echo "Failed to update DB!"
fi
