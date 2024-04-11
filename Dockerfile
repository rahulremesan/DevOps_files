
FROM openjdk:11
WORKDIR /app
COPY . .
RUN wget -O sbt.zip https://github.com/sbt/sbt/releases/download/v1.7.2/sbt-1.7.2.zip && \
    unzip sbt.zip && \
    rm sbt.zip && \
    mv sbt /usr/local/sbt && \
    ln -s /usr/local/sbt/bin/sbt /usr/local/bin/sbt
RUN sbt clean compile
EXPOSE 9000
CMD ["sbt", "-J-Xmx2g", "-Dconfig.resource=application.prod.conf", "run 9000"]
