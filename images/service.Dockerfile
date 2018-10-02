FROM java:8

ARG TYPE

WORKDIR /
ADD ./service-$TYPE/build/libs/aws-calculator-$TYPE-service-0.1.0.jar service.jar
EXPOSE 8080
CMD java -jar service.jar
