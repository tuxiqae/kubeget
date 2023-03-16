import structlog


def config_structlog_logger() -> structlog.stdlib.BoundLogger:
    structlog.configure(
        processors=[
            structlog.threadlocal.merge_threadlocal,
            structlog.contextvars.merge_contextvars,
            structlog.processors.add_log_level,
            structlog.processors.StackInfoRenderer(),
            structlog.dev.set_exc_info,
            structlog.processors.TimeStamper(fmt="iso"),
            structlog.dev.ConsoleRenderer(),
        ],
        wrapper_class=structlog.stdlib.BoundLogger,
        context_class=dict,
        logger_factory=structlog.PrintLoggerFactory(),
        cache_logger_on_first_use=True,
    )
    return structlog.get_logger()


logger = config_structlog_logger()  # Singleton logger
