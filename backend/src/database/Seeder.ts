import { Pool } from 'mysql2/promise';

export interface Seeder {

    readonly name: string;

    run(db: Pool): Promise<void>;

}
