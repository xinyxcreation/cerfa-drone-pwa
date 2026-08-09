import { z } from 'zod';

export const CreatePilotSchema = z.object({

    firstname: z
        .string()
        .trim()
        .min(1, 'Le prénom est obligatoire.')
        .max(100),

    lastname: z
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

    password: z
        .string()
        .min(
            8,
            'Le mot de passe doit contenir au moins 8 caractères.'
        )
        .max(255),

    phone: z
        .string()
        .trim()
        .max(30)
        .nullable()
        .optional()

});

export type CreatePilotInput =
    z.infer<typeof CreatePilotSchema>;
