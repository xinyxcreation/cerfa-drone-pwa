import { Seeder } from '../Seeder.js';

import { RolesSeeder } from './001_RolesSeeder.js';
import { EntityTypesSeeder } from './002_EntityTypesSeeder.js';
import { DocumentTypesSeeder } from './003_DocumentTypesSeeder.js';
import { CertificationTypesSeeder } from './004_CertificationTypesSeeder.js';
import { PrefecturesSeeder } from './005_PrefecturesSeeder.js';
import { MissionStatusesSeeder } from './006_MissionStatusesSeeder.js';
import { CerfaStatusesSeeder } from './007_CerfaStatusesSeeder.js';
import { NotificationTypesSeeder } from './008_NotificationTypesSeeder.js';
import { AuditActionsSeeder } from './009_AuditActionsSeeder.js';

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

];
