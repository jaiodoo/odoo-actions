FROM python:3
RUN pip install --upgrade pip
RUN pip install flake8 mypy isort
RUN pip install --upgrade git+https://github.com/oca/pylint-odoo.git
COPY entrypoint.sh /
COPY .pylintrc /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
