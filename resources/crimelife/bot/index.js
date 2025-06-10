const {
  Client,
  Partials,
  Collection,
  GatewayIntentBits,
} = require("discord.js");
const { User, Message, GuildMember, ThreadMember, Channel, Reaction } =
  Partials;

const config = require("./bot/config.json");
const fs = require("fs");
const root = GetResourcePath(GetCurrentResourceName());
const p = require("./bot/version.json");
const v = p.version;

const fg = exports[config.FIVEGUARD_RESOURCE_NAME];

if (config.BOT_TOKEN == "") console.log("YOU'RE MISSING BOT TOKEN");
if (config.FIVEGUARD_RESOURCE_NAME == "")
  console.log("YOU'RE MISSING FIVEGUARD RESOURCE NAME");
if (!GetResourcePath(config.FIVEGUARD_RESOURCE_NAME))
  console.log("YOU PROVIDED WRONG FIVEGUARD RESOURCE NAME");

if (
  !fs.existsSync(
    `${GetResourcePath(
      config.FIVEGUARD_RESOURCE_NAME
    )}/ai_module_fg-obfuscated.lua`
  )
)
  console.log("PROVIDED RESOURCE NAME IS NOT A FIVEGUARD ANTICHEAT");

const client = new Client({
  intents: [
    32767,
    GatewayIntentBits.GuildMembers,
    GatewayIntentBits.MessageContent,
  ],
  partials: [User, Message, GuildMember, ThreadMember, Channel, Reaction],
});

const { loadEvents } = require(`${root}/bot/Handlers/eventHandler`);
const { loadCommands } = require(`${root}/bot/Handlers/commandHandler`);

client.fg = fg;
client.commands = new Collection();
client.events = new Collection();
client.UserBanLists = new Map();

client
  .login(config.BOT_TOKEN)
  .then(() => {
    loadEvents(client);
    loadCommands(client);
    console.log("Made by The ^4BEST CRIMELIFE^0 SERVER");
  })
  .catch((err) => {
    console.error(err);
  });
