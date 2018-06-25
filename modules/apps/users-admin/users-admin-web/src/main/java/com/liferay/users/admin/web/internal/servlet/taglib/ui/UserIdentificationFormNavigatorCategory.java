/**
 * Copyright (c) 2000-present Liferay, Inc. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */

package com.liferay.users.admin.web.internal.servlet.taglib.ui;

import com.liferay.portal.kernel.language.LanguageUtil;
import com.liferay.portal.kernel.servlet.taglib.ui.FormNavigatorCategory;
import com.liferay.portal.kernel.servlet.taglib.ui.FormNavigatorConstants;

import java.util.Locale;

/**
 * @author     Sergio González
 * @deprecated As of Judson, with no direct replacement
 */
@Deprecated
public class UserIdentificationFormNavigatorCategory
	implements FormNavigatorCategory {

	@Override
	public String getFormNavigatorId() {
		return FormNavigatorConstants.FORM_NAVIGATOR_ID_USERS;
	}

	@Override
	public String getKey() {
		return FormNavigatorConstants.CATEGORY_KEY_USER_IDENTIFICATION;
	}

	@Override
	public String getLabel(Locale locale) {
		return LanguageUtil.get(locale, "identification");
	}

}