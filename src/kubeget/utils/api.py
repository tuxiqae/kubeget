from typing import Generator, Optional, Tuple

import kubernetes
import urllib3

from kubeget.utils import logs


def get_client() -> kubernetes.client.CoreV1Api:
    """
    Loads the configuration and returns a Kubernetes client
    """
    kubernetes.config.load_kube_config()
    return kubernetes.client.CoreV1Api()


def parse_pod(pod: kubernetes.client.V1Pod) -> Tuple[str, int, str, str]:
    return (
        pod.metadata.name,
        len(pod.metadata.labels),
        pod.spec.node_name,
        pod.metadata.namespace,
    )


def get_pods_from_api(client, namespace: Optional[str] = None) -> list:
    """
    Get all pods, whether for namespace or not
    """
    if namespace:
        return client.list_namespaced_pod(namespace=namespace).items
    return client.list_pod_for_all_namespaces().items


def generate_pods(
    pods: list[kubernetes.client.V1Pod], node: Optional[str] = None
) -> Generator:
    if node:
        # Filter pods by namespace
        pods: filter[kubernetes.client.V1Pod] = filter(
            lambda pod: pod.spec.node_name == node, pods
        )

    for pod in map(parse_pod, pods):
        yield pod


def get_pods(
    namespace: Optional[str] = None,
    node: Optional[str] = None,
    show_traces: bool = False,
) -> Generator:
    """
    Return a generator of all matching pods, parsed
    """
    try:
        client = get_client()
        pods = get_pods_from_api(client, namespace)
    except kubernetes.config.ConfigException as exc:
        logs.logger.error(exc.args[0], exc_info=show_traces)
        raise SystemExit(1)
    except UnicodeDecodeError as exc:
        logs.logger.error("Could not read configuration", exc_info=show_traces)
        raise SystemExit(1)
    except kubernetes.client.exceptions.ApiException as exc:
        logs.logger.error(
            "API error encountered",
            code=exc.status,
            reason=exc.reason,
            exc_info=show_traces,
        )
        raise SystemExit(2)
    except urllib3.exceptions.MaxRetryError as exc:
        logs.logger.error(
            "Max retries exceeded with URL",
            url=exc.url,
            reason=exc.reason,
            exc_info=show_traces,
        )
        raise SystemExit(3)

    return generate_pods(pods, node)
