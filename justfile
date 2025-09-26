# Build documentation locally
build-docs:
    @echo "Building HTML documentation..."
    cd docs && sphinx-build -b html . _build/html
    @echo "Documentation built successfully!"
    @echo "Open docs/_build/html/index.html in your browser to view it."

# Clean build artifacts
clean-docs:
    rm -rf docs/_build/
