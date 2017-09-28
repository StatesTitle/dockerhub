FROM circleci/python:3.6.1

RUN sudo apt-get update -y
RUN sudo apt-get install -y libreoffice
