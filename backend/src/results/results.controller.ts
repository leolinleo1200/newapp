import { Body, Controller, Get, Post, Request, UseGuards, ValidationPipe } from '@nestjs/common';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { CreateResultDto } from './dto/create-result.dto';
import { ResultsService } from './results.service';

@Controller('results')
@UseGuards(JwtAuthGuard)
export class ResultsController {
  constructor(private readonly resultsService: ResultsService) {}

  @Post()
  async create(@Request() req, @Body(ValidationPipe) dto: CreateResultDto) {
    return this.resultsService.create(req.user.userId, dto);
  }

  @Get()
  async listMine(@Request() req) {
    return this.resultsService.findByUser(req.user.userId);
  }
}
