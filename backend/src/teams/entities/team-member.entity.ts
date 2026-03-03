import {
  Entity,
  Column,
  CreateDateColumn,
  ManyToOne,
  JoinColumn,
  PrimaryColumn,
} from 'typeorm';
import { User } from '../../users/entities/user.entity';
import { Team } from './team.entity';

@Entity('TeamMembers')
export class TeamMember {
  @PrimaryColumn({ name: 'team_id', type: 'bigint' })
  teamId: string;

  @PrimaryColumn({ name: 'user_id', type: 'bigint' })
  userId: string;

  @ManyToOne(() => Team, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'team_id' })
  team: Team;

  @ManyToOne(() => User, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'user_id' })
  user: User;

  @Column({
    type: 'text',
    default: 'pending',
  })
  status: 'pending' | 'active' | 'rejected';

  @CreateDateColumn({ name: 'joined_at', type: 'timestamp' })
  joinedAt: Date;
}
