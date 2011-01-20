<%--

    Licensed to Jasig under one or more contributor license
    agreements. See the NOTICE file distributed with this work
    for additional information regarding copyright ownership.
    Jasig licenses this file to you under the Apache License,
    Version 2.0 (the "License"); you may not use this file
    except in compliance with the License. You may obtain a
    copy of the License at:

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing,
    software distributed under the License is distributed on
    an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
    KIND, either express or implied. See the License for the
    specific language governing permissions and limitations
    under the License.

--%>

<%@ taglib prefix="editPortlet" tagdir="/WEB-INF/tags/edit-portlet" %>
<%@ include file="/WEB-INF/jsp/include.jsp" %>

<!-- START: VALUES BEING PASSED FROM BACKEND -->
<portlet:actionURL var="queryUrl">
	<portlet:param name="execution" value="${flowExecutionKey}" />
</portlet:actionURL>
<!-- END: VALUES BEING PASSED FROM BACKEND -->

<c:set var="defaultLength" value="10"/>
<c:set var="defaultMaxLength" value="20"/>
<c:set var="defaultTextCols" value="40"/>
<c:set var="defaultTextRows" value="10"/>

<!--
PORTLET DEVELOPMENT STANDARDS AND GUIDELINES
| For the standards and guidelines that govern
| the user interface of this portlet
| including HTML, CSS, JavaScript, accessibilty,
| naming conventions, 3rd Party libraries
| (like jQuery and the Fluid Skinning System)
| and more, refer to:
| http://www.ja-sig.org/wiki/x/cQ
-->
    
