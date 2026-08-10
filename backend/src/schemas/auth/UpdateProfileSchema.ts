import { z } from 'zod';

export const UpdateProfileSchema = z.object({

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
                                            .optional()

});

export type UpdateProfileInput =
z.infer<typeof UpdateProfileSchema>;
