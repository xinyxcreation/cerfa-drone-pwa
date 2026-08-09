import { Pool } from 'mysql2/promise';

import { BaseSeeder } from '../BaseSeeder.js';
import { Seeder } from '../Seeder.js';

export class DocumentTypesSeeder extends BaseSeeder implements Seeder {

    public readonly name = 'Document Types';

    public async run(db: Pool): Promise<void> {

        const userId = await this.getIdByCode(
            db,
            'entity_types',
            'USER'
        );

        const droneId = await this.getIdByCode(
            db,
            'entity_types',
            'DRONE'
        );

        const companyId = await this.getIdByCode(
            db,
            'entity_types',
            'COMPANY'
        );

        await this.insertIfNotExists(
            db,
            'document_types',
            'code',
            'PILOT_LICENSE',
            {
                entity_type_id: userId,
                code: 'PILOT_LICENSE',
                label: 'Attestation de pilote',
                description: 'Attestation de compétences du pilote.',
                default_validity_days: null,
                    default_reminder_days: 30,
                        is_required: true,
                        is_active: true,
                        sort_order: 1
            }
        );

        await this.insertIfNotExists(
            db,
            'document_types',
            'code',
            'PILOT_INSURANCE',
            {
                entity_type_id: userId,
                code: 'PILOT_INSURANCE',
                label: 'Assurance pilote',
                description: 'Assurance responsabilité civile du pilote.',
                default_validity_days: 365,
                    default_reminder_days: 30,
                        is_required: true,
                        is_active: true,
                        sort_order: 2
            }
        );

        await this.insertIfNotExists(
            db,
            'document_types',
            'code',
            'DRONE_REGISTRATION',
            {
                entity_type_id: droneId,
                code: 'DRONE_REGISTRATION',
                label: 'Enregistrement drone',
                description: 'Justificatif d’enregistrement du drone.',
                default_validity_days: null,
                    default_reminder_days: 30,
                        is_required: true,
                        is_active: true,
                        sort_order: 3
            }
        );

        await this.insertIfNotExists(
            db,
            'document_types',
            'code',
            'DRONE_INSURANCE',
            {
                entity_type_id: droneId,
                code: 'DRONE_INSURANCE',
                label: 'Assurance drone',
                description: 'Assurance responsabilité civile du drone.',
                default_validity_days: 365,
                    default_reminder_days: 30,
                        is_required: true,
                        is_active: true,
                        sort_order: 4
            }
        );

        await this.insertIfNotExists(
            db,
            'document_types',
            'code',
            'MANEX',
            {
                entity_type_id: companyId,
                code: 'MANEX',
                label: 'MANEX',
                description: 'Manuel d’exploitation.',
                default_validity_days: null,
                    default_reminder_days: 30,
                        is_required: false,
                        is_active: true,
                        sort_order: 5
            }
        );

    }

}
