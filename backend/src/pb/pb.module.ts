import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { CompetitionResult } from '../results/entities/competition-result.entity';
import { OfficialRecord } from './entities/official-record.entity';
import { PbController } from './pb.controller';
import { PbService } from './pb.service';

@Module({
  imports: [TypeOrmModule.forFeature([CompetitionResult, OfficialRecord])],
  controllers: [PbController],
  providers: [PbService],
})
export class PbModule {}
