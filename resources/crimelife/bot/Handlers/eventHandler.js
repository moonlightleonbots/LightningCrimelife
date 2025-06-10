function loadEvents(client) {
  const fs = require("fs");

  const root = GetResourcePath(GetCurrentResourceName());

  const folders = fs.readdirSync(`${root}/bot/Events`);

  for (const folder of folders) {
    const files = fs
      .readdirSync(`${root}/bot/Events/${folder}`)
      .filter((file) => file.endsWith(".js"));
    for (const file of files) {
      const event = require(`${root}/bot/Events/${folder}/${file}`);

      if (event.rest) {
        if (event.once)
          client.rest.once(event.name, (...args) =>
            event.execute(...args, client)
          );
        else
          client.rest.on(event.name, (...args) =>
            event.execute(...args, client)
          );
      } else {
        if (event.once)
          client.once(event.name, (...args) => event.execute(...args, client));
        else client.on(event.name, (...args) => event.execute(...args, client));
      }
      continue;
    }
  }
}

module.exports = { loadEvents };
