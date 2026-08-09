import { buildApp } from './app.js';

async function start(): Promise<void> {

    try {

        const app = await buildApp();

        await app.listen({

            host: process.env.HOST ?? '127.0.0.1',

            port: Number(
                process.env.PORT ?? 3000
            )

        });

        app.log.info(
            `🚀 Backend CERFA Drone démarré sur http://${process.env.HOST ?? '127.0.0.1'}:${process.env.PORT ?? 3000}`
        );

    } catch (error) {

        console.error(error);

        process.exit(1);

    }

}

void start();
