FROM hasura/graphql-engine:v1.0.0-beta.3
COPY wait-for-postgres /wait-for-postgres
CMD /wait-for-postgres
ENV HASURA_GRAPHQL_DATABASE_URL postgres://graph_test:graph_test@localhost:5432/graph_test
