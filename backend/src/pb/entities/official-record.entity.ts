import { Entity, PrimaryGeneratedColumn, Column } from 'typeorm';

@Entity('OfficialRecords')
export class OfficialRecord {
  @PrimaryGeneratedColumn({ name: 'record_id', type: 'bigint' })
  recordId: string;

  @Column({ type: 'text' })
  type: 'WR' | 'OR' | 'NR';

  @Column({ type: 'text', nullable: true })
  country: string;

  @Column({ type: 'text' })
  stroke: string;

  @Column({ type: 'int' })
  distance: number;

  @Column({ name: 'pool_length', type: 'text' })
  poolLength: '25m' | '50m';

  @Column({ name: 'time_ms', type: 'bigint' })
  timeMs: string;

  @Column({ type: 'text', nullable: true })
  holder: string;

  @Column({ type: 'date', nullable: true })
  date: Date;
}
