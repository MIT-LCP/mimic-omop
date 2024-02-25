# How to

Clone the repository

You might adapt the `postgres.conf` file to your hardware. In particular the `shared_memory`.

You will have to either download the `mimicdemo` or `mimiciii` datasets, and place them in the `mimic` folder,
respectively. `data-mimicdemo` and `data-mimiciii`. Place the (gzipped) csv files directly in the folder.

You will also need to download from athena the vocabulary and place it in the `extras/athena` folder.

Then run in the root folder:
```shell
docker compose -f docker/docker-compose.yml up
```

It should last almost one hour to build the database, and you will find the output gzipped csvs in the `etl/Result`
folder.
