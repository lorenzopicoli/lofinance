# lofinance

This project holds a Dockerfile image which will:

- Run a Fava server: https://beancount.github.io/fava/index.html
- Automatically poll for new data from my private git repo to keep
  - Data includes beanfiles and import data
- Automatically poll for any importers change
- Automatically run bean-price every once in a while

---

The approach I use here is to simply poll the other git repos. I suppose that a better approach would be to have a server which holds these repos and properly shares volumes between them, but my goal here is not to do it properly, but rather to get something going since I've been manually running fava and editing locally for close to a year now.
