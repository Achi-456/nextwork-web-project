#!/bin/bash

# Get database details from AWS
DB_ENDPOINT=$(aws cloudformation describe-stacks --stack-name nextwork-infrastructure --query 'Stacks[0].Outputs[?OutputKey==`DBEndpoint`].OutputValue' --output text)

# Update phpMyAdmin config
sudo tee /var/www/html/phpmyadmin/config.inc.php > /dev/null << EOF
<?php
\$cfg['blowfish_secret'] = '$(openssl rand -base64 32)';
\$i = 0;

\$i++;
\$cfg['Servers'][\$i]['auth_type'] = 'cookie';
\$cfg['Servers'][\$i]['host'] = '$DB_ENDPOINT';
\$cfg['Servers'][\$i]['compress'] = false;
\$cfg['Servers'][\$i]['AllowNoPassword'] = false;

\$cfg['UploadDir'] = '';
\$cfg['SaveDir'] = '';
?>
EOF

sudo chown apache:apache /var/www/html/phpmyadmin/config.inc.php