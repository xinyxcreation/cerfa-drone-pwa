import { Pool } from 'mysql2/promise';

import { BaseSeeder } from '../BaseSeeder';
import { Seeder } from '../Seeder';

export class NotificationTypesSeeder extends BaseSeeder implements Seeder {

    public readonly name = 'Notification Types';

    public async run(db: Pool): Promise<void> {

        await this.insertIfNotExists(
            db,
            'notification_types',
            'code',
            'DOCUMENT_EXPIRING',
            {
                code: 'DOCUMENT_EXPIRING',
                label: 'Document bientôt expiré',
                description: 'Notification avant expiration d’un document.',
                color: '#F59E0B',
                icon: 'description',
                sort_order: 1,
                is_active: true
            }
        );

        await this.insertIfNotExists(
            db,
            'notification_types',
            'code',
            'DOCUMENT_EXPIRED',
            {
                code: 'DOCUMENT_EXPIRED',
                label: 'Document expiré',
                description: 'Notification document expiré.',
                color: '#DC2626',
                icon: 'warning',
                sort_order: 2,
                is_active: true
            }
        );

        await this.insertIfNotExists(
            db,
            'notification_types',
            'code',
            'CERTIFICATION_EXPIRING',
            {
                code: 'CERTIFICATION_EXPIRING',
                label: 'Certification bientôt expirée',
                description: 'Notification avant expiration d’une certification.',
                color: '#F59E0B',
                icon: 'workspace_premium',
                sort_order: 3,
                is_active: true
            }
        );

        await this.insertIfNotExists(
            db,
            'notification_types',
            'code',
            'MISSION_REMINDER',
            {
                code: 'MISSION_REMINDER',
                label: 'Rappel mission',
                description: 'Rappel avant une mission.',
                color: '#2563EB',
                icon: 'flight_takeoff',
                sort_order: 4,
                is_active: true
            }
        );

        await this.insertIfNotExists(
            db,
            'notification_types',
            'code',
            'CERFA_STATUS_CHANGED',
            {
                code: 'CERFA_STATUS_CHANGED',
                label: 'Changement statut CERFA',
                description: 'Le statut du CERFA a changé.',
                color: '#16A34A',
                icon: 'assignment',
                sort_order: 5,
                is_active: true
            }
        );

    }

}
