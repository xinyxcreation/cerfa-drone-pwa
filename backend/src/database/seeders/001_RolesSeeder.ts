import { Pool } from 'mysql2/promise';

import { BaseSeeder } from '../BaseSeeder.js';
import { Seeder } from '../Seeder.js';

export class RolesSeeder extends BaseSeeder implements Seeder {

    public readonly name = 'Roles';

    public async run(db: Pool): Promise<void> {

        await this.insertIfNotExists(
            db,
            'roles',
            'code',
            'OWNER',
            {
                code: 'OWNER',
                label: 'Propriétaire',
                sort_order: 1,
                is_active: true
            }
        );

        await this.insertIfNotExists(
            db,
            'roles',
            'code',
            'MANAGER',
            {
                code: 'MANAGER',
                label: 'Gestionnaire',
                sort_order: 2,
                is_active: true
            }
        );

        await this.insertIfNotExists(
            db,
            'roles',
            'code',
            'PILOT',
            {
                code: 'PILOT',
                label: 'Pilote',
                sort_order: 3,
                is_active: true
            }
        );

    }

}