<!-- Portlet -->
<div class="fl-widget portlet ptl-mgr view-setparameters" role="section">

  <!-- Portlet Titlebar -->
  <div class="fl-widget-titlebar titlebar portlet-titlebar" role="sectionhead">
  	<h2 class="title" role="heading">
        <spring:message code="${ completed ? 'edit.portlet' : 'register.new.portlet' }"/>
    </h2>
  </div> <!-- end: portlet-titlebar -->
  
  <!-- Portlet Content -->
  <div class="fl-widget-content content portlet-content" role="main">

    <form:form modelAttribute="portlet" action="${queryUrl}" method="POST">

    <!-- Portlet Messages -->
    <spring:hasBindErrors name="portlet">
      <div class="portlet-msg-error portlet-msg error" role="alert">
        <form:errors path="*" element="div"/>
      </div> <!-- end: portlet-msg -->
    </spring:hasBindErrors>
          
    <!-- Add a note to the page if the portle supports config mode  -->
    <c:if test="${supportsConfig}">
      <div class="portlet-msg-info portlet-msg info" role="alert">
        <spring:message code="this.portlet.supports.rich.config.message"/>
      </div>
    </c:if>
    
    <!-- Portlet Section -->
    <c:if test="${ portlet.portlet }">
      <div class="portlet-section" role="region">
        <div class="titlebar">
          <h3 class="title" role="heading"><spring:message code="portlet.xml.preferences"/></h3>
        </div>
        <div class="content">
          <p class="note" role="note"><spring:message code="default.preferences.provided.by.portlet.descriptor"/></p>
          <table>
            <thead>
              <tr>
                <th><spring:message code="preference"/></th>
                <th><spring:message code="values"/></th>
                <th><spring:message code="user.editable"/></th>
              </tr>
            </thead>
            <tbody>
              <c:forEach items="${ portlet.portletPreferences.portletPreferences }" var="pref">
                <tr>
                  <td class="preference-name">${ fn:escapeXml(pref.name )}</td>
                  <td>
                    <c:forEach var="value" items="${ fn:escapeXml(pref.values )}">
                        <div>${ fn:escapeXml(value )}</div>
                    </c:forEach>
                  </td>
                  <td>${ fn:escapeXml(!pref.readOnly )}</td>
                </tr>
              </c:forEach>
            </tbody>
          </table>
        </div>
      </div> <!-- end: porltet-section -->
    </c:if>

    <!-- Step Loop -->
    <c:forEach items="${ cpd.params.steps }" var="step"  varStatus="status">
    
      <!-- Portlet Section -->
      <div class="portlet-section" role="region">
        <div class="titlebar">
          <h3 class="title" role="heading">${ fn:escapeXml(step.name )}</h3>
        </div>
        <div class="content">
          <p class="note" role="note">${ fn:escapeXml(step.description )}</p>
          
          <!-- Portlet Parameters -->
          <c:if test="${ fn:length(step.parameters) > 0 }">
            <table class="portlet-table" summary="<spring:message code="this.table.lists.portlet.parameters"/>">
              <thead>
                <tr>
                  <th><spring:message code="parameter"/></th>
                  <th><spring:message code="value"/></th>
                  <th><spring:message code="user.editable"/></th>
                </tr>
              </thead>
              <tbody>
                <c:forEach items="${ step.parameters }" var="parameter">
                  <c:if test="${ parameter.modify != 'subscribeOnly' }">
                    <c:choose>
                      <c:when test="${ fn:startsWith(parameter.name, 'PORTLET.') }">
                         <c:set var="paramName" value="${ fn:replace(parameter.name, 'PORTLET.', '') }"/>
                         <c:set var="paramPath" value="portletPreferences['${ paramName }'].value"/>
                         <c:set var="overrideParamPath" value="portletPreferencesOverrides['${ paramName }'].value"/>
                      </c:when>
                      <c:otherwise>
                      <c:set var="paramPath" value="parameters['${ parameter.name }'].value"/>
                      <c:set var="overrideParamPath" value="parameterOverrides['${ parameter.name }'].value"/>
                      </c:otherwise>
                    </c:choose>
                    <c:choose>
                      <c:when test="${ parameter.type.display == 'hidden' }">
                        <form:hidden path="${paramPath}"/>
                      </c:when>
                      <c:otherwise>
                        <tr>
                          <td><span class="uportal-label">${ fn:escapeXml(parameter.label )}:</span></td>
                          <td>
                            <c:choose>
                              <c:when test="${ fn:startsWith(parameter.name, 'PORTLET.') }">
                                <editPortlet:parameterInput parameterType="${ parameter.type }" 
                                  parameterPath="${ paramPath }" parameterName="${ paramName }" 
                                  parameterValues="${ portlet.portletPreferences[paramName].value }"/>
                              </c:when>
                              <c:otherwise>
                              <editPortlet:parameterInput parameterType="${ parameter.type }" 
                                parameterPath="${ paramPath }"/>
                              </c:otherwise>
                            </c:choose>
                          </td>
                          <td>
                            <c:if test="${ parameter.modify != 'publish-only' }">
                              <form:checkbox path="${overrideParamPath}" value="true"/>
                            </c:if>
                          </td>
                        </tr>
                      </c:otherwise>
                    </c:choose>
                  </c:if>
                </c:forEach>
              </tbody>
            </table>        
          </c:if> <!-- End Portlet Parameters -->
  
          <c:if test="${ portlet.portlet }">
            <c:if test="${ fn:length(step.preferences) > 0 }">
              <div class="preference-options-section">
                <table class="portlet-table" summary="<spring:message code="this.table.lists.portlet.parameters"/>">
                  <thead>
                    <tr>
                      <th><spring:message code="parameter"/></th>
                      <th><spring:message code="value"/></th>
                      <th><spring:message code="user.editable"/></th>
                    </tr>
                  </thead>
                  <tbody>
                    <c:forEach items="${ step.preferences }" var="parameter">
                      <c:if test="${ parameter.modify != 'subscribeOnly' }">
                        <c:set var="paramPath" value="portletPreferences['${ parameter.name }'].value"/>
                        <c:set var="overrideParamPath" value="portletPreferencesOverrides['${ parameter.name }'].value"/>
                        <c:choose>
                          <c:when test="${ parameter.type.display == 'hidden' }">
                            <c:set var="values" value="${ portlet.portletPreferences[parameter.name].value }"/>
                            <input type="hidden" name="${ fn:escapeXml(paramPath )}" value="${ fn:escapeXml(fn:length(values) > 0 ? values[0] : '' )}"/>
                          </c:when>
                          <c:otherwise>
                            <tr>
                              <td class="preference-name"><span class="uportal-label">${ fn:escapeXml(parameter.label )}:</span></td>
                              <td>
                                    <editPortlet:parameterInput parameterType="${ parameter.type }" 
                                      parameterPath="${ paramPath }" parameterName="${ parameter.name }" 
                                      parameterValues="${ portlet.portletPreferences[parameter.name].value }"/>
                              </td>
                              <td>
                              <c:if test="${ parameter.modify != 'publish-only' }">
                                <form:checkbox path="${overrideParamPath}" value="true"/>
                              </c:if>
                            </td>
                            </tr>
                          </c:otherwise>
                        </c:choose>
                      </c:if>
                    </c:forEach>
                  </tbody>
                </table>
              </div>   
            </c:if>
          </c:if> <!-- End Portlet Preferences -->
                      
                      
          <!-- Other Parameters Loop -->
          <c:forEach items="${ step.arbitraryParameters }" var="arbitraryParam">
            <c:forEach items="${ arbitraryParam.paramNamePrefixes }" var="prefix">
            
              <div class="parameter-options-section" prefix="${ fn:escapeXml(prefix )}" dialog="${status.index}-params-${fn:escapeXml(prefix)}">
                <table class="portlet-table">
                  <thead>
                    <tr>
                      <th><spring:message code="preference"/></th>
                      <th><spring:message code="value"/></th>
                      <th><spring:message code="user.editable"/></th>
                      <th></th>
                    </tr>
                  </thead>
                  <tbody>
                    <c:forEach items="${ portlet.parameters }" var="portletParam">
                      <c:if test="${ fn:startsWith(portletParam.key, prefix) }">
                      <c:set var="paramPath" value="parameters['${ portletParam.key }'].value"/>
                      <c:set var="overrideParamPath" value="parameterOverrides['${ portletParam.key }'].value"/>
                        <tr>
                          <td>${ fn:escapeXml(fn:substringAfter(portletParam.key, prefix) )}</td>
                          <td><form:input path="${ paramPath }"/></td>
                          <td>
                              <form:checkbox path="${overrideParamPath}" value="true"/>
                          </td>
                          <td><a class="delete-parameter-link" href="javascript:;"><spring:message code="remove"/></a></td>
                        </tr>
                      </c:if>
                    </c:forEach>
                  </tbody>
                </table> 
                <p><a class="add-parameter-link" href="javascript:;"><spring:message code="add.parameter"/></a></p>
              </div>
            </c:forEach>
          </c:forEach> <!-- End Other Parameters Loop -->
        
          <!-- Other Preferences -->
          <c:if test="${ step.arbitraryPreferences }">
            <div class="preference-options-section" dialog="${ fn:escapeXml(status.index )}-prefs">
              <table class="portlet-table">
                <thead>
                  <tr>
                    <th><spring:message code="preference"/></th>
                    <th><spring:message code="values"/></th>
                    <th><spring:message code="user.editable"/></th>
                    <th></th>
                  </tr>
                </thead>
                <tbody>
                  <c:forEach items="${ arbitraryPreferenceNames }" var="name">
                    <c:set var="paramPath" value="portletPreferences['${ name }'].value"/>
                    <c:set var="overrideParamPath" value="portletPreferencesOverrides['${ name }'].value"/>
                      <tr>
                        <td class="preference-name">${ fn:escapeXml(name )}</td>
                        <td>
                            <c:forEach items="${ portlet.portletPreferences[name].value }" var="val">
                             <div>
                                 <input name="portletPreferences['${fn:escapeXml(name)}'].value" value="${ fn:escapeXml(val )}" />
                                 <a class="delete-parameter-value-link" href="javascript:;"><spring:message code="remove"/></a>
                                </div>
                            </c:forEach>
                            <a class="add-parameter-value-link" href="javascript:;" paramName="${fn:escapeXml(name)}"><spring:message code="add.value"/></a>
                        </td>
                        <td>
                            <form:checkbox path="${overrideParamPath}" value="true"/>
                        </td>
                        <td><a class="delete-parameter-link" href="javascript:;"><spring:message code="remove"/></a></td>
                      </tr>
                  </c:forEach>
                </tbody>
              </table> 
              <p><a class="add-parameter-link" href="javascript:;"><spring:message code="add.preference"/></a></p>
            </div>
          </c:if> <!-- End Other Preferences -->
        
        </div> <!-- end: content -->
          
      </div> <!-- end: portlet-section -->
    
    </c:forEach> <!-- End Step Loop -->

    <!-- Buttons -->    
    <div class="buttons">
      <c:choose>
        <c:when test="${ completed }">
          <input class="button primary" type="submit" value="<spring:message code="review"/>" name="_eventId_review"/>
        </c:when>
        <c:otherwise>
          <input class="button" type="submit" value="<spring:message code="back"/>" class="secondary" name="_eventId_back"/>
          <input class="button primary" type="submit" value="<spring:message code="next"/>" name="_eventId_next"/>
        </c:otherwise>
      </c:choose>
      <input class="button" type="submit" value="<spring:message code="cancel"/>" name="_eventId_cancel"/>
    </div>
    
    </form:form> <!-- End Form -->

    <div style="display:none">
        <c:forEach items="${ cpd.params.steps }" var="step" varStatus="status">
            <c:forEach items="${ step.arbitraryParameters }" var="arbitraryParam">
                <c:forEach items="${ arbitraryParam.paramNamePrefixes }" var="prefix">
                    <div id="${n}addParameterDialog-${status.index}-params-${fn:escapeXml(prefix)}" class="parameter-adding-dialog jqueryui" title="<spring:message code="add.parameter"/>">
                        <form action="javascript:;">
                            <p><spring:message code="parameter.name"/>: <input name="name"/></p>
                            <input type="submit" value="<spring:message code="add"/>"/>
                        </form>
                    </div>
                </c:forEach>
            </c:forEach>
            <c:if test="${ step.arbitraryPreferences }">
                <div id="${n}addParameterDialog-${status.index}-prefs" class="parameter-adding-dialog jqueryui" title="<spring:message code="add.preference"/>">
                    <form action="javascript:;">
                        <p><spring:message code="preference.name"/>: <input name="name"/></p>
                        <input type="submit" value="<spring:message code="add"/>"/>
                    </form>
                </div>
            </c:if>
        </c:forEach>
    </div>
    
  </div> <!-- end: portlet-content -->
  
