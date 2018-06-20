Docker repository for machine-learning and NLP tasks, built on [alpine-python-machinelearning](https://hub.docker.com/r/frolvlad/alpine-python-machinelearning/) – includes:

* [SpaCy](spacy.io)
* Scikit-Learn
* Numpy
* Pandas
* Scipy



## Hello World

    docker run --rm admackin/alpine-python-ml-spacy python3 -c "import spacy; spacy.cli.download('en_core_web_sm'); print(spacy.load('en_core_web_sm')('Hello World!'));"