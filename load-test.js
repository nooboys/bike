import http from 'k6/http';
import { sleep } from 'k6';
export const options = {
  vus: 50,
  duration: '30s',
};
export default function () {
  http.get('https://eusqaenvwebapp.azurewebsites.net');
  sleep(1);
}
