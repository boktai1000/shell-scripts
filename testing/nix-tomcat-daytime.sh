# test

mkdir /opt/tomcat9/webapps/ROOT/WEB-INF/classes 
chown tomcat. /opt/tomcat9/webapps/ROOT/WEB-INF/classes 

sudo tee /opt/tomcat9/webapps/ROOT/WEB-INF/classes/daytime.java <<\EOF
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

javac -classpath /opt/tomcat9/lib/servlet-api.jar /opt/tomcat9/webapps/ROOT/WEB-INF/classes/daytime.java

cp /opt/tomcat9/webapps/ROOT/WEB-INF/web.xml /opt/tomcat9/webapps/ROOT/WEB-INF/web.xml.bak

sudo tee /opt/tomcat9/webapps/ROOT/WEB-INF/web.xml <<\EOF
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
