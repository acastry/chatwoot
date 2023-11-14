/* eslint arrow-body-style: 0 */
import CalendarView from './components/CalendarView';
import { frontendURL } from '../../../helper/URLHelper';

export const routes = [
  {
    path: frontendURL('accounts/:accountId/calendar'),
    name: 'atoomo_calendar',
    roles: ['administrator', 'agent', 'client'],
    component: CalendarView,
  }
];