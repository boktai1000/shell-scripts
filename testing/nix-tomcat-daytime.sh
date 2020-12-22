#!/bin/bash

# https://www.server-world.info/en/note?os=CentOS_7&p=tomcat9

# curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/testing/nix-tomcat-daytime.sh | sudo bash
# curl -s https://bitbucket.org/boktai1000/shell-scripts/raw/master/testing/nix-tomcat-daytime.sh | sudo bash

# Create directory
mkdir /opt/tomcat/webapps/ROOT/WEB-INF/classes

# Set permissions
chown tomcat. /opt/tomcat/webapps/ROOT/WEB-INF/classes 

# Create daytime.java file
sudo tee /opt/tomcat/webapps/ROOT/WEB-INF/classes/daytime.java <<\EOF
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.util.Calendar;

public class daytime extends HttpServlet {
    public void doGet(HttpServletRequest request
    ,HttpServletResponse response)

    throws IOException, ServletException{
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        Calendar cal = Calendar.getInstance();
        out.println("<html>\n<head>\n<title>DayTime</title>\n</head>\n<body>");
        out.println("<div style=\"font-size: 40px; text-align: center; font-weight: bold\">");
        out.println(cal.get(Calendar.YEAR) + "/" + (cal.get(Calendar.MONTH) + 1) + "/" + 
        cal.get(Calendar.DATE) + " " + cal.get(Calendar.HOUR_OF_DAY) + ":" + cal.get(Calendar.MINUTE));
        out.println("</div>\n</body>\n</html>");
    }
}
EOF

# Java compile with classpath
javac -classpath /opt/tomcat/lib/servlet-api.jar /opt/tomcat/webapps/ROOT/WEB-INF/classes/daytime.java

# Create backup of web.xml
cp /opt/tomcat/webapps/ROOT/WEB-INF/web.xml /opt/tomcat/webapps/ROOT/WEB-INF/web.xml.bak-"$(date --utc +%FT%T.%3NZ)"

# Create new web.xml file
sudo tee /opt/tomcat/webapps/ROOT/WEB-INF/web.xml <<\EOF
<web-app>
  <servlet>
     <servlet-name>daytime</servlet-name>
     <servlet-class>daytime</servlet-class>
  </servlet>
  <servlet-mapping>
     <servlet-name>daytime</servlet-name>
     <url-pattern>/daytime</url-pattern>
  </servlet-mapping>
</web-app>
EOF
