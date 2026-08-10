import { z } from 'zod';

export const UpdateCompanySchema = z.object({

    name: z
    .string()
    .trim()
    .min(1, 'Le nom de l’entreprise est obligatoire.')
    .max(150),

                                            legal_name: z
                                            .string()
                                            .trim()
                                            .max(255)
                                            .nullable()
                                            .optional(),

                                            contact_name: z
                                            .string()
                                            .trim()
                                            .max(255)
                                            .nullable()
                                            .optional(),

                                            siret: z
                                            .string()
                                            .trim()
                                            .regex(
                                                /^\d{14}$/,
                                                'Le SIRET doit contenir exactement 14 chiffres.'
                                            )
                                            .nullable()
                                            .optional(),

                                            alphatango_operator_number: z
                                            .string()
                                            .trim()
                                            .min(
                                                1,
                                                 'Le numéro d’exploitant AlphaTango est obligatoire.'
                                            )
                                            .max(50),

                                            email: z
                                            .string()
                                            .trim()
                                            .toLowerCase()
                                            .email('Adresse e-mail invalide.')
                                            .max(255)
                                            .nullable()
                                            .optional(),

                                            phone: z
                                            .string()
                                            .trim()
                                            .max(30)
                                            .nullable()
                                            .optional(),

                                            website_url: z
                                            .string()
                                            .trim()
                                            .url('Adresse du site internet invalide.')
                                            .max(255)
                                            .nullable()
                                            .optional(),

                                            address_line_1: z
                                            .string()
                                            .trim()
                                            .max(255)
                                            .nullable()
                                            .optional(),

                                            address_line_2: z
                                            .string()
                                            .trim()
                                            .max(255)
                                            .nullable()
                                            .optional(),

                                            postal_code: z
                                            .string()
                                            .trim()
                                            .max(10)
                                            .nullable()
                                            .optional(),

                                            city: z
                                            .string()
                                            .trim()
                                            .max(150)
                                            .nullable()
                                            .optional(),

                                            country: z
                                            .string()
                                            .trim()
                                            .min(1)
                                            .max(100),

                                            notes: z
                                            .string()
                                            .trim()
                                            .nullable()
                                            .optional()

});

export type UpdateCompanyInput =
z.infer<typeof UpdateCompanySchema>;
