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

package com.liferay.headless.workflow.dto;

import com.liferay.portal.vulcan.collection.BaseCollection;

import java.util.Collection;
import java.util.Collections;

import javax.annotation.Generated;

import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlSeeAlso;

/**
 * @author Javier Gamarra
 * @generated
 */
@Generated("")
@XmlRootElement(name = "collection")
@XmlSeeAlso({WorkflowLog.class})
public class WorkflowLogCollection<T> extends BaseCollection<T> {

	public WorkflowLogCollection() {
		setItems(Collections.emptyList());
		setTotalCount(0);
	}

	public WorkflowLogCollection(Collection<T> items, int totalCount) {
		setItems(items);
		setTotalCount(totalCount);
	}

}