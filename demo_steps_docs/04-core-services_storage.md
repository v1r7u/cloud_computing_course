# Show Azure Storage Services

The goal: show Azure Storage Services

1. Open "create service" view and select Storage Account. Fill in the form:

    1. Create new resource group.

    2. Enter globally unique alphanumeric name.

    3. Select desired region.

    4. Select `Standard` Performance, and `LRS` Replication. Show that depending on choice options are changing. For example, premium storage backed by SSD allow only LRS replication.

    5. Explain _Advanced_ features: `hierarchical namespaces`, `sftp`, `nfs3`, `access tiers`

    6. Go to Networking. Stay with default but explain options.

    7. Go to Data Protection. Stay with default (each option is self-explanatory)

    8. Skip tags, create Storage Account.

2. Review created Storage Account

    1. Show Containers: create container, upload file.

    3. Show File Share: create fs, upload file, show change-tier and edit-quota.

    4. Show Table: create table.

    5. Show Queue: create queue, enqueue message.

    6. Show Storage Explorer: show all created resource + work with data.

3. At Azure Disk creation view show how size impact performance
