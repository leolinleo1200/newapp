import { SetMetadata } from '@nestjs/common';

export const ROLES_KEY = 'roles';
export const Roles = (...roles: Array<'swimmer' | 'coach' | 'admin'>) =>
  SetMetadata(ROLES_KEY, roles);
