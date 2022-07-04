# syntax=docker/dockerfile:1

# Set Steam variables
FROM cm2network/steamcmd:root
LABEL maintainer='tom@toakan.uk'

# Set Steam variables
ENV STEAMAPPID 1963720
ENV STEAMAPP core-keeper
ENV STEAMAPPDIR "${HOMEDIR}/${STEAMAPP}"
ENV STEAMAPPDATA "${HOMEDIR}/${STEAMAPP}-data"

# Setup default files
COPY ./entry.sh ${HOMEDIR}/entry.sh
COPY ./launch.sh ${HOMEDIR}/launch.sh

# Intall required packagess & set directory permissions
RUN set -x \
        && apt-get update \
        && apt-get install -y --no-install-recommends --no-install-suggests \
        xvfb libx32gcc-s1 lib32gcc-s1 build-essential\
        && mkdir -p "${STEAMAPPDIR}" \
        && mkdir -p "${HOMEDIR}/${STEAMAPP}-data" \
        && chmod +x "${HOMEDIR}/entry.sh" \
        && chmod +x "${HOMEDIR}/launch.sh" \
        && chown -R "${USER}:${USER}" "${HOMEDIR}/entry.sh" "${HOMEDIR}/launch.sh" "${STEAMAPPDIR}"

# Setup server variables
ENV WORLD_INDEX=0 \
        WORLD_NAME="Core Keeper Server" \
        WORLD_SEED=0 \
        GAME_ID="" \
        DATA_PATH="" \
        MAX_PLAYERS=10 \
        IP="0.0.0.0" \      
        PORT=""

# Switch to user
USER ${USER}

# Switch to workdir
WORKDIR ${HOMEDIR}

VOLUME ${STEAMAPPDIR}

CMD ["bash", "entry.sh"]

EXPOSE ${PORT}