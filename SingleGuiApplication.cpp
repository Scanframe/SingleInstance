#include "SingleGuiApplication.h"

#include <utility>

SingleGuiApplication::SingleGuiApplication(int& argc, char** argv, bool allowSecondary, SingleInstance::Options options, int timeout, const QString& userData)
	:QGuiApplication(argc, argv)
	 , _instance(allowSecondary, options, timeout, userData)
{
	connect(&_instance, &SingleInstance::instanceStarted, [&]()
	{
		Q_EMIT SingleGuiApplication::instanceStarted();
	});
	connect(&_instance, &SingleInstance::receivedMessage, [&](quint32 instanceId, QByteArray message)
	{
		Q_EMIT SingleGuiApplication::receivedMessage(instanceId, std::move(message));
	});
}
