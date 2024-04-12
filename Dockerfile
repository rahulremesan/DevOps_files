FROM openjdk:11

WORKDIR /app

# Install wget and unzip for downloading and extracting sbt
RUN apt-get update && apt-get install -y wget unzip

# Download and install sbt
RUN wget -O sbt.zip https://github.com/sbt/sbt/releases/download/v1.7.2/sbt-1.7.2.zip && \
    unzip sbt.zip -d /usr/local/sbt && \
    rm sbt.zip && \
    ln -s /usr/local/sbt/sbt/bin/sbt /usr/local/bin/sbt

# Copy your application files
COPY . .

# Compile your application
RUN sbt clean compile

# Expose the port your application runs on
EXPOSE 9040


CMD ["sbt", "-J-Xmx2g", "-Dconfig.resource=application.prod.conf", "run 9040"]

