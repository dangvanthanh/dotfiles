import { Args, Command } from '@oclif/core'

export default class Commit extends Command {
	static override args = {
		arg1: Args.string(),
	}

	public async run(): Promise<void> {
		const { args } = await this.parse(Commit)
		this.log('commit')
		this.log('arg1: %s', args.arg1)
	}
}