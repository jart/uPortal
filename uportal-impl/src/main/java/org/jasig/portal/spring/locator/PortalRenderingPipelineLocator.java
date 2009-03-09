/**
 * Copyright (c) 2000-2009, Jasig, Inc.
 * See license distributed with this file and available online at
 * https://www.ja-sig.org/svn/jasig-parent/tags/rel-10/license-header.txt
 */
package org.jasig.portal.spring.locator;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.jasig.portal.rendering.IPortalRenderingPipeline;
import org.jasig.portal.spring.PortalApplicationContextLocator;
import org.springframework.context.ApplicationContext;

/**
 * @author Eric Dalquist
 * @version $Revision$
 * @deprecated code that needs an IPortalRenderingPipeline should use direct dependency injection where possible
 */
@Deprecated
public class PortalRenderingPipelineLocator extends AbstractBeanLocator<IPortalRenderingPipeline> {
    public static final String BEAN_NAME = "portalRenderingPipeline";
    
    private static final Log LOG = LogFactory.getLog(PortalRenderingPipelineLocator.class);
    private static AbstractBeanLocator<IPortalRenderingPipeline> locatorInstance;

    public static IPortalRenderingPipeline getPortalRenderingPipeline() {
        AbstractBeanLocator<IPortalRenderingPipeline> locator = locatorInstance;
        if (locator == null) {
            LOG.info("Looking up bean '" + BEAN_NAME + "' in ApplicationContext due to context not yet being initialized");
            final ApplicationContext applicationContext = PortalApplicationContextLocator.getApplicationContext();
            applicationContext.getBean(PortalRenderingPipelineLocator.class.getName());
            
            locator = locatorInstance;
            if (locator == null) {
                LOG.warn("Instance of '" + BEAN_NAME + "' still null after portal application context has been initialized");
                return (IPortalRenderingPipeline)applicationContext.getBean(BEAN_NAME, IPortalRenderingPipeline.class);
            }
        }
        
        return locator.getInstance();
    }

    public PortalRenderingPipelineLocator(IPortalRenderingPipeline instance) {
        super(instance, IPortalRenderingPipeline.class);
    }

    /* (non-Javadoc)
     * @see org.jasig.portal.spring.locator.AbstractBeanLocator#getLocator()
     */
    @Override
    protected AbstractBeanLocator<IPortalRenderingPipeline> getLocator() {
        return locatorInstance;
    }

    /* (non-Javadoc)
     * @see org.jasig.portal.spring.locator.AbstractBeanLocator#setLocator(org.jasig.portal.spring.locator.AbstractBeanLocator)
     */
    @Override
    protected void setLocator(AbstractBeanLocator<IPortalRenderingPipeline> locator) {
        locatorInstance = locator;
    }
}
