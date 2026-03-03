import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  ManyToOne,
  JoinColumn,
} from 'typeorm';
import { User } from '../../users/entities/user.entity';

@Entity('CompetitionResults')
export class CompetitionResult {
  @PrimaryGeneratedColumn({ name: 'result_id', type: 'bigint' })
  resultId: string;

  @Column({ name: 'user_id', type: 'bigint' })
  userId: string;

  @ManyToOne(() => User, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'user_id' })
  user: User;

  @Column({ type: 'text' })
  stroke: string;

  @Column({ type: 'int' })
  distance: number;

  @Column({ name: 'pool_length', type: 'text' })
  poolLength: '25m' | '50m';

  @Column({ name: 'time_ms', type: 'bigint' })
  timeMs: string;

  @Column({ name: 'meet_name', type: 'text', nullable: true })
  meetName: string;

  @Column({ type: 'date', nullable: true })
  date: Date;

  @CreateDateColumn({ name: 'created_at', type: 'timestamp' })
  createdAt: Date;
}
