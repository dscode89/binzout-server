FROM dart:3.10

WORKDIR /app

# Copy dependency files first
COPY pubspec.* ./

# Install dependencies as root
RUN dart pub get

# Copy rest of the project
COPY . .

# Create non-root user
RUN adduser --disabled-password app

# Give ownership of the app directory to the non-root user
RUN chown -R app:app /app

# Switch to non-root user
USER app

# Expose port
EXPOSE 8054

# Run the server
CMD ["dart", "run"]