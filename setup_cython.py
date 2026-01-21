import os
from setuptools import setup, Extension
from Cython.Build import cythonize

TARGET_DIRS = ["src/core"]


def collect_extensions():
    extensions = []

    for base_dir in TARGET_DIRS:
        for root, _, files in os.walk(base_dir):
            for f in files:
                if f.endswith(".py") and f != "__init__.py":
                    path = os.path.join(root, f)
                    module_name = path.replace("/", ".")[:-3]
                    extensions.append(Extension(module_name, [path]))

    return extensions


setup(
    name="cython_test",
    ext_modules=cythonize(
        collect_extensions(),
        compiler_directives={"language_level": "3"},
    ),
)
