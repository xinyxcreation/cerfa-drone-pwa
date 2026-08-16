import argon2 from 'argon2';
import readline from 'node:readline/promises';
import { stdin as input, stdout as output } from 'node:process';

import { getDatabase, closeDatabase } from '../src/database/core/DatabaseConnection.js';

async function main(): Promise<void> {

    const rl =
    readline.createInterface({
        input,
        output
    });

    try {

        const email =
        (
            await rl.question(
                'Email ADMIN : '
            )
        )
        .trim()
        .toLowerCase();

        const password =
        await rl.question(
            'Mot de passe ADMIN : ',
            {
                hideEchoBack: true
            }
        );

        if (!email) {

            throw new Error(
                'Email obligatoire.'
            );

        }

        if (password.length < 8) {

            throw new Error(
                'Le mot de passe doit contenir au moins 8 caractères.'
            );

        }

        const db =
        getDatabase();

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

            userId =
            existingRows[0].id;

            console.log(
                `Utilisateur existant : ${userId}`
            );

        } else {

            const passwordHash =
            await argon2.hash(
                password
            );

            userId =
            crypto.randomUUID();

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
                    'Administration',
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
            WHERE code = 'ADMIN'
              AND is_active = TRUE
              AND deleted_at IS NULL
            LIMIT 1
            `
        );

        if (roleRows.length === 0) {

            throw new Error(
                'Rôle ADMIN introuvable.'
            );

        }

        const platformRoleId =
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
                    platformRoleId,
                    userId
                ]
            );

            console.log(
                'Accès plateforme ADMIN mis à jour.'
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
                    platformRoleId
                ]
            );

            console.log(
                'Accès plateforme ADMIN créé.'
            );

        }

        console.log(
            '\n✅ Compte ADMIN prêt.'
        );

    } finally {

        rl.close();

        await closeDatabase();

    }

}

main().catch(error => {

    console.error(
        '\n❌',
        error.message
    );

    process.exit(1);

});
