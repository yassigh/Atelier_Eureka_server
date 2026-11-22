const express = require('express');
const Eureka = require('eureka-js-client').Eureka;
const pkg = require('./package.json');

const app = express();
const PORT = parseInt(process.env.PORT, 10) || 8083;

// Configuration du client Eureka
const client = new Eureka({
  instance: {
    instanceId: `localhost:meeting:${PORT}`,
    app: 'MEETING',
    hostName: 'localhost',
    ipAddr: '127.0.0.1',
    statusPageUrl: `http://localhost:${PORT}/info`,
    healthCheckUrl: `http://localhost:${PORT}/health`,
    port: {
      '$': PORT,
      '@enabled': 'true',
    },
    vipAddress: 'MEETING',
    dataCenterInfo: {
      '@class': 'com.netflix.appinfo.InstanceInfo$DefaultDataCenterInfo',
      name: 'MyOwn',
    },
  },
  eureka: {
    host: 'localhost',
    port: 8761,
    servicePath: '/eureka/apps/',
    maxRetries: 10,
    requestRetryDelay: 2000,
  },
});

// Endpoint de sante GET /health (Tâche 1)
app.get('/health', (req, res) => {
  res.status(200).json({ status: 'UP' });
});

// Endpoint d'information GET /info (Tâche 1 - lu depuis package.json)
app.get('/info', (req, res) => {
  res.status(200).json({
    app: {
      name: pkg.name,
      version: pkg.version,
      description: pkg.description
    }
  });
});

// Endpoint Hello demandé par l'atelier precedent
app.get('/api/meetings/hello', (req, res) => {
  res.json({
    message: 'Hello from Meeting service!',
    service: 'MEETING',
    port: PORT,
    timestamp: new Date().toISOString()
  });
});

const server = app.listen(PORT, () => {
  console.log(`[MEETING] Microservice démarré sur le port ${PORT}`);
  client.start((error) => {
    if (error) {
      console.error('[MEETING] Erreur lors de l\'enregistrement Eureka :', error);
    } else {
      console.log(`[MEETING] Enregistré avec succès auprès d'Eureka (port ${PORT})`);
    }
  });
});

// Arrêt propre
function gracefulShutdown() {
  console.log('\n[MEETING] Arrêt du service...');
  client.stop((error) => {
    if (error) {
      console.error('[MEETING] Erreur lors du désenregistrement Eureka :', error);
    } else {
      console.log('[MEETING] Désenregistré d\'Eureka.');
    }
    server.close(() => {
      console.log('[MEETING] Serveur HTTP arrêté.');
      process.exit(0);
    });
  });
}

process.on('SIGINT', gracefulShutdown);
process.on('SIGTERM', gracefulShutdown);
