import { FastifyInstance } from "fastify";
import healthRoutes from "./health.js";

export default async function v1Routes(fastify: FastifyInstance) {
    await fastify.register(healthRoutes);
}
