import { promises as fs } from 'node:fs';
import path from 'node:path';
import { Pool } from 'mysql2/promise';

import { BaseSeeder } from '../BaseSeeder';
import { Seeder } from '../Seeder';

interface PrefectureJson {

    code: string;

    department_name: string;

    prefecture_name: string;

    email: string | null;

    website_url: string | null;

    legal_response_days?: number;

}

export class PrefecturesSeeder
extends BaseSeeder
implements Seeder
{
    public readonly order = 5;

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

        const prefectures =
        JSON.parse(json) as PrefectureJson[];

        for (const prefecture of prefectures) {

            await this.insertIfNotExists(
                db,
                'prefectures',
                'code',
                prefecture.code,
                {
                    code: prefecture.code,

                    department_name:
                    prefecture.department_name,

                    prefecture_name:
                    prefecture.prefecture_name,

                    email:
                    prefecture.email ?? null,

                    website_url:
                    prefecture.website_url ?? null,

                    legal_response_days:
                    prefecture.legal_response_days ?? 10,

                    is_active: true

                }
            );

        }

    }
}
