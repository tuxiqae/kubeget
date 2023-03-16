from typing import Optional

import click

from kubeget.utils import api, formatter, logs


@click.command()
@click.option("--namespace", default=None, type=str)
@click.option("--node", default=None, type=str)
@click.option("--show-traces", is_flag=True)
@click.version_option()
def main(namespace: Optional[str], node: Optional[str], show_traces: bool):
    try:
        pods = api.get_pods(namespace=namespace, node=node, show_traces=show_traces)
    except Exception:
        logs.logger.error("General exception occured", exc_info=show_traces)
        raise SystemExit(255)

    pods_table = formatter.config_pods_table()
    pods_table.add_rows(pods)
    if pods_table.rows:
        print(pods_table)
    else:
        logs.logger.info("Could not find matching pods", namespace=namespace, node=node)


if __name__ == "__main__":
    main()
