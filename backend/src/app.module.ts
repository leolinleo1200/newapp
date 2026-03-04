import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { AuthModule } from './auth/auth.module';
import { TeamsModule } from './teams/teams.module';
import { ResultsModule } from './results/results.module';
import { PbModule } from './pb/pb.module';
import { User } from './users/entities/user.entity';
import { Team } from './teams/entities/team.entity';
import { TeamMember } from './teams/entities/team-member.entity';
import { CompetitionResult } from './results/entities/competition-result.entity';
import { OfficialRecord } from './pb/entities/official-record.entity';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
    }),
    TypeOrmModule.forRoot({
      type: 'postgres',
      host: process.env.DB_HOST || 'localhost',
      port: Number(process.env.DB_PORT ?? 5432),
      username: process.env.DB_USERNAME || 'postgres',
      password: process.env.DB_PASSWORD || 'postgres',
      database: process.env.DB_DATABASE || 'aquatrack_1_6',
      entities: [User, Team, TeamMember, CompetitionResult, OfficialRecord],
      synchronize: false, // 正式環境必須為 false
      logging: true,
    }),
    AuthModule,
    TeamsModule,
    ResultsModule,
    PbModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
