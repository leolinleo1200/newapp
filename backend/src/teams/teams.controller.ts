import { Body, Controller, Get, Param, Post, Request, UseGuards, ValidationPipe } from '@nestjs/common';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { CreateTeamDto } from './dto/create-team.dto';
import { TeamsService } from './teams.service';

@Controller('teams')
@UseGuards(JwtAuthGuard)
export class TeamsController {
  constructor(private readonly teamsService: TeamsService) {}

  @Post()
  async create(@Request() req, @Body(ValidationPipe) dto: CreateTeamDto) {
    return this.teamsService.createTeam(req.user.userId, dto);
  }

  @Get(':teamId')
  async getTeam(@Param('teamId') teamId: string) {
    return this.teamsService.getTeam(teamId);
  }

  @Post(':teamId/join')
  async join(@Request() req, @Param('teamId') teamId: string) {
    return this.teamsService.joinTeam(teamId, req.user.userId);
  }

  @Post(':teamId/approve/:userId')
  async approve(
    @Request() req,
    @Param('teamId') teamId: string,
    @Param('userId') userId: string,
  ) {
    return this.teamsService.approveMember(teamId, userId, req.user.userId);
  }

  @Get(':teamId/members')
  async members(@Param('teamId') teamId: string) {
    return this.teamsService.listMembers(teamId);
  }
}
