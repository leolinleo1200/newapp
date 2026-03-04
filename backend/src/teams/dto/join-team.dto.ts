import { IsString } from 'class-validator';

export class JoinTeamDto {
  @IsString()
  teamId: string;
}
