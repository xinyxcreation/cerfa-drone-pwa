import { Pool } from 'mysql2/promise';

export class DatabaseChecker {

    constructor(
        private readonly db: Pool
    ) {}

    public async check(): Promise<void> {

        console.log('\n🔎 Vérification des tables...\n');

        const [tables] = await this.db.query<any[]>('SHOW TABLES');

        let errors = 0;

        for (const table of tables) {

            const tableName = Object.values(table)[0] as string;

            const [result] = await this.db.query<any[]>(`
            CHECK TABLE \`${tableName}\`
            `);

            const status = result[0].Msg_text;

            if (status === 'OK') {
                continue;
            }

            errors++;

            console.error(`❌ ${tableName} : ${status}`);

        }

        if (errors === 0) {

            console.log('✅ Toutes les tables sont valides.');

        } else {

            throw new Error(
                `${errors} table(s) présentent une erreur.`
            );

        }

    }

}
