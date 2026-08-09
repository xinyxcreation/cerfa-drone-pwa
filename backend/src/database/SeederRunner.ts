import { getDatabase } from './core/DatabaseConnection.js';
import { seeders } from './seeders/index.js';

export class SeederRunner {

    public async run(): Promise<void> {

        console.log('🌱 Seed démarré...\n');

        const db = getDatabase();

        let executed = 0;

        const startedAt = performance.now();

        for (const seeder of seeders) {

            console.log(`▶ ${seeder.name}`);

            try {

                await seeder.run(db);

                executed++;

                console.log(`✅ ${seeder.name}`);

            } catch (error) {

                console.error(`❌ ${seeder.name}`);

                throw error;

            }

        }

        const duration = ((performance.now() - startedAt) / 1000).toFixed(2);

        console.log('\n────────────────────────────────────────');

        console.log(`Seeders exécutés : ${executed}`);
        console.log(`Temps            : ${duration} s`);

        console.log('\n🎉 Seed terminé.');

    }

}
