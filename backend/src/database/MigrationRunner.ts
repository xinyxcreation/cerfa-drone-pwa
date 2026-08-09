import path from 'node:path';
import { getDatabase } from './core//DatabaseConnection';
import { SqlScriptRunner } from './core//SqlScriptRunner';
import { DatabaseChecker } from './core//DatabaseChecker';

export class MigrationRunner extends SqlScriptRunner {

    constructor() {
        super(getDatabase());
    }

    public async run(): Promise<void> {

        console.log('🚀 Migration démarrée...\n');

        await this.createMigrationTable();

        const migrationsPath = path.resolve(
            process.cwd(),
                                            'src',
                                            'database',
                                            'migrations'
        );

        const files = await this.getSqlFiles(migrationsPath);

        let skipped = 0;
        let executed = 0;

        for (const file of files) {

            const [rows] = await this.db.query(
                'SELECT 1 FROM schema_migrations WHERE filename = ? LIMIT 1',
                [file]
            );

            if ((rows as any[]).length > 0) {

                skipped++;
                console.log(`⏭️  ${file}`);
                continue;

            }

            console.log(`▶ ${file}`);

            try {

                await this.executeFile(migrationsPath, file);

                await this.db.query(
                    `
                    INSERT INTO schema_migrations
                    (
                        filename,
                     executed_at
                    )
                    VALUES
                    (
                        ?,
                     UTC_TIMESTAMP(6)
                    )
                    `,
                    [file]
                );

                executed++;

                console.log(`✅ ${file}`);

            } catch (error) {

                console.error(`❌ ${file}`);
                throw error;

            }

        }

        console.log('\n🔎 Vérification des tables...\n');

        const checker = new DatabaseChecker(this.db);
        await checker.check();

        console.log('\n────────────────────────────────────────');

        console.log(`Déjà exécutées : ${skipped}`);
        console.log(`Exécutées       : ${executed}`);

        console.log('\n🎉 Base de données à jour.');

    }

    private async createMigrationTable(): Promise<void> {

        await this.db.query(`
        CREATE TABLE IF NOT EXISTS schema_migrations (
            filename VARCHAR(255) NOT NULL,
                                                      executed_at DATETIME(6) NOT NULL,

                                                      PRIMARY KEY (filename)
        )
        ENGINE=InnoDB
        DEFAULT CHARSET=utf8mb4
        COLLATE=utf8mb4_unicode_ci;
        `);

    }


}
