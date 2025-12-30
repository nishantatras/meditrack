#!/bin/bash
# Script to generate BCrypt hash for a password
# Usage: ./generate-password-hash.sh [password]

PASSWORD=${1:-password123}

echo "Generating BCrypt hash for password: $PASSWORD"
echo ""

# Try using Spring Boot's BCryptPasswordEncoder via Maven
cd "$(dirname "$0")/.." || exit

mvn -q exec:java \
  -Dexec.mainClass="org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder" \
  -Dexec.args="$PASSWORD" \
  2>/dev/null || {
    echo "Maven execution failed. Using alternative method..."
    echo ""
    echo "You can generate the hash using one of these methods:"
    echo ""
    echo "1. Use an online BCrypt generator: https://bcrypt-generator.com/"
    echo "2. Use Python:"
    echo "   python3 -c \"import bcrypt; print(bcrypt.hashpw(b'$PASSWORD', bcrypt.gensalt()).decode())\""
    echo ""
    echo "3. Use Node.js:"
    echo "   node -e \"const bcrypt = require('bcrypt'); bcrypt.hash('$PASSWORD', 10).then(h => console.log(h));\""
    echo ""
    echo "4. Register the user through the API first, then run the migration"
    echo "   (the migration will skip user insertion due to ON CONFLICT)"
}
