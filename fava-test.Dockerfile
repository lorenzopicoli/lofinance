# Docker file used to test fava things. Sometimes it throws obscure errors and I need to add logs
# and compile it
FROM debian:stable-slim

RUN apt-get update && apt-get install -y git python3 python3-pip python3.11-venv pre-commit npm


EXPOSE 5000

RUN pip3 install beancount --break-system-packages

RUN git clone https://github.com/beancount/fava.git
WORKDIR /fava
RUN python3 -m venv venv
RUN . venv/bin/activate
RUN ls

# Run this manually after going into the container
# RUN pre-commit install  # add a git pre-commit hook to run linters
# RUN pip install --editable .

ENTRYPOINT ["tail"]
CMD ["-f","/dev/null"]

#  Run fava in the container with these options
# CMD ["fava",  "--host=0.0.0.0", "--debug" , "/beans/main.beancount"]


