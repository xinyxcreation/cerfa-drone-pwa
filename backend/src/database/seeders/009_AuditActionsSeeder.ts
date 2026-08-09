import { Pool } from 'mysql2/promise';

import { BaseSeeder } from '../BaseSeeder';
import { Seeder } from '../Seeder';

export class AuditActionsSeeder extends BaseSeeder implements Seeder {

    public readonly name = 'Audit Actions';

    public async run(db: Pool): Promise<void> {

        await this.insertIfNotExists(
            db,
            'audit_actions',
            'code',
            'CREATE',
            {
                code: 'CREATE',
                label: 'Création',
                description: 'Création d’un enregistrement.',
                sort_order: 1,
                is_active: true
            }
        );

        await this.insertIfNotExists(
            db,
            'audit_actions',
            'code',
            'UPDATE',
            {
                code: 'UPDATE',
                label: 'Modification',
                description: 'Modification d’un enregistrement.',
                sort_order: 2,
                is_active: true
            }
        );

        await this.insertIfNotExists(
            db,
            'audit_actions',
            'code',
            'DELETE',
            {
                code: 'DELETE',
                label: 'Suppression',
                description: 'Suppression logique.',
                sort_order: 3,
                is_active: true
            }
        );

        await this.insertIfNotExists(
            db,
            'audit_actions',
            'code',
            'LOGIN',
            {
                code: 'LOGIN',
                label: 'Connexion',
                description: 'Connexion utilisateur.',
                sort_order: 4,
                is_active: true
            }
        );

        await this.insertIfNotExists(
            db,
            'audit_actions',
            'code',
            'LOGOUT',
            {
                code: 'LOGOUT',
                label: 'Déconnexion',
                description: 'Déconnexion utilisateur.',
                sort_order: 5,
                is_active: true
            }
        );

    }

}
