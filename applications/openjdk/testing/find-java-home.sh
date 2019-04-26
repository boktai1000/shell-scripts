  #!/bin/bash
  
  # curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/applications/openjdk/testing/find-java-home.sh | sudo bash
  
  # Try to find JAVA_HOME
  echo "Locating JAVA_HOME..."
  if [[ "$OS" = "Darwin" ]]; then
    JAVA_VERSION=`echo "$(java -version 2>&1)" | grep "java version" | awk '{ print substr($3, 2, length($3)-2); }'`
    JAVA_HOME=`/usr/libexec/java_home`
  elif [[ "$OS" = "Linux" ]]; then
    JAVA_HOME=$(readlink -f /usr/bin/javac | sed "s:/bin/javac::")
  fi
  echo "Found: $JAVA_HOME"

  # Check JAVA_HOME
  while [ ! -f "$JAVA_HOME/bin/javac" ]; do
    echo -e "\033[1;31mJAVA_HOME is incorrect!\033[0m"
    echo -e "\033[1;33mJAVA_HOME should be a directory containing \"bin/javac\"!\033[0m"
    read -e -p "Please enter JAVA_HOME manually: " JAVA_HOME
  done;

if [ -n "$JAVA_VERSION" ]; then
  echo "Your Java version is: $JAVA_VERSION"
fi
echo "JAVA_HOME is now set to: $JAVA_HOME"
