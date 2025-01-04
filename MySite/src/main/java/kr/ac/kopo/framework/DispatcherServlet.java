package kr.ac.kopo.framework;

import java.io.IOException;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.ac.kopo.controller.Controller;

public class DispatcherServlet extends HttpServlet 
{
	
	private HandlerMapping mappings;

	@Override
	public void init(ServletConfig config) throws ServletException {
		String propName = config.getInitParameter("propName");
		//System.out.println("propName : " + propName);
		mappings = new HandlerMapping(propName);
	}
	//
	@Override
	public void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	    String contextPath = request.getContextPath();
	    String uri = request.getRequestURI();
	    uri = uri.substring(contextPath.length());
	    System.out.println("요청 URI: " + uri); // 요청 URI 출력
	    
	    try {
	        Controller control = mappings.getController(uri);
	        if (control == null) {
	            System.out.println("컨트롤러를 찾을 수 없습니다: " + uri); // 컨트롤러가 null인 경우
	            response.sendError(HttpServletResponse.SC_NOT_FOUND, "요청한 경로를 처리할 컨트롤러가 없습니다.");
	            return;
	        }
	        String callPage = control.handleRequest(request, response);
	        if (callPage != null) {
	            RequestDispatcher dispatcher = request.getRequestDispatcher(callPage);
	            dispatcher.forward(request, response);
	        }
	    } catch(Exception e) {
	        e.printStackTrace();
	        throw new ServletException();
	    }
	}
}