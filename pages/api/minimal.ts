export default function handler(req: any, res: any) {
  res.status(200).json({ message: 'minimal API working', timestamp: new Date().toISOString() });
}