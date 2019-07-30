FROM hasura/graphql-engine:v1.0.0-beta.3
COPY serve-graphql-when-postgres-available /serve-graphql-when-postgres-available
CMD /serve-graphql-when-postgres-available
ENV HASURA_GRAPHQL_DATABASE_URL postgres://graph_test:graph_test@localhost:5432/graph_test
