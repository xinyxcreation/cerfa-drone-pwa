import { Pool } from 'mysql2/promise';

import { BaseSeeder } from '../BaseSeeder.js';
import { Seeder } from '../Seeder.js';

export class EntityTypesSeeder extends BaseSeeder implements Seeder {

    public readonly name = 'Entity Types';

    public async run(db: Pool): Promise<void> {

        await this.insertIfNotExists(
            db,
            'entity_types',
            'code',
            'COMPANY',
            {
                code: 'COMPANY',
                label: 'Entreprise',
                sort_order: 1,
                is_active: true
            }
        );

        await this.insertIfNotExists(
            db,
            'entity_types',
            'code',
            'USER',
            {
                code: 'USER',
                label: 'Utilisateur',
                sort_order: 2,
                is_active: true
            }
        );

        await this.insertIfNotExists(
            db,
            'entity_types',
            'code',
            'DRONE',
            {
                code: 'DRONE',
                label: 'Drone',
                sort_order: 3,
                is_active: true
            }
        );

        await this.insertIfNotExists(
            db,
            'entity_types',
            'code',
            'CLIENT',
            {
                code: 'CLIENT',
                label: 'Client',
                sort_order: 4,
                is_active: true
            }
        );

        await this.insertIfNotExists(
            db,
            'entity_types',
            'code',
            'SITE',
            {
                code: 'SITE',
                label: 'Site',
                sort_order: 5,
                is_active: true
            }
        );

        await this.insertIfNotExists(
            db,
            'entity_types',
            'code',
            'MISSION',
            {
                code: 'MISSION',
                label: 'Mission',
                sort_order: 6,
                is_active: true
            }
        );

        await this.insertIfNotExists(
            db,
            'entity_types',
            'code',
            'CERFA',
            {
                code: 'CERFA',
                label: 'CERFA',
                sort_order: 7,
                is_active: true
            }
        );

    }

}
