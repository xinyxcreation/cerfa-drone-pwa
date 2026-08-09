import { Pool } from 'mysql2/promise';

import { BaseSeeder } from '../BaseSeeder.js';
import { Seeder } from '../Seeder.js';

export class MissionStatusesSeeder extends BaseSeeder implements Seeder {

    public readonly name = 'Mission Statuses';

    public async run(db: Pool): Promise<void> {

        await this.insertIfNotExists(
            db,
            'mission_statuses',
            'code',
            'DRAFT',
            {
                code: 'DRAFT',
                label: 'Brouillon',
                description: 'Mission en cours de préparation.',
                sort_order: 1,
                is_active: true
            }
        );

        await this.insertIfNotExists(
            db,
            'mission_statuses',
            'code',
            'PLANNED',
            {
                code: 'PLANNED',
                label: 'Planifiée',
                description: 'Mission planifiée.',
                sort_order: 2,
                is_active: true
            }
        );

        await this.insertIfNotExists(
            db,
            'mission_statuses',
            'code',
            'IN_PROGRESS',
            {
                code: 'IN_PROGRESS',
                label: 'En cours',
                description: 'Mission en cours de réalisation.',
                sort_order: 3,
                is_active: true
            }
        );

        await this.insertIfNotExists(
            db,
            'mission_statuses',
            'code',
            'COMPLETED',
            {
                code: 'COMPLETED',
                label: 'Terminée',
                description: 'Mission terminée.',
                sort_order: 4,
                is_active: true
            }
        );

        await this.insertIfNotExists(
            db,
            'mission_statuses',
            'code',
            'CANCELLED',
            {
                code: 'CANCELLED',
                label: 'Annulée',
                description: 'Mission annulée.',
                sort_order: 5,
                is_active: true
            }
        );

    }

}
