# syntax=docker/dockerfile:1-labs

# build stage
FROM python:3.10 AS builder

ARG PDM_VERSION=2.4.8

# install PDM
RUN pip install -U --no-cache-dir pip setuptools wheel "pdm==${PDM_VERSION}"

# copy files
COPY pyproject.toml pdm.lock README.md /project/

# install dependencies and project into the local packages directory
WORKDIR /project
RUN mkdir __pypackages__ && pdm install --prod --no-self
COPY src/ /project/src
RUN pdm install --prod --no-editable


# run stage
FROM python:3.10-slim

# copy dependencies
ADD --link --checksum=sha256:b6769d8ac6a0ed0f13b307d289dc092ad86180b08f5b5044af152808c04950ae \
  --chmod=755 \
  https://dl.k8s.io/release/v1.26.0/bin/linux/amd64/kubectl \
  /usr/local/bin/

# retrieve packages from build stage
ENV PYTHONPATH=/project/pkgs
COPY --from=builder /project/__pypackages__/3.10/lib /project/pkgs
COPY --from=builder /project/__pypackages__/3.10/bin/kubeget /usr/local/bin/
COPY --from=builder /project/src /project/src

# set command/entrypoint, adapt to fit your needs
CMD [ "bash" ]
