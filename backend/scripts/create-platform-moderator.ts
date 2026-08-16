import argon2 from 'argon2';
import { getDatabase, closeDatabase } from '../src/database/core/DatabaseConnection.js';

async function main(): Promise<void> {

    const email =
        'moderator-test@cerfa-drone.local';

    const password =
        'ModeratorTest123!';

    const db =
        getDatabase();

    try {

        const [existingRows] =
        await db.query<any[]>(
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

        if (existingRows.length > 0) {

            userId = existingRows[0].id;

            console.log(
                `Utilisateur existant : ${userId}`
            );

        } else {

            userId =
                crypto.randomUUID();

            const passwordHash =
                await argon2.hash(
                    password
                );

            await db.query(
                `
                INSERT INTO users (
                    id,
                    email,
                    password_hash,
                    firstname,
                    lastname,
                    phone,
                    is_active,
                    email_verified_at,
                    last_company_id,
                    last_login_at,
                    created_at,
                    updated_at,
                    sync_cursor
                )
                VALUES (
                    ?,
                    ?,
                    ?,
                    'Modérateur',
                    'CERFA Drone',
                    NULL,
                    TRUE,
                    UTC_TIMESTAMP(6),
                    NULL,
                    NULL,
                    UTC_TIMESTAMP(6),
                    UTC_TIMESTAMP(6),
                    0
                )
                `,
                [
                    userId,
                    email,
                    passwordHash
                ]
            );

            console.log(
                `Utilisateur créé : ${userId}`
            );
        }

        const [roleRows] =
        await db.query<any[]>(
            `
            SELECT id
            FROM platform_roles
            WHERE code = 'MODERATOR'
              AND is_active = TRUE
              AND deleted_at IS NULL
            LIMIT 1
            `
        );

        if (roleRows.length === 0) {
            throw new Error(
                'Rôle MODERATOR introuvable.'
            );
        }

        const roleId =
            roleRows[0].id;

        const [platformRows] =
        await db.query<any[]>(
            `
            SELECT id
            FROM platform_users
            WHERE user_id = ?
              AND deleted_at IS NULL
            LIMIT 1
            `,
            [userId]
        );

        if (platformRows.length > 0) {

            await db.query(
                `
                UPDATE platform_users
                SET
                    platform_role_id = ?,
                    is_active = TRUE,
                    updated_at = UTC_TIMESTAMP(6)
                WHERE user_id = ?
                `,
                [
                    roleId,
                    userId
                ]
            );

        } else {

            await db.query(
                `
                INSERT INTO platform_users (
                    id,
                    user_id,
                    platform_role_id,
                    is_active,
                    created_at,
                    updated_at,
                    sync_cursor
                )
                VALUES (
                    ?,
                    ?,
                    ?,
                    TRUE,
                    UTC_TIMESTAMP(6),
                    UTC_TIMESTAMP(6),
                    0
                )
                `,
                [
                    crypto.randomUUID(),
                    userId,
                    roleId
                ]
            );
        }

        console.log('\n✅ MODERATOR prêt.');
        console.log(`Email : ${email}`);
        console.log(`Mot de passe : ${password}`);

    } finally {

        await closeDatabase();

    }
}

main().catch(error => {

    console.error('\n❌', error);
    process.exit(1);

});
