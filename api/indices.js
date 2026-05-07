import { indices } from '../backend/src/data/sampleData.js';

export default function handler(_req, res) {
  res.status(200).json({
    data: indices,
    source: 'static-config'
  });
}
