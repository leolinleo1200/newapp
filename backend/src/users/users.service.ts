import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User } from './entities/user.entity';
import { CompetitionResult } from '../results/entities/competition-result.entity';

@Injectable()
export class UsersService {
  constructor(
    @InjectRepository(User)
    private readonly userRepo: Repository<User>,
    @InjectRepository(CompetitionResult)
    private readonly resultRepo: Repository<CompetitionResult>,
  ) {}

  async getUserResults(userId: string) {
    const user = await this.userRepo.findOne({ where: { userId } });
    if (!user) throw new NotFoundException('User not found');

    const results = await this.resultRepo.find({
      where: { userId },
      order: { createdAt: 'DESC' },
      take: 100,
    });

    return {
      user: {
        userId: user.userId,
        name: user.name,
        email: user.email,
        role: user.role,
      },
      results,
    };
  }
}
