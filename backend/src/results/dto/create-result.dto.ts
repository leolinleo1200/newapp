import { IsIn, IsInt, IsOptional, IsString, Min } from 'class-validator';

export class CreateResultDto {
  @IsString()
  stroke: string;

  @IsInt()
  @Min(1)
  distance: number;

  @IsIn(['25m', '50m'])
  poolLength: '25m' | '50m';

  @IsInt()
  @Min(1)
  timeMs: number;

  @IsOptional()
  @IsString()
  meetName?: string;

  @IsOptional()
  @IsString()
  date?: string;
}
