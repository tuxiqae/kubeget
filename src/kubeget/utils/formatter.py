from prettytable import PrettyTable


def config_pods_table() -> PrettyTable:
    """
    Configure pods table structure
    """
    headers = ("Pod Name", "Number of Labels", "Node Name", "Namespace")
    table = PrettyTable(headers)
    table.horizontal_char = "="
    table.align = "l"
    table.sortby = headers[0]
    table.align[headers[1]] = "c"
    return table
