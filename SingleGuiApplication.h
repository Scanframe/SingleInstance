#pragma once

#include "SingleInstance"
#include <QtGui/QGuiApplication>

/**
 * @brief Backwards compatible class with QtSingleApplication.
 */
class SingleGuiApplication : public QGuiApplication
{
	public:
		explicit SingleGuiApplication(
			int& argc, char* argv[], bool allowSecondary = false, SingleInstance::Options options = SingleInstance::User, int timeout = 1000,
			const QString& userData = {}
		);

	Q_SIGNALS:

		void instanceStarted();

		void receivedMessage(quint32 instanceId, QByteArray message);

		SingleInstance _instance;
};
