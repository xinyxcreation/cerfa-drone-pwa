import { FastifyInstance } from "fastify";
import { testDatabaseConnection } from "../../database/core/DatabaseConnection.js";

export default async function healthRoutes(fastify: FastifyInstance) {
    fastify.get("/health", async (_, reply) => {
        try {
            await fastify.db.query("SELECT 1");

            return {
                status: "ok",
                database: "connected",
                version: "1.0.0",
                time: new Date().toISOString(),
            };
        } catch (error) {
            fastify.log.error(error);

            return reply.code(500).send({
                status: "error",
                database: "disconnected",
                version: "1.0.0",
                time: new Date().toISOString(),
            });
        }
    });
}
