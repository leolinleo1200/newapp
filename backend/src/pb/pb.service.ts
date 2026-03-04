import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { CompetitionResult } from '../results/entities/competition-result.entity';
import { OfficialRecord } from './entities/official-record.entity';

@Injectable()
export class PbService {
  constructor(
    @InjectRepository(CompetitionResult)
    private readonly resultRepo: Repository<CompetitionResult>,
    @InjectRepository(OfficialRecord)
    private readonly officialRepo: Repository<OfficialRecord>,
  ) {}

  async getPersonalBests(userId: string) {
    return this.resultRepo
      .createQueryBuilder('r')
      .select('r.stroke', 'stroke')
      .addSelect('r.distance', 'distance')
      .addSelect('r.poolLength', 'poolLength')
      .addSelect('MIN(CAST(r.timeMs as bigint))', 'bestTimeMs')
      .where('r.userId = :userId', { userId })
      .groupBy('r.stroke')
      .addGroupBy('r.distance')
      .addGroupBy('r.poolLength')
      .orderBy('stroke', 'ASC')
      .addOrderBy('distance', 'ASC')
      .getRawMany();
  }

  async getBenchmarks() {
    return this.officialRepo.find({ order: { stroke: 'ASC', distance: 'ASC' } });
  }
}
