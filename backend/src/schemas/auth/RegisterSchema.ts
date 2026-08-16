import { z } from 'zod';

export const RegisterSchema = z.object({

    first_name: z
        .string()
        .trim()
        .min(1, 'Le prénom est obligatoire.')
        .max(100),

    last_name: z
        .string()
        .trim()
        .min(1, 'Le nom est obligatoire.')
        .max(100),

    email: z
        .string()
        .trim()
        .toLowerCase()
        .email('Adresse e-mail invalide.')
        .max(255),

    phone: z
        .string()
        .trim()
        .max(30)
        .nullable()
        .optional(),

    password: z
        .string()
        .min(8, 'Le mot de passe doit contenir au moins 8 caractères.')
        .max(255),

    company_name: z
        .string()
        .trim()
        .min(1, 'Le nom de l’entreprise est obligatoire.')
        .max(255)

});

export type RegisterInput =
    z.infer<typeof RegisterSchema>;
