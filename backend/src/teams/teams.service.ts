import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Team } from './entities/team.entity';
import { TeamMember } from './entities/team-member.entity';
import { CreateTeamDto } from './dto/create-team.dto';

@Injectable()
export class TeamsService {
  constructor(
    @InjectRepository(Team)
    private readonly teamRepo: Repository<Team>,
    @InjectRepository(TeamMember)
    private readonly memberRepo: Repository<TeamMember>,
  ) {}

  async createTeam(userId: string, dto: CreateTeamDto) {
    const team = this.teamRepo.create({
      name: dto.name,
      description: dto.description,
      createdByUserId: userId,
    });

    const saved = await this.teamRepo.save(team);

    await this.memberRepo.save(
      this.memberRepo.create({
        teamId: saved.teamId,
        userId,
        status: 'active',
      }),
    );

    return saved;
  }

  async getTeam(teamId: string) {
    const team = await this.teamRepo.findOne({ where: { teamId } });
    if (!team) throw new NotFoundException('Team not found');
    return team;
  }

  async joinTeam(teamId: string, userId: string) {
    const team = await this.teamRepo.findOne({ where: { teamId } });
    if (!team) throw new NotFoundException('Team not found');

    const existing = await this.memberRepo.findOne({ where: { teamId, userId } });
    if (existing) return existing;

    const joinReq = this.memberRepo.create({
      teamId,
      userId,
      status: 'pending',
    });
    return this.memberRepo.save(joinReq);
  }

  async approveMember(teamId: string, userId: string, coachUserId: string) {
    const team = await this.teamRepo.findOne({ where: { teamId } });
    if (!team) throw new NotFoundException('Team not found');
    if (team.createdByUserId !== coachUserId) {
      throw new NotFoundException('No permission to approve for this team');
    }

    const member = await this.memberRepo.findOne({ where: { teamId, userId } });
    if (!member) throw new NotFoundException('Join request not found');

    member.status = 'active';
    return this.memberRepo.save(member);
  }

  async listMembers(teamId: string) {
    return this.memberRepo.find({
      where: { teamId, status: 'active' },
      relations: ['user'],
      order: { joinedAt: 'ASC' },
    });
  }
}
