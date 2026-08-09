import { Pool } from 'mysql2/promise';
import argon2 from 'argon2';
import { v7 as uuidv7 } from 'uuid';

import { Seeder } from '../Seeder';
import { BaseSeeder } from '../BaseSeeder';

export class TestAccountSeeder
extends BaseSeeder
implements Seeder
{
    public readonly order = 10;

    public readonly name = 'TestAccount';

    public async run(db: Pool): Promise<void> {

        const email = 'test@cerfa-drone.local';

        const password = 'Test1234!';

        const companyName =
        'CERFA Drone - Entreprise de test';

        /*
         * --------------------------------------------------
         * 1. Vérifier si l'utilisateur existe déjà
         * --------------------------------------------------
         */

        const [existingUsers] = await db.query<any[]>(
            `
            SELECT id
            FROM users
            WHERE email = ?
            AND deleted_at IS NULL
            LIMIT 1
            `,
            [email]
        );

        let userId: string;

        if (existingUsers.length > 0) {

            userId = existingUsers[0].id;

            console.log(
                `   ℹ️ Utilisateur déjà présent : ${email}`
            );

        } else {

            /*
             * --------------------------------------------------
             * 2. Créer l'utilisateur
             * --------------------------------------------------
             */

            userId = uuidv7();

            const passwordHash =
            await argon2.hash(password);

            await db.execute(
                `
                INSERT INTO users (
                    id,
                    email,
                    password_hash,
                    first_name,
                    last_name,
                    phone,
                    is_active,
                    last_company_id,
                    last_login_at,
                    created_at,
                    updated_at,
                    deleted_at,
                    sync_cursor
                )
                VALUES (
                    ?,
                    ?,
                    ?,
                    ?,
                    ?,
                    NULL,
                    TRUE,
                    NULL,
                    NULL,
                    UTC_TIMESTAMP(6),
                        UTC_TIMESTAMP(6),
                        NULL,
                        0
                )
                `,
                [
                    userId,
                    email,
                    passwordHash,
                    'Utilisateur',
                    'Test'
                ]
            );

            console.log(
                `   ✅ Utilisateur créé : ${email}`
            );
        }

        /*
         * --------------------------------------------------
         * 3. Chercher l'entreprise
         * --------------------------------------------------
         */

        const [existingCompanies] =
        await db.query<any[]>(
            `
            SELECT id
            FROM companies
            WHERE name = ?
            AND deleted_at IS NULL
            LIMIT 1
            `,
            [companyName]
        );

        let companyId: string;

        if (existingCompanies.length > 0) {

            companyId =
            existingCompanies[0].id;

            console.log(
                `   ℹ️ Entreprise déjà présente : ${companyName}`
            );

        } else {

            /*
             * --------------------------------------------------
             * 4. Créer l'entreprise
             * --------------------------------------------------
             */

            companyId = uuidv7();

            await db.execute(
                `
                INSERT INTO companies (
                    id,
                    name,
                    siret,
                    email,
                    phone,
                    address_line_1,
                    address_line_2,
                    postal_code,
                    city,
                    country,
                    is_active,
                    created_at,
                    updated_at,
                    deleted_at,
                    sync_cursor
                )
                VALUES (
                    ?,
                    ?,
                    NULL,
                    ?,
                    NULL,
                    NULL,
                    NULL,
                    NULL,
                    NULL,
                    'France',
                    TRUE,
                    UTC_TIMESTAMP(6),
                        UTC_TIMESTAMP(6),
                        NULL,
                        0
                )
                `,
                [
                    companyId,
                    companyName,
                    email
                ]
            );

            console.log(
                `   ✅ Entreprise créée : ${companyName}`
            );
        }

        /*
         * --------------------------------------------------
         * 5. Récupérer le rôle OWNER
         * --------------------------------------------------
         */

        const [roles] = await db.query<any[]>(
            `
            SELECT id
            FROM roles
            WHERE code = 'OWNER'
        AND is_active = TRUE
        AND deleted_at IS NULL
        LIMIT 1
        `
        );

        if (roles.length === 0) {

            throw new Error(
                'Le rôle OWNER est introuvable. Lance d’abord le seeder Roles.'
            );
        }

        const roleId = roles[0].id;

        /*
         * --------------------------------------------------
         * 6. Vérifier l'association
         * --------------------------------------------------
         */

        const [existingLinks] =
        await db.query<any[]>(
            `
            SELECT id
            FROM company_users
            WHERE company_id = ?
            AND user_id = ?
            AND deleted_at IS NULL
            LIMIT 1
            `,
            [
                companyId,
                userId
            ]
        );

        if (existingLinks.length === 0) {

            /*
             * --------------------------------------------------
             * 7. Créer l'association OWNER
             * --------------------------------------------------
             */

            await db.execute(
                `
                INSERT INTO company_users (
                    id,
                    company_id,
                    user_id,
                    role_id,
                    is_active,
                    created_at,
                    updated_at,
                    deleted_at,
                    sync_cursor
                )
                VALUES (
                    ?,
                    ?,
                    ?,
                    ?,
                    TRUE,
                    UTC_TIMESTAMP(6),
                        UTC_TIMESTAMP(6),
                        NULL,
                        0
                )
                `,
                [
                    uuidv7(),
                             companyId,
                             userId,
                             roleId
                ]
            );

            console.log(
                '   ✅ Utilisateur associé à l’entreprise avec le rôle OWNER'
            );

        } else {

            console.log(
                '   ℹ️ Association utilisateur / entreprise déjà présente'
            );
        }

        /*
         * --------------------------------------------------
         * 8. Mettre à jour la dernière entreprise
         * --------------------------------------------------
         */

        await db.execute(
            `
            UPDATE users
            SET
            last_company_id = ?,
            updated_at = UTC_TIMESTAMP(6)
            WHERE id = ?
            `,
            [
                companyId,
                userId
            ]
        );

        console.log('');
        console.log('   🔐 Compte de test prêt');
        console.log(`   📧 Email    : ${email}`);
        console.log(`   🔑 Password : ${password}`);
        console.log(`   🏢 Company  : ${companyName}`);
        console.log('   👑 Role     : OWNER');
    }
}
