import { Seeder } from '../Seeder';

import { RolesSeeder } from './001_RolesSeeder';
import { EntityTypesSeeder } from './002_EntityTypesSeeder';
import { DocumentTypesSeeder } from './003_DocumentTypesSeeder';
import { CertificationTypesSeeder } from './004_CertificationTypesSeeder';
import { PrefecturesSeeder } from './005_PrefecturesSeeder';
import { MissionStatusesSeeder } from './006_MissionStatusesSeeder';
import { CerfaStatusesSeeder } from './007_CerfaStatusesSeeder';
import { NotificationTypesSeeder } from './008_NotificationTypesSeeder';
import { AuditActionsSeeder } from './009_AuditActionsSeeder';
import { TestAccountSeeder } from './010_TestAccountSeeder';

export const seeders: Seeder[] = [

    new RolesSeeder(),

    new EntityTypesSeeder(),

    new DocumentTypesSeeder(),

    new CertificationTypesSeeder(),

    new PrefecturesSeeder(),

    new MissionStatusesSeeder(),

    new CerfaStatusesSeeder(),

    new NotificationTypesSeeder(),

    new AuditActionsSeeder(),

    new TestAccountSeeder()

];
