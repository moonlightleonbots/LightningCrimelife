const { SlashCommandBuilder, EmbedBuilder } = require("discord.js");

const { PERMISSIONS, LANGUAGE } = require("../../config.json");

module.exports = {
    data: new SlashCommandBuilder()
        .setName("wsunban")
        .setDescription(LANGUAGE.WSUNBAN.DESCRIPTION)
        .addNumberOption(option => 
            option
                .setName("banid")
                .setDescription(LANGUAGE.WSUNBAN.OPTIONS.BANID.DESCRIPTION)
                .setRequired(true)
        )
        .addStringOption(option => 
            option
                .setName("grund")
                .setDescription(LANGUAGE.WSUNBAN.OPTIONS.BANID.REASON)
                .setRequired(false)
        ),
    async execute(interaction, client) {
        const roles = PERMISSIONS.UNBAN;
        const memberRoles = interaction.member.roles.cache.map(role => role.id);

        if (!roles.some(roleId => memberRoles.includes(roleId))) {
            return interaction.reply({
                embeds: [
                    new MessageEmbed()
                        .setColor("Red")
                        .setTimestamp()
                        .setDescription(LANGUAGE.NO_PERMISSION_INFO)
                ],
                ephemeral: true
            });
        }

        const banId = interaction.options.getNumber("banid");
        const reason = interaction.options.getString("grund") || "";
        const username = interaction.member.user.username;
        const discordId = interaction.member.user.id;

        const formattedReason = reason 
            ? `${reason} (Angefordert von ${username}, ID: ${discordId})`
            : `Entbannung beantragt von ${username}, ID: ${discordId}`;

        interaction.reply({
            embeds: [
                new MessageEmbed()
                    .setColor("GREEN")
                    .setAuthor(client.user.username, client.user.avatarURL())
                    .setTimestamp()
                    .setDescription(`BanID: ${banId} wurde entbannt. Grund: ${formattedReason}`)
            ]
        });
        emit("WS_Unban:WaveShieldExports", banId, formattedReason, `${username} (${discordId})`);
    }
};