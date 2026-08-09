import { SeederRunner } from './SeederRunner';

async function main(): Promise<void> {

    const runner = new SeederRunner();

    await runner.run();

}

main().catch((error) => {

    console.error(error);

    process.exit(1);

});
