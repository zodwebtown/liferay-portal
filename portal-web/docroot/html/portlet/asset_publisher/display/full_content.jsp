<%
/**
 * Copyright (c) 2000-2009 Liferay, Inc. All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
%>

<%@ include file="/html/portlet/asset_publisher/init.jsp" %>

<%
List results = (List)request.getAttribute("view.jsp-results");

int assetEntryIndex = ((Integer)request.getAttribute("view.jsp-assetEntryIndex")).intValue();

AssetEntry assetEntry = (AssetEntry)request.getAttribute("view.jsp-assetEntry");

String title = (String)request.getAttribute("view.jsp-title");

String className = (String)request.getAttribute("view.jsp-className");
long classPK = ((Long)request.getAttribute("view.jsp-classPK")).longValue();

boolean show = ((Boolean)request.getAttribute("view.jsp-show")).booleanValue();
boolean print = ((Boolean)request.getAttribute("view.jsp-print")).booleanValue();

request.setAttribute("view.jsp-showIconLabel", true);
%>

<div class="asset-full-content <%= showAssetTitle ? "show-asset-title" : "no-title" %>">
	<c:if test="<%= !print %>">
		<liferay-util:include page="/html/portlet/asset_publisher/asset_actions.jsp" />
	</c:if>

	<c:if test="<%= (enableConversions && _isConvertible(className)) || (enablePrint && _isPrintable(className)) || (showAvailableLocales && _isLocalizable(className)) %>">
		<div class="asset-user-actions">
			<c:if test="<%= enablePrint %>">
				<div class="print-action">
					<%@ include file="/html/portlet/asset_publisher/asset_print.jspf" %>
				</div>
			</c:if>

			<c:if test="<%= (enableConversions && _isConvertible(className)) && !print %>">

				<%
				String languageId = LanguageUtil.getLanguageId(request);

				PortletURL exportAssetURL = _createExportURL(className, classPK, languageId, renderResponse, themeDisplay);
				%>

				<div class="export-actions">
					<%@ include file="/html/portlet/asset_publisher/asset_export.jspf" %>
				</div>
			</c:if>
			<c:if test="<%= (showAvailableLocales && _isLocalizable(className)) && !print %>">

				<%
				String languageId = LanguageUtil.getLanguageId(request);

				String[] availableLocales = _getAvailableLocales(className, classPK, languageId, renderResponse, themeDisplay);
				%>

				<c:if test="<%= availableLocales.length > 0 %>">
					<c:if test="<%= enableConversions || enablePrint %>">
						<div class="locale-separator"> </div>
					</c:if>

					<div class="locale-actions">
						<liferay-ui:language languageIds="<%= availableLocales %>" displayStyle="<%= 0 %>" />
					</div>
				</c:if>
			</c:if>
		</div>
	</c:if>

	<c:choose>
		<c:when test="<%= className.equals(BlogsEntry.class.getName()) %>">

			<%
			BlogsEntry entry = BlogsEntryLocalServiceUtil.getEntry(classPK);

			AssetEntryLocalServiceUtil.incrementViewCounter(className, entry.getEntryId());

			if (showContextLink) {
				if (PortalUtil.getPlidFromPortletId(entry.getGroupId(), PortletKeys.BLOGS) == 0) {
					showContextLink = false;
				}
			}

			PortletURL viewFullContentURL = renderResponse.createRenderURL();

			viewFullContentURL.setParameter("struts_action", "/asset_publisher/view_content");
			viewFullContentURL.setParameter("type", AssetPublisherUtil.TYPE_BLOG);

			String urlTitle = entry.getUrlTitle();

			viewFullContentURL.setParameter("urlTitle", urlTitle);

			String viewFullContent = viewFullContentURL.toString();

			viewFullContent = HttpUtil.setParameter(viewFullContent, "redirect", currentURL);
			%>

			<c:if test="<%= showAssetTitle %>">
				<h3 class="asset-title <%= AssetPublisherUtil.TYPE_BLOG %>"><%= title %></h3>
			</c:if>

			<div class="asset-content">
				<%= entry.getContent() %>

				<c:if test="<%= showContextLink && !print %>">
					<div class="asset-more">
						<a href="<%= themeDisplay.getPathMain() %>/blogs/find_entry?noSuchEntryRedirect=<%= HttpUtil.encodeURL(viewFullContent) %>&entryId=<%= entry.getEntryId() %>"><liferay-ui:message key="view-blog" /> &raquo;</a>
					</div>
				</c:if>

				<c:if test="<%= enableRatings %>">
					<liferay-ui:ratings
						className="<%= BlogsEntry.class.getName() %>"
						classPK="<%= entry.getEntryId() %>"
					/>
				</c:if>

				<c:if test="<%= PropsValues.BLOGS_ENTRY_COMMENTS_ENABLED && enableComments %>">
					<br />

					<portlet:actionURL var="discussionURL">
						<portlet:param name="struts_action" value="/asset_publisher/edit_entry_discussion" />
					</portlet:actionURL>

					<liferay-ui:discussion
						formName='<%= "fm" + entry.getEntryId() %>'
						formAction="<%= discussionURL %>"
						className="<%= BlogsEntry.class.getName() %>"
						classPK="<%= entry.getEntryId() %>"
						userId="<%= entry.getUserId() %>"
						subject="<%= entry.getTitle() %>"
						redirect="<%= currentURL %>"
						ratingsEnabled="<%= enableCommentRatings %>"
					/>
				</c:if>
			</div>
		</c:when>
		<c:when test="<%= className.equals(BookmarksEntry.class.getName()) %>">

			<%
			BookmarksEntry entry = BookmarksEntryLocalServiceUtil.getEntry(classPK);

			String entryURL = themeDisplay.getPathMain() + "/bookmarks/open_entry?entryId=" + entry.getEntryId();
			%>

			<c:if test="<%= showAssetTitle %>">
				<h3 class="asset-title <%= AssetPublisherUtil.TYPE_BOOKMARK %>"><%= title %></h3>
			</c:if>

			<div class="asset-content">
				<a href="<%= entryURL %>" target="_blank">
					<c:choose>
						<c:when test="<%= showAssetTitle %>">
							<%= entry.getUrl() %>
						</c:when>
						<c:otherwise>
							<%= entry.getName() %>
						</c:otherwise>
					</c:choose>
				</a>

				<p class="asset-description"><%= entry.getComments() %></p>
			</div>
		</c:when>
		<c:when test="<%= className.equals(DLFileEntry.class.getName()) %>">

			<%
			DLFileEntry fileEntry = DLFileEntryLocalServiceUtil.getFileEntry(classPK);

			PortletURL viewFolderURL = new PortletURLImpl(request, PortletKeys.DOCUMENT_LIBRARY, plid, PortletRequest.RENDER_PHASE);

			viewFolderURL.setWindowState(WindowState.MAXIMIZED);

			viewFolderURL.setParameter("struts_action", "/document_library/view");
			viewFolderURL.setParameter("folderId", String.valueOf(fileEntry.getFolderId()));
			%>

			<c:if test="<%= showAssetTitle %>">
				<h3 class="asset-title <%= AssetPublisherUtil.TYPE_DOCUMENT %>"><%= title %></h3>
			</c:if>

			<div class="asset-content">
				<a href="<%= themeDisplay.getPathMain() %>/document_library/get_file?p_l_id=<%= themeDisplay.getPlid() %>&folderId=<%= fileEntry.getFolderId() %>&name=<%= HttpUtil.encodeURL(fileEntry.getName()) %>">
					<img align="left" border="0" class="dl-file-icon" src="<%= themeDisplay.getPathThemeImages() %>/document_library/<%= DLUtil.getFileExtension(fileEntry.getName()) %>.png" /><%= fileEntry.getTitle() %>
				</a>

				<p class="asset-description"><%= fileEntry.getDescription() %></p>

				<c:if test="<%= showContextLink %>">
					<div class="asset-more">
						<a href="<%= viewFolderURL.toString() %>"><liferay-ui:message key="view-folder" /> &raquo;</a>
					</div>
				</c:if>

				<c:if test="<%= enableRatings %>">
					<br />

					<liferay-ui:ratings
						className="<%= DLFileEntry.class.getName() %>"
						classPK="<%= fileEntry.getFileEntryId() %>"
					/>
				</c:if>

				<c:if test="<%= PropsValues.DL_FILE_ENTRY_COMMENTS_ENABLED && enableComments %>">
					<br />

					<portlet:actionURL var="discussionURL">
						<portlet:param name="struts_action" value="/asset_publisher/edit_file_entry_discussion" />
					</portlet:actionURL>

					<liferay-ui:discussion
						formName='<%= "fm" + fileEntry.getFileEntryId() %>'
						formAction="<%= discussionURL %>"
						className="<%= DLFileEntry.class.getName() %>"
						classPK="<%= fileEntry.getFileEntryId() %>"
						userId="<%= fileEntry.getUserId() %>"
						subject="<%= fileEntry.getTitle() %>"
						redirect="<%= currentURL %>"
					/>
				</c:if>
			</div>
		</c:when>
		<c:when test="<%= className.equals(IGImage.class.getName()) %>">

			<%
			IGImage image = IGImageLocalServiceUtil.getImage(classPK);

			AssetEntryLocalServiceUtil.incrementViewCounter(className, image.getImageId());

			PortletURL viewImageURL = new PortletURLImpl(request, PortletKeys.IMAGE_GALLERY, plid, PortletRequest.RENDER_PHASE);

			viewImageURL.setWindowState(WindowState.MAXIMIZED);

			viewImageURL.setParameter("struts_action", "/image_gallery/view");
			viewImageURL.setParameter("folderId", String.valueOf(image.getFolderId()));
			%>

			<c:if test="<%= showAssetTitle %>">
				<h3 class="asset-title <%= AssetPublisherUtil.TYPE_IMAGE %>"><%= title %></h3>
			</c:if>

			<div class="asset-content">
				<img border="1" src="<%= themeDisplay.getPathImage() %>/image_gallery?img_id=<%= image.getLargeImageId() %>&t=<%= ImageServletTokenUtil.getToken(image.getLargeImageId()) %>" />

				<p class="asset-description"><%= image.getDescription() %></p>

				<c:if test="<%= showContextLink && !print %>">
					<div class="asset-more">
						<a href="<%= viewImageURL.toString() %>"><liferay-ui:message key="view-album" /> &raquo;</a>
					</div>
				</c:if>
			</div>
		</c:when>
		<c:when test="<%= className.equals(JournalArticle.class.getName()) %>">

			<%
			JournalArticleResource articleResource = JournalArticleResourceLocalServiceUtil.getArticleResource(classPK);

			String templateId = (String)request.getAttribute(WebKeys.JOURNAL_TEMPLATE_ID);
			String languageId = LanguageUtil.getLanguageId(request);
			int articlePage = ParamUtil.getInteger(request, "page", 1);
			String xmlRequest = PortletRequestUtil.toXML(renderRequest, renderResponse);

			JournalArticleDisplay articleDisplay = JournalContentUtil.getDisplay(articleResource.getGroupId(), articleResource.getArticleId(), templateId, null, languageId, themeDisplay, articlePage, xmlRequest);

			if (articleDisplay != null) {
				AssetEntryLocalServiceUtil.incrementViewCounter(className, articleDisplay.getResourcePrimKey());
			}
			else {

				// No version has been approved yet, the article should not be rendered

				show = false;
			}
			%>

			<c:if test="<%= articleDisplay != null %>">

				<c:if test="<%= showAssetTitle %>">
					<h3 class="asset-title <%= AssetPublisherUtil.TYPE_CONTENT %>"><%= title %></h3>
				</c:if>

				<div class="asset-content">
					<div class="journal-content-article">
						<%= articleDisplay.getContent() %>
					</div>

					<c:if test="<%= articleDisplay.isPaginate() %>">

						<%
						String pageRedirect = ParamUtil.getString(request, "redirect");

						if (Validator.isNull(pageRedirect)) {
							pageRedirect = currentURL;
						}

						int cur = ParamUtil.getInteger(request, "cur");

						PortletURL articlePageURL = renderResponse.createRenderURL();

						articlePageURL.setParameter("struts_action", "/asset_publisher/view_content");
						articlePageURL.setParameter("redirect", pageRedirect);
						articlePageURL.setParameter("urlTitle", articleDisplay.getUrlTitle());
						articlePageURL.setParameter("cur", String.valueOf(cur));
						%>

						<br />

						<liferay-ui:page-iterator
							cur="<%= articleDisplay.getCurrentPage() %>"
							curParam="page"
							delta="<%= 1 %>"
							maxPages="<%= 25 %>"
							total="<%= articleDisplay.getNumberOfPages() %>"
							type="article"
							url="<%= articlePageURL.toString() %>"
						/>

						<br />
					</c:if>

					<c:if test="<%= enableRatings %>">
						<br />

						<liferay-ui:ratings
							className="<%= JournalArticle.class.getName() %>"
							classPK="<%= articleDisplay.getResourcePrimKey() %>"
						/>
					</c:if>

					<c:if test="<%= PropsValues.JOURNAL_ARTICLE_COMMENTS_ENABLED && enableComments %>">
						<br />

						<portlet:actionURL var="discussionURL">
							<portlet:param name="struts_action" value="/asset_publisher/edit_article_discussion" />
						</portlet:actionURL>

						<liferay-ui:discussion
							formName='<%= "fm" + articleDisplay.getResourcePrimKey() %>'
							formAction="<%= discussionURL %>"
							className="<%= JournalArticle.class.getName() %>"
							classPK="<%= articleDisplay.getResourcePrimKey() %>"
							userId="<%= articleDisplay.getUserId() %>"
							subject="<%= articleDisplay.getTitle() %>"
							redirect="<%= currentURL %>"
						/>
					</c:if>
				</c:if>
			</div>
		</c:when>
		<c:when test="<%= className.equals(MBMessage.class.getName()) %>">

			<%
			MBMessage message = MBMessageLocalServiceUtil.getMessage(classPK);

			AssetEntryLocalServiceUtil.incrementViewCounter(className, message.getMessageId());

			if (showContextLink) {
				if (PortalUtil.getPlidFromPortletId(message.getCategory().getGroupId(), PortletKeys.MESSAGE_BOARDS) == 0) {
					showContextLink = false;
				}
			}
			%>

			<c:if test="<%= showAssetTitle %>">
				<h3 class="asset-title <%= AssetPublisherUtil.TYPE_THREAD %>"><%= title %></h3>
			</c:if>

			<div class="asset-content">
				<%= message.getBody() %>

				<c:if test="<%= showContextLink %>">
					<div class="asset-more">
						<a href="<%= themeDisplay.getPathMain() %>/message_boards/find_message?messageId=<%= message.getMessageId() %>"><liferay-ui:message key="view-thread" /> &raquo;</a>
					</div>
				</c:if>
			</div>
		</c:when>
		<c:when test="<%= className.equals(WikiPage.class.getName()) %>">

			<%
			WikiPageResource pageResource = WikiPageResourceLocalServiceUtil.getPageResource(classPK);

			WikiPage wikiPage = WikiPageLocalServiceUtil.getPage(pageResource.getNodeId(), pageResource.getTitle());

			AssetEntryLocalServiceUtil.incrementViewCounter(className, wikiPage.getResourcePrimKey());
			%>

			<c:if test="<%= showAssetTitle %>">
				<h3 class="asset-title <%= AssetPublisherUtil.TYPE_WIKI %>"><%= title %></h3>
			</c:if>

			<div class="asset-content">
				<div class="content-body">

					<%
					if (showContextLink) {
						WikiNode node = WikiNodeLocalServiceUtil.getNode(pageResource.getNodeId());

						if (PortalUtil.getPlidFromPortletId(node.getGroupId(), PortletKeys.WIKI) == 0) {
							showContextLink = false;
						}
					}

					try {
						PortletURL viewPageURL = new PortletURLImpl(request, PortletKeys.WIKI, plid, PortletRequest.ACTION_PHASE);

						viewPageURL.setPortletMode(PortletMode.VIEW);

						viewPageURL.setParameter("struts_action", "/wiki/view");

						PortletURL editPageURL = new PortletURLImpl(request, PortletKeys.WIKI, plid, PortletRequest.ACTION_PHASE);

						editPageURL.setPortletMode(PortletMode.VIEW);

						editPageURL.setParameter("struts_action", "/wiki/edit_page");

						String attachmentURLPrefix = themeDisplay.getPathMain() + "/wiki/get_page_attachment?p_l_id=" + themeDisplay.getPlid() + "&nodeId=" + wikiPage.getNodeId() + "&title=" + HttpUtil.encodeURL(wikiPage.getTitle()) + "&fileName=";

						WikiPageDisplay pageDisplay = WikiCacheUtil.getDisplay(wikiPage.getNodeId(), wikiPage.getTitle(), viewPageURL, editPageURL, attachmentURLPrefix);
					%>

						<%= pageDisplay.getFormattedContent() %>

					<%
					}
					catch (Exception e) {
						_log.error("Error formatting the wiki page " + wikiPage.getPageId() + " with the format " + wikiPage.getFormat(), e);
					%>

						<%= LanguageUtil.get(pageContext, "error-formatting-the-page") %>

					<%
					}
					%>

					<c:if test="<%= showContextLink && !print %>">
						<div class="asset-more">
							<a href="<%= themeDisplay.getURLPortal() + themeDisplay.getPathMain() + "/wiki/find_page?pageResourcePrimKey=" + wikiPage.getResourcePrimKey() %>"><liferay-ui:message key="view-wiki" /> &raquo;</a>
						</div>
					</c:if>

				</div>

				<c:if test="<%= PropsValues.WIKI_PAGE_COMMENTS_ENABLED && enableComments %>">
					<br />

					<portlet:actionURL var="discussionURL">
						<portlet:param name="struts_action" value="/asset_publisher/edit_page_discussion" />
					</portlet:actionURL>

					<liferay-ui:discussion
						formName='<%= "fm" + wikiPage.getResourcePrimKey() %>'
						formAction="<%= discussionURL %>"
						className="<%= WikiPage.class.getName() %>"
						classPK="<%= wikiPage.getResourcePrimKey() %>"
						userId="<%= wikiPage.getUserId() %>"
						subject="<%= wikiPage.getTitle() %>"
						redirect="<%= currentURL %>"
					/>
				</c:if>
			</div>
		</c:when>
		<c:otherwise>
			<%= className %> is not a valid type.
		</c:otherwise>
	</c:choose>

	<c:if test="<%= show %>">
		<div class="asset-metadata">
			<%@ include file="/html/portlet/asset_publisher/asset_metadata.jspf" %>
		</div>
	</c:if>
</div>

<c:choose>
	<c:when test="<%= !showAssetTitle && ((assetEntryIndex + 1) < results.size()) %>">
		<div class="separator"><!-- --></div>
	</c:when>
	<c:when test="<%= (assetEntryIndex + 1) == results.size() %>">
		<div class="final-separator"><!-- --></div>
	</c:when>
</c:choose>

<%!
private PortletURL _createExportURL(String className, long classPK, String languageId, RenderResponse renderResponse, ThemeDisplay themeDisplay) throws Exception {
	PortletURL portletURL = renderResponse.createActionURL();

	if (Validator.equals(className, JournalArticle.class.getName())) {
		JournalArticleResource articleResource = JournalArticleResourceLocalServiceUtil.getArticleResource(classPK);
		JournalArticleDisplay articleDisplay = JournalContentUtil.getDisplay(articleResource.getGroupId(), articleResource.getArticleId(), null, null, languageId, themeDisplay);

		portletURL.setParameter("struts_action", "/asset_publisher/export_journal_article");
		portletURL.setParameter("groupId", String.valueOf(articleDisplay.getGroupId()));
		portletURL.setParameter("articleId", articleDisplay.getArticleId());
	}

	else if (className.equals(WikiPage.class.getName())) {
		WikiPageResource pageResource = WikiPageResourceLocalServiceUtil.getPageResource(classPK);
		WikiPage wikiPage = WikiPageLocalServiceUtil.getPage(pageResource.getNodeId(), pageResource.getTitle());

		portletURL.setParameter("struts_action", "/asset_publisher/export_wiki_page");
		portletURL.setParameter("nodeId", String.valueOf(wikiPage.getNodeId()));
		portletURL.setParameter("title", wikiPage.getTitle());
	}

	return portletURL;
}

private String[] _getAvailableLocales(String className, long classPK, String languageId, RenderResponse renderResponse, ThemeDisplay themeDisplay) throws Exception {
	if (Validator.equals(className, JournalArticle.class.getName())) {
		JournalArticleResource articleResource = JournalArticleResourceLocalServiceUtil.getArticleResource(classPK);
		JournalArticleDisplay articleDisplay = JournalContentUtil.getDisplay(articleResource.getGroupId(), articleResource.getArticleId(), null, null, languageId, themeDisplay);

		return articleDisplay.getAvailableLocales();
	}

	return null;
}

private boolean _isConvertible(String className) {
	if (Validator.equals(className, JournalArticle.class.getName()) || Validator.equals(className, WikiPage.class.getName())) {
		return true;
	}
	else {
		return false;
	}
}

private boolean _isLocalizable(String className) {
	if (Validator.equals(className, JournalArticle.class.getName())) {
		return true;
	}
	else {
		return false;
	}
}

private boolean _isPrintable(String className) {
	if (!Validator.equals(className, MBMessage.class.getName()) && !Validator.equals(className, DLFileEntry.class.getName())) {
		return true;
	}
	else {
		return false;
	}
}

private static Log _log = LogFactoryUtil.getLog("portal-web.docroot.html.portlet.asset_publisher.display_full_content.jsp");
%>