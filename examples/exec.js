import 'dotenv/config';
import { computeExec } from '../src/index.js';

const out = await computeExec({
  session_id: 'demo',
  cmd: 'echo hello'
});
console.log(out);
