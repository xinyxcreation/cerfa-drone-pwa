import { MigrationRunner } from './MigrationRunner';
import { closeDatabase } from './connection';

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
