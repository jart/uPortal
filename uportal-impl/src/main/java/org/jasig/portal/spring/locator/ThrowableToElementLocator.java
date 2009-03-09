/**
 * Copyright (c) 2000-2009, Jasig, Inc.
 * See license distributed with this file and available online at
 * https://www.ja-sig.org/svn/jasig-parent/tags/rel-10/license-header.txt
 */
package org.jasig.portal.spring.locator;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.jasig.portal.channels.error.error2xml.IThrowableToElement;
import org.jasig.portal.spring.PortalApplicationContextLocator;
import org.springframework.context.ApplicationContext;

/**
 * @author Eric Dalquist
 * @version $Revision$
 * @deprecated code that needs an IThrowableToElement should use direct dependency injection where possible
 */
@Deprecated
public class ThrowableToElementLocator extends AbstractBeanLocator<IThrowableToElement> {
    public static final String BEAN_NAME = "throwableToElement";
    
    private static final Log LOG = LogFactory.getLog(ThrowableToElementLocator.class);
    private static AbstractBeanLocator<IThrowableToElement> locatorInstance;

    public static IThrowableToElement getThrowableToElement() {
        AbstractBeanLocator<IThrowableToElement> locator = locatorInstance;
        if (locator == null) {
            LOG.info("Looking up bean '" + BEAN_NAME + "' in ApplicationContext due to context not yet being initialized");
            final ApplicationContext applicationContext = PortalApplicationContextLocator.getApplicationContext();
            applicationContext.getBean(ThrowableToElementLocator.class.getName());
            
            locator = locatorInstance;
            if (locator == null) {
                LOG.warn("Instance of '" + BEAN_NAME + "' still null after portal application context has been initialized");
                return (IThrowableToElement)applicationContext.getBean(BEAN_NAME, IThrowableToElement.class);
            }
        }
        
        return locator.getInstance();
    }

    public ThrowableToElementLocator(IThrowableToElement instance) {
        super(instance, IThrowableToElement.class);
    }

    /* (non-Javadoc)
     * @see org.jasig.portal.spring.locator.AbstractBeanLocator#getLocator()
     */
    @Override
    protected AbstractBeanLocator<IThrowableToElement> getLocator() {
        return locatorInstance;
    }

    /* (non-Javadoc)
     * @see org.jasig.portal.spring.locator.AbstractBeanLocator#setLocator(org.jasig.portal.spring.locator.AbstractBeanLocator)
     */
    @Override
    protected void setLocator(AbstractBeanLocator<IThrowableToElement> locator) {
        locatorInstance = locator;
    }
}
