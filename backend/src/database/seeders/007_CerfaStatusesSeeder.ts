import { Pool } from 'mysql2/promise';

import { BaseSeeder } from '../BaseSeeder';
import { Seeder } from '../Seeder';

export class CerfaStatusesSeeder extends BaseSeeder implements Seeder {

    public readonly name = 'CERFA Statuses';

    public async run(db: Pool): Promise<void> {

        await this.insertIfNotExists(
            db,
            'cerfa_statuses',
            'code',
            'DRAFT',
            {
                code: 'DRAFT',
                label: 'Brouillon',
                description: 'CERFA en préparation.',
                color: '#6B7280',
                icon: 'edit',
                sort_order: 1,
                is_active: true
            }
        );

        await this.insertIfNotExists(
            db,
            'cerfa_statuses',
            'code',
            'READY',
            {
                code: 'READY',
                label: 'Prêt',
                description: 'Prêt à être envoyé.',
                color: '#2563EB',
                icon: 'send',
                sort_order: 2,
                is_active: true
            }
        );

        await this.insertIfNotExists(
            db,
            'cerfa_statuses',
            'code',
            'SENT',
            {
                code: 'SENT',
                label: 'Envoyé',
                description: 'CERFA envoyé.',
                color: '#F59E0B',
                icon: 'mail',
                sort_order: 3,
                is_active: true
            }
        );

        await this.insertIfNotExists(
            db,
            'cerfa_statuses',
            'code',
            'ACCEPTED',
            {
                code: 'ACCEPTED',
                label: 'Accepté',
                description: 'CERFA accepté.',
                color: '#16A34A',
                icon: 'check_circle',
                sort_order: 4,
                is_active: true
            }
        );

        await this.insertIfNotExists(
            db,
            'cerfa_statuses',
            'code',
            'REFUSED',
            {
                code: 'REFUSED',
                label: 'Refusé',
                description: 'CERFA refusé.',
                color: '#DC2626',
                icon: 'cancel',
                sort_order: 5,
                is_active: true
            }
        );

    }

}
