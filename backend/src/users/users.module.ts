import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { CompetitionResult } from '../results/entities/competition-result.entity';
import { User } from './entities/user.entity';
import { UsersController } from './users.controller';
import { UsersService } from './users.service';

@Module({
  imports: [TypeOrmModule.forFeature([User, CompetitionResult])],
  controllers: [UsersController],
  providers: [UsersService],
})
export class UsersModule {}
