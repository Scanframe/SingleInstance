#include <SingleInstance.h>
#include "messagereceiver.h"

int main(int argc, char* argv[])
{
	// Allow secondary instances
	QCoreApplication app(argc, argv);

	SingleInstance inst(true);

	MessageReceiver msgReceiver;

	// If this is a secondary instance
	if (inst.isSecondary())
	{
		inst.sendMessage(QCoreApplication::arguments().join(' ').toUtf8());
		qDebug() << "App already running.";
		qDebug() << "Primary instance PID: " << inst.primaryPid();
		qDebug() << "Primary instance user: " << inst.primaryUser();
		return 0;
	}
	else
	{
		QObject::connect(
			&inst,
			&SingleInstance::receivedMessage,
			&msgReceiver,
			&MessageReceiver::receivedMessage
		);
	}

	return QCoreApplication::exec();
}
