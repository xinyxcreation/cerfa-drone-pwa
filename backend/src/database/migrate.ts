import { MigrationRunner } from './MigrationRunner.js';
import { getDatabase, closeDatabase } from './core/DatabaseConnection.js';

async function main() {

    try {

        const runner = new MigrationRunner();

        await runner.run();

    } finally {

        await closeDatabase();

    }

}

main().catch(error => {

    console.error(error);

    process.exit(1);

});
