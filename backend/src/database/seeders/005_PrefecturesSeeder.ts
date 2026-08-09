import { promises as fs } from 'node:fs';
import path from 'node:path';
import { Pool } from 'mysql2/promise';

import { BaseSeeder } from '../BaseSeeder';
import { Seeder } from '../Seeder';

interface PrefectureJson {

    code: string;
    department_code: string;
    department_name: string;

    name: string;

    address: string;

    postal_code: string;
    city: string;

    phone: string | null;
    email: string | null;
}

export class PrefecturesSeeder extends BaseSeeder implements Seeder {

    public readonly name = 'Prefectures';

    public async run(db: Pool): Promise<void> {

        const file = path.resolve(
            process.cwd(),
                                  'src',
                                  'database',
                                  'data',
                                  'prefectures.json'
        );

        const json = await fs.readFile(
            file,
            'utf8'
        );

        const prefectures = JSON.parse(json) as PrefectureJson[];

        for (const prefecture of prefectures) {

            await this.insertIfNotExists(
                db,
                'prefectures',
                'code',
                prefecture.code,
                {
                    code: prefecture.code,

                    department_code: prefecture.department_code,
                    department_name: prefecture.department_name,

                    name: prefecture.name,

                    address: prefecture.address,

                    postal_code: prefecture.postal_code,
                    city: prefecture.city,

                    phone: prefecture.phone,
                    email: prefecture.email,

                    is_active: true,

                    sort_order: Number(prefecture.department_code)
                }
            );

        }

    }

}
