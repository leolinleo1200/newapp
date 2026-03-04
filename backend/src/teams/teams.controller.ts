import { Body, Controller, Get, Param, Post, Request, UseGuards, ValidationPipe } from '@nestjs/common';
import { Roles } from '../auth/decorators/roles.decorator';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../auth/guards/roles.guard';
import { CreateTeamDto } from './dto/create-team.dto';
import { TeamsService } from './teams.service';

@Controller('teams')
@UseGuards(JwtAuthGuard, RolesGuard)
export class TeamsController {
  constructor(private readonly teamsService: TeamsService) {}

  @Post()
  @Roles('coach', 'admin')
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
  @Roles('coach', 'admin')
  async approve(
    @Request() req,
    @Param('teamId') teamId: string,
    @Param('userId') userId: string,
  ) {
    return this.teamsService.approveMember(teamId, userId, req.user.userId);
  }

  @Post(':teamId/reject/:userId')
  @Roles('coach', 'admin')
  async reject(
    @Request() req,
    @Param('teamId') teamId: string,
    @Param('userId') userId: string,
  ) {
    return this.teamsService.rejectMember(teamId, userId, req.user.userId);
  }

  @Get(':teamId/members')
  @Roles('coach', 'admin')
  async members(@Param('teamId') teamId: string) {
    return this.teamsService.listMembers(teamId);
  }

  @Get(':teamId/pending')
  @Roles('coach', 'admin')
  async pending(@Param('teamId') teamId: string) {
    return this.teamsService.listPending(teamId);
  }
}
