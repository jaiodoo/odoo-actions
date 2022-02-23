FROM --platform=linux/amd64 python:3
LABEL "maintainer" = "José Angel Inda Herrera <jose.inda09947@gmail.com>"
RUN pip install --upgrade pip
RUN pip install flake8 mypy isort black
RUN pip install --upgrade git+https://github.com/oca/pylint-odoo.git
COPY entrypoint.sh /
COPY .pylintrc /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
