#include <QCoreApplication>
#include <QMessageLogContext>
#include "../../SingleInstance"

int main(int argc, char* argv[])
{
	QCoreApplication app(argc, argv);
	SingleInstance inst;

	qWarning() << "Started a new instance";

	return QCoreApplication::exec();
}
