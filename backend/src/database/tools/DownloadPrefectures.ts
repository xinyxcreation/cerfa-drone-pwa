import { mkdir, writeFile } from 'node:fs/promises';
import path from 'node:path';

const URL =
'https://www.data.gouv.fr/fr/datasets/r/987227fb-dcb2-429e-96af-8979f97c9b2b';

interface Commune {

    code_departement: string;

    nom_departement: string;

    nom_commune: string;

    codes_postaux: string[];

}

async function main(): Promise<void> {

    console.log('Téléchargement...');

    const response = await fetch(URL);

    if (!response.ok) {

        throw new Error(
            `Erreur HTTP ${response.status}`
        );

    }

    const communes = await response.json() as Commune[];

    const map = new Map<string, any>();

    for (const commune of communes) {

        if (map.has(commune.code_departement)) {
            continue;
        }

        map.set(
            commune.code_departement,
            {

                code: commune.code_departement,

                department_code: commune.code_departement,

                department_name: commune.nom_departement,

                name: `Préfecture de ${commune.nom_commune}`,

                address: null,

                postal_code:
                commune.codes_postaux?.[0] ?? null,

                city: commune.nom_commune,

                phone: null,

                email: null

            }
        );

    }

    const prefectures = [...map.values()]
    .sort((a, b) => a.code.localeCompare(b.code));

    const output = path.resolve(

        process.cwd(),

                                'src',
                                'database',
                                'data',
                                'prefectures.json'

    );

    await mkdir(
        path.dirname(output),
                { recursive: true }
    );

    await writeFile(

        output,

        JSON.stringify(
            prefectures,
            null,
            4
        ),

        'utf8'

    );

    console.log(
        `✅ ${prefectures.length} préfectures enregistrées`
    );

}

main().catch(console.error);
