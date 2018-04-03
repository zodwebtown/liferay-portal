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

package com.liferay.message.boards.uad.aggregator;

import com.liferay.message.boards.model.MBThread;
import com.liferay.message.boards.service.MBThreadLocalService;
import com.liferay.message.boards.uad.constants.MBUADConstants;

import com.liferay.portal.kernel.dao.orm.DynamicQuery;
import com.liferay.portal.kernel.exception.PortalException;

import com.liferay.user.associated.data.aggregator.DynamicQueryUADEntityAggregator;
import com.liferay.user.associated.data.aggregator.UADEntityAggregator;

import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;

import java.io.Serializable;

import java.util.List;

/**
 * @author Brian Wing Shun Chan
 * @generated
 */
@Component(immediate = true, property =  {
	"model.class.name=" + MBUADConstants.CLASS_NAME_MB_THREAD}, service = UADEntityAggregator.class)
public class MBThreadUADEntityAggregator extends DynamicQueryUADEntityAggregator<MBThread> {
	@Override
	public String getApplicationName() {
		return MBUADConstants.APPLICATION_NAME;
	}

	@Override
	public MBThread getEntity(Serializable entityId) throws PortalException {
		return _mbThreadLocalService.getMBThread(Long.valueOf(
				entityId.toString()));
	}

	@Override
	protected long doCount(DynamicQuery dynamicQuery) {
		return _mbThreadLocalService.dynamicQueryCount(dynamicQuery);
	}

	@Override
	protected DynamicQuery doGetDynamicQuery() {
		return _mbThreadLocalService.dynamicQuery();
	}

	@Override
	protected List<MBThread> doGetEntities(DynamicQuery dynamicQuery,
		int start, int end) {
		return _mbThreadLocalService.dynamicQuery(dynamicQuery, start, end);
	}

	@Override
	protected String[] doGetUserIdFieldNames() {
		return MBUADConstants.USER_ID_FIELD_NAMES_MB_THREAD;
	}

	@Reference
	private MBThreadLocalService _mbThreadLocalService;
}