import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { CompetitionResult } from './entities/competition-result.entity';
import { CreateResultDto } from './dto/create-result.dto';

@Injectable()
export class ResultsService {
  constructor(
    @InjectRepository(CompetitionResult)
    private readonly resultRepo: Repository<CompetitionResult>,
  ) {}

  async create(userId: string, dto: CreateResultDto) {
    const result = this.resultRepo.create({
      userId,
      stroke: dto.stroke,
      distance: dto.distance,
      poolLength: dto.poolLength,
      timeMs: String(dto.timeMs),
      meetName: dto.meetName,
      date: dto.date ? new Date(dto.date) : undefined,
    });

    return this.resultRepo.save(result);
  }

  async findByUser(userId: string) {
    return this.resultRepo.find({
      where: { userId },
      order: { createdAt: 'DESC' },
      take: 100,
    });
  }
}