</div> <!-- end: portlet -->

<script type="text/javascript">
	up.jQuery(function() {
			var $ = up.jQuery;
			  $(document).ready(function(){
				  $("div.parameter-options-section").each(function(){
					  up.ParameterEditor(this, {
					        parameterNamePrefix: $(this).attr("prefix"),
					        parameterBindName: 'parameters',
					        auxiliaryBindName: 'parameterOverrides',
                            useAuxiliaryCheckbox: true,
					        dialog: $("#${n}addParameterDialog-" + $(this).attr("dialog")),
                            multivalued: false,
                            messages: {
                              remove: '<spring:message code="remove"/>',
                              addValue: '<spring:message code="add.value"/>'
                            }
					      }
					  );
			      });
                  $("div.preference-options-section").each(function(){
                      up.ParameterEditor(this, {
                            parameterBindName: 'portletPreferences',
                            auxiliaryBindName: 'portletPreferencesOverrides',
                            useAuxiliaryCheckbox: true,
                            dialog: $("#${n}addParameterDialog-" + $(this).attr("dialog")),
                            multivalued: true,
                            messages: {
                              remove: '<spring:message code="remove"/>',
                              addValue: '<spring:message code="add.value"/>'
                            }
                          }
                      );
                  });
			  });
	});
</script>