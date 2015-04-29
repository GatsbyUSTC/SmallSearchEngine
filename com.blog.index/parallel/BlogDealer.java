package parallel;

public class BlogDealer {
	public static Blog dealblog(StringBuffer stringBuffer){
		int start = stringBuffer.indexOf("<!-- ���Ŀ�ʼ -->");
		if (start == -1)
			return null;
		int end = stringBuffer.indexOf("<!-- ���Ľ��� -->", start);
		if (end == -1)
			return null;
		String content = PassHtmlUtils.filterHtml(stringBuffer.substring(
				start, end));
		content = content.replaceAll(" ", "");
		content = content.replaceAll("	", "");
		content = content.replaceAll("&nbsp;", "");
		if ((start = stringBuffer.indexOf("<title>")) == -1)
			return null;
		if ((end = stringBuffer.indexOf("</title>", start)) == -1) 
			return null;
		String title = stringBuffer.substring(start + 7, end);
		return new Blog(title, null, content);
	}
}
