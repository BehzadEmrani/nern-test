<%@ page import="com.atrosys.dao.AdminDAO" %>
<%@ page import="com.atrosys.dao.FeedBackDAO" %>
<%@ page import="com.atrosys.entity.Admin" %>
<%@ page import="com.atrosys.model.AdminAccessType" %>
<%@ page import="com.atrosys.model.AdminSessionInfo" %>
<%@ page import="com.atrosys.model.AdminSubAccessType" %>
<%
    AdminSessionInfo adminSessionInfo = new AdminSessionInfo(session);
    Admin admin = adminSessionInfo.getAdmin();
    if (!AdminDAO.checkAdminSubAccess(admin.getId(), AdminAccessType.SEND_FEED_BACK.getValue(), AdminSubAccessType.READ.getValue())) {
        response.sendError(403);
        return;
    }

    response.setContentType("application/force-download");
    response.setContentLength(-1);
    response.setHeader("Content-Transfer-Encoding", "binary");
    response.setHeader("Content-Disposition", "attachment;");

    ServletOutputStream servletOutputStream = response.getOutputStream();

    long feedBackId = Long.valueOf(request.getParameter("id"));
    byte[] fileContents = FeedBackDAO.findFeedBackFileById(feedBackId);
    servletOutputStream.write(fileContents);
    servletOutputStream.flush();
    servletOutputStream.close();
%>