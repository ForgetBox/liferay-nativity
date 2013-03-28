/**
 * Copyright (c) 2000-2012 Liferay, Inc. All rights reserved.
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

package com.liferay.nativity.plugincontrol;

import java.util.HashMap;
import java.util.Map;

/**
 * @author Dennis Ju
 */
public abstract class NativityPluginControl {

	public NativityPluginControl() {
		_commandMap = new HashMap<String, MessageListener>();
	}

	/**
	 * Initialize connection with native service
	 *
	 * @return true if connection is successful
	 */
	public abstract boolean connect();

	/**
	 * Initialize disconnection with native service
	 *
	 * @return true if disconnection is successful
	 */
	public abstract boolean disconnect();

	/**
	 * Triggers the appropriate registered MessageListener when messages are
	 * received from the native service.
	 *
	 * @param NativityMessage received from the native service
	 *
	 * @return NativityMessage to send back to the native service. Returns null
	 * if no registered MessageListener is found or if no response
	 * needs to be sent back to the native service.
	 */
	public NativityMessage fireMessageListener(NativityMessage message) {
		MessageListener messageListener = _commandMap.get(message.getCommand());

		if (messageListener == null) {
			return null;
		}

		return messageListener.onMessageReceived(message);
	}

	/**
	 * Used by modules to register a MessageListener that will respond to
	 * messages received from the native service. Each registered
	 * MessageListener instance must have a unique "command" parameter.
	 * Registering an instance with the same "command" parameter will replace
	 * previously registered instances.
	 *
	 * @param MessageListener to register
	 */
	public void registerMessageListener(MessageListener messageListener) {
		_commandMap.put(messageListener.getCommand(), messageListener);
	}

	/**
	 * Checks if the native service is running
	 *
	 * @return true if native service is running
	 */
	public abstract boolean running();

	/**
	 * Used by modules to send messages to the native service.
	 *
	 * @param NativityMessage to send to the native service
	 *
	 * @return response from the native service
	 */
	public abstract String sendMessage(NativityMessage message);

	/**
	 * Optionally set the root folder filter path for requests made
	 * to the native service. For example, setting a value of "/test/folder"
	 * indicates that any requests (like custom context menus) for files that
	 * are not a child of "/test/folder" will be ignored. This can improve
	 * native performance.
	 *
	 * @param root folder path to filter by (inclusive)
	 */
	public abstract void setRootFolder(String folder);

	/**
	 * Windows only
	 *
	 * Marks the specified folder as a system folder so that Desktop.ini values
	 * will take effect.
	 *
	 * @param folder to set as a system folder
	 */
	public abstract void setSystemFolder(String folder);

	/**
	 * Mac only
	 *
	 * Starts the native service.
	 *
	 * @param
	 *
	 * @return true if the service successfully started
	 */
	public abstract boolean startPlugin(String path) throws Exception;

	private Map<String, MessageListener> _commandMap;

}