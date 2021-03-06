package ${configYAML.apiPackagePath}.internal.resource;

import ${configYAML.apiPackagePath}.dto.${schemaName};
import ${configYAML.apiPackagePath}.dto.${schemaName}Collection;
import ${configYAML.apiPackagePath}.resource.${schemaName}Resource;

import com.liferay.portal.vulcan.context.Pagination;

import java.util.Collections;

import javax.annotation.Generated;

import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.ServiceScope;
import org.osgi.service.jaxrs.whiteboard.JaxrsWhiteboardConstants;

/**
 * @author ${configYAML.author}
 * @generated
 */
@Component(
	property = {
		JaxrsWhiteboardConstants.JAX_RS_APPLICATION_SELECT + "=(osgi.jaxrs.name=${configYAML.application.name}.rest)",
		JaxrsWhiteboardConstants.JAX_RS_RESOURCE + "=true", "api.version=${openAPIYAML.info.version}"
	},
	scope = ServiceScope.PROTOTYPE, service = ${schemaName}Resource.class)
@Generated("")
public class ${schemaName}ResourceImpl implements ${schemaName}Resource {

	@Override
	public ${schemaName}Collection<${schemaName}> get${schemaName}Collection(Pagination pagination, String size)
		throws Exception {

		return new ${schemaName}Collection(Collections.emptyList(), 0);
	}

}