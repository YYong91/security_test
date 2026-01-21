from src.core.secret_algo import very_secret_algorithm
from src.utils import log


def run():
    log("Start AI Module")
    value = very_secret_algorithm(10)
    log(f"Result = {value}")


if __name__ == "__main__":
    run()
