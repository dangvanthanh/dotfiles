import { Command } from '@oclif/core'

export default class Build extends Command {
	public async run(): Promise<void> {
		this.log('build')
	}
}
