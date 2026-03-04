import { Controller, Get, Request, UseGuards } from '@nestjs/common';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { PbService } from './pb.service';

@Controller()
@UseGuards(JwtAuthGuard)
export class PbController {
  constructor(private readonly pbService: PbService) {}

  @Get('pb')
  async getPb(@Request() req) {
    return this.pbService.getPersonalBests(req.user.userId);
  }

  @Get('benchmarks')
  async getBenchmarks() {
    return this.pbService.getBenchmarks();
  }
}
