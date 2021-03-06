<%@page import="java.util.concurrent.Executors"%>
<%@page import="java.util.concurrent.ExecutorService"%>
<%@page import="org.apache.lucene.document.Document"%>
<%@page import="org.apache.lucene.queryparser.classic.ParseException"%>
<%@page import="java.io.IOException"%>
<%@page import="org.apache.lucene.search.ScoreDoc"%>
<%@page import="org.apache.lucene.search.TopDocs"%>
<%@page import="org.apache.lucene.search.Query"%>
<%@page import="org.apache.lucene.queryparser.classic.MultiFieldQueryParser"%>
<%@page import="org.apache.lucene.analysis.standard.StandardAnalyzer"%>
<%@page import="org.apache.lucene.analysis.Analyzer"%>
<%@page import="org.apache.lucene.search.IndexSearcher"%>
<%@page import="java.nio.file.Paths"%>
<%@page import="org.apache.lucene.store.FSDirectory"%>
<%@page import="org.apache.lucene.index.DirectoryReader"%>
<%@page import="org.apache.lucene.index.IndexReader"%>
<%@page import="directSearch.BlogSearcher"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html">
<title>One World, One Dream</title>
<style type="text/css">
.highlight{
	color:red;
	font-weight:600;
}
#title{
	font-size:large;
	color:blue;
	text-decoration:underline;
}
</style>
</head>

<body>
<form method="get">
<table align="center">
<tr><td><input type="text" name="queryString" style="width:300px;height:30px;font-size:25px"></td>
	<td><input type="submit" style="width:150px;height:30px;font-size:20px" value="Search"></td></tr>
</table>
</form>
 <%
	String queryString = request.getParameter("queryString");
 	if(queryString != null && !queryString.equals("")){
 		final int contentlen = 300;
	 	final String indexPath = "C:/Users/Gatsby/Documents/LuceneIndex";
	 	final String[] fields = { "title", "content" };
		try {
			long startt = System.currentTimeMillis();
			IndexReader reader = DirectoryReader.open(FSDirectory.open(Paths.get(indexPath)));
			IndexSearcher searcher = new IndexSearcher(reader);
		 	Analyzer analyzer = new StandardAnalyzer();
			MultiFieldQueryParser parser = new MultiFieldQueryParser(fields, analyzer);
			Query query = parser.parse(queryString);
			TopDocs topDocs = searcher.search(query, 100);
			long endt = System.currentTimeMillis();
			ScoreDoc[] hits = topDocs.scoreDocs;
			int hitNum = topDocs.totalHits < 100 ? topDocs.totalHits : 100;
			out.println("<p> finding " +topDocs.totalHits+ " results in " +(endt-startt)+ " miliseconds</p>");
			String[] keys = queryString.split(" ");
			for (int i = 0; i < hitNum; i++) {
				Document doc = searcher.doc(hits[i].doc);
				String title = doc.get("title");
				String content = doc.get("content");
				if(content.length() > contentlen){
					int temp = content.length();
					int before = contentlen/3;
					int after = contentlen - before;
					int loc = content.indexOf(keys[0]);
					int start = loc > before ? (loc-before):0;
					int end = (loc+after) > content.length() ? content.length():(loc+after);
					content = content.substring(start, end);
					content = start > 0 ? "...".concat(content) : content;
					content = end < temp ? content.concat("..."):content;
				}
				for(String s : keys){
					title = title.replaceAll(s, "<span class = highlight>" + s + "</span>");
					content = content.replaceAll(s, "<span class = highlight>" + s + "</span>");
				}
				out.println("<p> <div id=title>" +title+ "</div> <br>");
				out.println( content+ "</p>");
				}
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
 	}
 %>
</body>
</html>