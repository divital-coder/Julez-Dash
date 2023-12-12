# Use the official Julia base image
FROM julia:1.9.4

# Set the working directory inside the container
WORKDIR ./

# Copy the Julia project files to the container
COPY . .

# Install Julia dependencies (you may need to modify this based on your setup)
RUN julia -e 'using Pkg; Pkg.instantiate()'

# Specify the entry point for your application
CMD ["julia", "front_interface.jl"]

