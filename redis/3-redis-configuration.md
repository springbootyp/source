## 第三章 Redis常用配置

### INCLUDES(包含)

```shell
include /path/to/other.conf 这在你有标准配置模板但是每个redis服务器又需要个性设置的时候很有用
```

### GENERAL(一般常用) 

```shell
daemonize yes  Redis 默认不是以守护进程的方式运行，可以通过该配置项修改，使用yes启用守护进程(yes：后台运行；no：不是后台运行)
```

```shell
protected-mode yes 保护模式，默认开启。开启该参数后，redis只会本地进行访问，拒绝外部访问。
```

```shell
pidfile /var/run/redis/redis-server.pid redis的进程文件
```

```shell
port 6379 redis监听的端口号
```

```shell
tcp-backlog 511 TCP连接队列的长度
```

```shell
bind 127.0.0.1 指定redis只接收来自于该IP地址的请求，如果不进行设置，那么将处理所有请求
```

```shell
timeout 0 当客户端闲置多长时间后关闭连接，如果指定为0，表示关闭该功能
```

```shell
loglevel notice 
指定日志记录级别，Redis总共支持四个级别：debug、verbose、notice、warning，默认为verbose;
debug（很多信息，方便开发、测试）
verbose（许多有用的信息，但是没有debug级别信息多）
notice（适当的日志级别，适合生产环境）
warn（只有非常重要的信息）
```

```shell
logfile /var/log/redis/redis-server.log 日志记录方式，默认为标准输出，如果配置Redis为守护进程方式运行，而这里又配置为日志记录方式为标准输出，则日志将会发送给/dev/null。空字符串的话，日志会打印到标准输出设备。后台运行的redis标准输出是/dev/null
```

```shell
databases 16 设置数据库的数量，默认数据库为0，可以使用SELECT <dbid>命令在连接上指定数据库id
```

### <span id = "jump">SNAPSHOTTING</span>(快照) 

```shell
save <seconds> <changes> <指定时间间隔> <执行指定次数更新操作>，满足条件就将内存中的数据同步到硬盘中。
save "" 
save 900 1
save 300 10
save 60 10000
注释掉“save”这一行配置项就可以让保存数据库功能失效，设置sedis进行数据库镜像的频率。
900秒（15分钟）内至少1个key值改变（则进行数据库保存--持久化） 
300秒（5分钟）内至少10个key值改变（则进行数据库保存--持久化） 
60秒（1分钟）内至少10000个key值改变（则进行数据库保存--持久化）
```

```shell
stop-writes-on-bgsave-error yes 当RDB持久化出现错误后，是否依然进行继续进行工作，yes：不能进行工作，no：可以继续进行工作，可以通过info中的rdb_last_bgsave_status了解RDB持久化是否有错误
```

```shell
rdbcompression yes 使用压缩rdb文件，rdb文件压缩使用LZF压缩算法，yes：压缩，但是需要一些cpu的消耗。no：不压缩，需要更多的磁盘空间
```

```shell
rdbchecksum yes 是否校验rdb文件。从rdb格式的第五个版本开始，在rdb文件的末尾会带上CRC64的校验和。这跟有利于文件的容错性，但是在保存rdb文件的时候，会有大概10%的性能损耗，所以如果你追求高性能，可以关闭该配置。
```

```shell
dbfilename dump.rdb rdb文件的名称
```

```shell
dir /var/lib/redis 数据目录，数据库的写入会在这个目录。rdb、aof文件也会写在这个目录
```

### REPLICATION(复制)

```shell
slaveof <masterip> <masterport> 设置当本机为slav服务时，设置master服务的IP地址及端口，在Redis启动时，它会自动从master进行数据同步
```

```shell
masterauth <master-password> 当master服务设置了密码保护时，slav服务连接master的密码
```

```shell
slave-read-only yes 作为从服务器，默认情况下是只读的（yes），可以修改成NO，用于写（不建议）。
```

```shell
slave-priority 100 当master不可用，Sentinel会根据slave的优先级选举一个master。最低的优先级的slave，当选master。而配置成0，永远不会被选举
```

### SECURITY(安全)

```shell
requirepass foobared requirepass配置可以让用户使用AUTH命令来认证密码，才能使用其他命令。这让redis可以使用在不受信任的网络中。为了保持向后的兼容性，可以注释该命令，因为大部分用户也不需要认证。使用requirepass的时候需要注意，因为redis太快了，每秒可以认证15w次密码，简单的密码很容易被攻破，所以最好使用一个更复杂的密码。
```

### LIMITS(限制)

- **maxclients 10000** 设置能连上redis的最大客户端连接数量。默认是10000个客户端连接。由于redis不区分连接是客户端连接还是内部打开文件或者和slave连接等，所以maxclients最小建议设置到32。如果超过了maxclients，redis会给新的连接发送’max number of clients reached’，并关闭连接。

- **maxmemory \<bytes>** redis配置的最大内存容量。当内存满了，需要配合maxmemory-policy策略进行处理。注意slave的输出缓冲区是不计算在maxmemory内的。所以为了防止主机内存使用完，建议设置的maxmemory需要更小一些。
- **maxmemory-policy noeviction** 内存容量超过maxmemory后的处理策略

> 1. volatile-lru（Least Recently Used 即最近最少使用）：利用LRU算法移除key，只对设置了过期时间的key。
> 2. allkeys-lru：利用LRU算法移除所有key，与是否设置过期时间没关系。
> 3. volatile-random：随机移除设置了过期时间的key。
> 4. allkeys-random：随机移除任何key。与是否设置过期时间没关系。
> 5. volatile-ttl：移除即将过期的key。
> 6. noeviction：不移除任何key，只是返回一个写错误。

### <span id = "jump">APPEND ONLY MODE</span>(追加)

```shell
appendonly no 默认redis使用的是rdb方式持久化，这种方式在许多应用中已经足够用了。但是redis如果中途宕机，会导致可能有几分钟的数据丢失，根据save来策略进行持久化，Append Only File是另一种持久化方式，可以提供更好的持久化特性。Redis会把每次写入的数据在接收后都写入 appendonly.aof 文件，每次启动时Redis都会先把这个文件的数据读入内存里，先忽略RDB文件。
```

```shell
appendfilename "appendonly.aof" aof文件名
```

```shell
appendfsync everysec aof持久化策略的配置。
no表示不执行fsync，由操作系统保证数据同步到磁盘，速度最快。
always表示每次写入都执行fsync，以保证数据同步到磁盘。
everysec表示每秒执行一次fsync，可能会导致丢失这1s数据。
```

```shell
auto-aof-rewrite-percentage 100 aof自动重写配置。当目前aof文件大小超过上一次重写的aof文件大小的百分之多少进行重写，即当aof文件增长到一定大小的时候Redis能够调用bgrewriteaof对日志文件进行重写。当前AOF文件大小是上次日志重写得到AOF文件大小的二倍（设置为100）时，自动启动新的日志重写过程。
```

```shell
auto-aof-rewrite-min-size 64mb 设置允许重写的最小aof文件大小，避免了达到约定百分比但尺寸仍然很小的情况还要重写
```

### redis.conf常见配置

redis.conf 配置项说明如下：

```shell
# Redis默认不是以守护进程的方式运行，可以通过该配置项修改，使用yes启用守护进程
daemonize no

# 当Redis以守护进程方式运行时，Redis默认会把pid写入/var/run/redis.pid文件，可以通过pidfile指定
pidfile /var/run/redis.pid

# 指定Redis监听端口，默认端口为6379，作者在自己的一篇博文中解释了为什么选用6379作为默认端口，因为6379在手机按键上MERZ对应的号码，而MERZ取自意大利歌女Alessia Merz的名字
port 6379

# 绑定的主机地址
bind 127.0.0.1

# 当 客户端闲置多长时间后关闭连接，如果指定为0，表示关闭该功能
timeout 300

# 指定日志记录级别，Redis总共支持四个级别：debug、verbose、notice、warning，默认为verbose
loglevel verbose

# 日志记录方式，默认为标准输出，如果配置Redis为守护进程方式运行，而这里又配置为日志记录方式为标准输出，则日志将会发送给/dev/null
logfile stdout

# 设置数据库的数量，默认数据库为0，可以使用SELECT <dbid>命令在连接上指定数据库id
databases 16

# 指定在多长时间内，有多少次更新操作，就将数据同步到数据文件，可以多个条件配合
save <seconds> <changes>

# Redis默认配置文件中提供了三个条件：
    #save 900 1 # 900秒（15分钟）内有1个更改
    #save 300 10 # 300秒（5分钟）内有10个更改
    #save 60 10000 # 60秒内有10000个更改
# 指定存储至本地数据库时是否压缩数据，默认为yes，Redis采用LZF压缩，如果为了节省CPU时间，可以关闭该选项，但会导致数据库文件变的巨大
rdbcompression yes

# 指定本地数据库文件名，默认值为dump.rdb
dbfilename dump.rdb

# 指定本地数据库存放目录
dir ./

# 设置当本机为slav服务时，设置master服务的IP地址及端口，在Redis启动时，它会自动从master进行数据同步
slaveof <masterip> <masterport>

# 当master服务设置了密码保护时，slav服务连接master的密码
masterauth <master-password>

# 设置Redis连接密码，如果配置了连接密码，客户端在连接Redis时需要通过AUTH <password>命令提供密码，默认关闭
requirepass foobared

# 设置同一时间最大客户端连接数，默认无限制，Redis可以同时打开的客户端连接数为Redis进程可以打开的最大文件描述符数，如果设置 maxclients 0，表示不作限制。当客户端连接数到达限制时，Redis会关闭新的连接并向客户端返回max number of clients reached错误信息
maxclients 128

# 指定Redis最大内存限制，Redis在启动时会把数据加载到内存中，达到最大内存后，Redis会先尝试清除已到期或即将到期的Key，当此方法处理 后，仍然到达最大内存设置，将无法再进行写入操作，但仍然可以进行读取操作。Redis新的vm机制，会把Key存放内存，Value会存放在swap区
maxmemory <bytes>

# 指定是否在每次更新操作后进行日志记录，Redis在默认情况下是异步的把数据写入磁盘，如果不开启，可能会在断电时导致一段时间内的数据丢失。因为 redis本身同步数据文件是按上面save条件来同步的，所以有的数据会在一段时间内只存在于内存中。默认为no
appendonly no

# 指定更新日志文件名，默认为appendonly.aof
appendfilename appendonly.aof

# 指定更新日志条件，共有3个可选值： 
    #no：表示等操作系统进行数据缓存同步到磁盘（快） 
    #always：表示每次更新操作后手动调用fsync()将数据写到磁盘（慢，安全） 
    #everysec：表示每秒同步一次（折衷，默认值）
    #appendfsync everysec
    
# 指定是否启用虚拟内存机制，默认值为no，简单的介绍一下，VM机制将数据分页存放，由Redis将访问量较少的页即冷数据swap到磁盘上，访问多的页面由磁盘自动换出到内存中（在后面的文章我会仔细分析Redis的VM机制）
vm-enabled no

# 虚拟内存文件路径，默认值为/tmp/redis.swap，不可多个Redis实例共享
vm-swap-file /tmp/redis.swap

# 将所有大于vm-max-memory的数据存入虚拟内存,无论vm-max-memory设置多小,所有索引数据都是内存存储的(Redis的索引数据 就是keys),也就是说,当vm-max-memory设置为0的时候,其实是所有value都存在于磁盘。默认值为0
vm-max-memory 0

# Redis swap文件分成了很多的page，一个对象可以保存在多个page上面，但一个page上不能被多个对象共享，vm-page-size是要根据存储的 数据大小来设定的，作者建议如果存储很多小对象，page大小最好设置为32或者64bytes；如果存储很大大对象，则可以使用更大的page，如果不 确定，就使用默认值
vm-page-size 32

# 设置swap文件中的page数量，由于页表（一种表示页面空闲或使用的bitmap）是在放在内存中的，，在磁盘上每8个pages将消耗1byte的内存。
vm-pages 134217728

# 设置访问swap文件的线程数,最好不要超过机器的核数,如果设置为0,那么所有对swap文件的操作都是串行的，可能会造成比较长时间的延迟。默认值为4
vm-max-threads 4

# 设置在向客户端应答时，是否把较小的包合并为一个包发送，默认为开启
glueoutputbuf yes

# 指定在超过一定的数量或者最大的元素超过某一临界值时，采用一种特殊的哈希算法
	#hash-max-zipmap-entries 64
	#hash-max-zipmap-value 512
# 指定是否激活重置哈希，默认为开启（后面在介绍Redis的哈希算法时具体介绍）
activerehashing yes

# 指定包含其它的配置文件，可以在同一主机上多个Redis实例之间使用同一份配置文件，而同时各个实例又拥有自己的特定配置文件
include /path/to/local.conf
```

配置信息可以通过`config get` 获取

```shell
config get port # 获取redis端口号
config get dir # 获取启动路径
config get requirepass # 获取密码
config set requirepass "123456" # 设置redis密码
```



### 持久化(RDB/AOF)

### RDB

RDB（Redis Database） 是 Redis 默认的持久化方案。`它可以在指定的时间间隔内将内存中的数据集快照写入磁盘`，
也就是行话讲的Snapshot快照，它恢复时是将快照文件直接读到内存里，在RDB方式下，你有两种选择：

- 一种是手动执行持久化数据命令来让redis进行一次数据快照，

- 另一种则是根据你所配置的配置文件的策略，达到策略的某些条件时来自动持久化数据。

而手动执行持久化命令，你依然有两种选择：

- **save**命令

  `save命令执行时只管保存，其他不管，全部阻塞`，save操作在Redis主线程中工作，因此会**阻塞**其他请求操作，应该避免使用。（默认下，持久化到**dump.rdb**文件，并且在redis重启后，自动读取其中文件，据悉，通常情况下**一千万**的字符串类型键，**1GB**的快照文件，同步到内存中的 时间是**20-30秒**）

- **bgsave**命令。

  `bgsave后台备份，在备份的同时可以处理输入的数据`，bgSave则是调用Fork,产生子进程，父进程继续处理请求。子进程将数据写入临时文件，并在写完后，替换原有的.rdb文件。Fork发生时，父子进程内存共享，所以为了不影响子进程做数据快照，在这期间修改的数据，将会被复制一份，而不进共享内存。所以说，RDB所持久化的数据，是Fork发生时的数据。在这样的条件下进行持久化数据，如果因为某些情况宕机，则会丢失一段时间的数据。如果你的实际情况对数据丢失没那么敏感，丢失的也可以从传统数据库中获取或者说丢失部分也无所谓，那么你可以选择RDB持久化方式。

```shell
### 生产环境推荐配置（系统默认的）
# 15分钟修改1次
save 900 1
# 5分钟修改10次
save 300 10
# 一分钟修改一万次
save 60 10000

### 如果想禁用
# save ""
```

这是配置文件**默认的策略**，他们之间的关系是或，每隔**900**秒，在这期间变化了至少**一个**键值，做快照。或者每**三百秒**，变化了**十个**键值做快照。或者每**六十**秒，变化了至少**一万**个键值，做快照。  

### RDB配置

#### 触发RDB快照

- 在指定的时间间隔内，执行指定次数的写操作。
- 执行save（阻塞， 只管保存快照，其他的等待） 或者是bgsave （异步）命令。
- 执行flushall 命令，清空数据库所有数据，意义不大。
- 执行shutdown 命令，保证服务器正常关闭且不丢失任何数据，意义也不大。 

#### 数据恢复

将备份文件 (dump.rdb) 移动到 redis 安装目录并启动服务即可。

#### 优势

- 适合大规模的数据恢复
- 对数据完整性要求不高

#### 劣势

- 在一定时间做一次备份，如果redis意外宕机的话就会丢失最后一次快照后的所有数据
- Fork的时候，内存中的数据被克隆了一份，在fork的过程是非常耗时的，可能会导致Redis在一些毫秒级内不能响应客户端的请求

### AOF

- AOF（Append Only File） ，Redis 默认不开启。它的出现是为了弥补RDB的不足（数据的不一致性），所以**它采用日志的形式来记录每个写操作**，并**追加**到文件中。Redis 重启的会根据日志文件的内容将写指令从前到后执行一次以完成数据的恢复工作。
- 配置文件中的appendonly修改为yes。开启AOF持久化后，你所执行的每一条指令，都会被记录到**appendonly.aof**文件中。但事实上，并不会立即将命令写入到硬盘文件中，而是写入到硬盘缓存，在接下来的策略中，配置多久来从硬盘缓存写入到硬盘文件。所以在一定程度一定条件下，还是会有数据丢失，不过你可以大大减少数据损失。
- 这里是配置AOF持久化的策略。redis默认使用**everysec**，就是说每秒持久化一次，而always则是每次操作都会立即写入aof文件中。而**no**则是不主动进行同步操作，是默认30s一次。当然**always**一定是效率最低的，个人认为**everysec**就够用了，数据安全性能又高

####  AOF配置

- 开启AOF配置

```properties
# AOF and RDB persistence can be enabled at the same time without problems.
# AOF和RDB的持久化是可以同时开启的
# If the AOF is enabled on startup Redis will load the AOF, that is the file
# 如果启动时启用了AOF, Redis将先加载AOF
# with the better durability guarantees.

# 开启aop配置
appendonly yes

# aop生成文件名称
appendfilename "appendonly.aof"
```

#### 数据恢复

将备份文件 (appendonly.aof) 移动到 redis 安装目录并启动服务即可。

####  触发AOF快照

根据配置文件触发，可以是每次执行触发，可以是每秒触发，可以不同步。

- always：每修改同步
- `everysec`：每秒同步
- no：不同步

```properties
# 每修改同步：同步持久化 每次发生数据变更会被立即记录到磁盘，性能较差但数据完整性比较好
appendfsync always

# 每秒同步：默认设置，异步操作，每秒记录   如果一秒内宕机，有数据丢失（推荐）
appendfsync everysec

# 不同步：从不同步
appendfsync no
```

#### AOF rewrite(重写)

- AOF采用文件追加方式，文件会越来越大为避免出现此种情况，新增了重写机制，当AOF文件的大小超过所设定的阈值时，Redis就会启动AOF文件的内容压缩，只保留可以恢复数据的最小指令集.可以使用命令bgrewriteaof。

- AOF文件持续增长而过大时，会fork出一条新进程来将文件重写(也是先写临时文件最后再rename)，
  遍历新进程的内存中数据，每条记录有一条的Set语句。重写aof文件的操作，并没有读取旧的aof文件，
  而是将整个内存中的数据库内容用命令的方式重写了一个新的aof文件，这点和快照有点类似。

- `Redis会记录上次重写时的AOF大小，默认配置是当AOF文件大小是上次rewrite后大小的一倍且文件大于64M时触发。`

#### AOP文件修复

```shell
redis-check-aof --fix appendonly.aof
```

####  RDB & AOF比较

#### 优势

RDB：适合大规模的数据恢复。如果业务对数据完整性和一致性要求不高，RDB是很好的选择。

AOF：数据的完整性和一致性更高。

#### 劣势

RDB：数据的完整性和一致性不高，因为RDB可能在最后一次备份时宕机了。 备份时占用内存，因为Redis 在备份时会独立创建一个子进程，将数据写入到一个临时文件（此时内存中的数据是原来的两倍哦），最后再将临时文件替换之前的备份文件。所以Redis 的持久化和数据的恢复要选择在夜深人静的时候执行是比较合理的。

AOF：因为AOF记录的内容多，文件会越来越大，数据恢复也会越来越慢。

####  总结

- Redis 默认开启RDB持久化方式，在指定的时间间隔内，执行指定次数的写操作，则将内存中的数据写入到磁盘中。
- RDB 持久化适合大规模的数据恢复但它的数据一致性和完整性较差。
- Redis 需要手动开启AOF持久化方式，默认是每秒将写操作日志追加到AOF文件中。
- AOF 的数据完整性比RDB高，但记录内容多了，会影响数据恢复的效率。
- Redis 针对 AOF文件大的问题，提供重写的瘦身机制。
- 若只打算用Redis 做缓存，可以关闭持久化。
- 若打算使用Redis 的持久化。建议RDB和AOF都开启。其实RDB更适合做数据的备份，留一后手。AOF出问题了，还有RDB

### 事物

redis的事务中，一次执行多条命令，本质是一组命令的集合，一个事务中所有的命令将被序列化，即按顺序执行而不会被其他命令插入在redis中，事务的作用就是在一个队列中一次性、顺序性、排他性的执行一系列的命令。事务可以一次执行多个命令， 并且带有以下两个重要的保证：

1. 事务是一个单独的隔离操作：事务中的所有命令都会序列化、按顺序地执行。事务在执行的过程中，不会被其他客户端发送来的命令请求所打断。

2. 事务是一个原子操作：事务中的命令要么全部被执行，要么全部都不执行。

#### 使用事物

用multi命令开启事物，用exec执行事物。

例子：

```shell
127.0.0.1:6379> MULTI
OK
127.0.0.1:6379> set k1 v1
QUEUED
127.0.0.1:6379> set k2 v2
QUEUED
127.0.0.1:6379> get k1
QUEUED
127.0.0.1:6379> set k3 v3
QUEUED
127.0.0.1:6379> EXEC
1) OK
2) OK
3) "v1"
4) OK
```

#### 执行结果：

① 正常执行完成；

② 有命令入队不成功，事物执行失败，全部命令都不执行；

③ 命令入队成功，事物照常执行，有命令执行失败，其余命令正常执行；

#### 放弃事物

在使用multi开起事物之后，可以使用discard放弃当前事物。

例子：

```shell
127.0.0.1:6379> MULTI
OK
127.0.0.1:6379> set k1 vv
QUEUED
127.0.0.1:6379> set k2 vv2
QUEUED
127.0.0.1:6379> DISCARD
OK
127.0.0.1:6379> get k1
"v1"
```

#### 事物-监控

redis可以监控一个或多个键，一旦其中有一个键被修改（或删除），之后的事务就不会执行。监控一直持续到EXEC命令（事务中的命令是在EXEC之后才执行的）。

#### 监控

```shell
watch key [key ...] 
```

例子：

````shell
127.0.0.1:6379> watch k1
127.0.0.1:6379> MULTI
OK
127.0.0.1:6379> set k1 v1
QUEUED
127.0.0.1:6379> set k2 v2
QUEUED
127.0.0.1:6379> EXEC
(ni1)
````

#### 放弃监控

```shell
unwatch 取消 WATCH 命令对所有 key 的监视。
```

### 消息发布订阅

#### 消息发布订阅是什么

- Redis 发布订阅(pub/sub)是一种消息通信模式：发送者(pub)发送消息，订阅者(sub)接收消息。

- Redis 客户端可以订阅任意数量的频道。

- 下图展示了频道 channel1 ， 以及订阅这个频道的三个客户端 —— client2 、 client5 和 client1 之间的关系：

  ![pubsub1](http://www.znsd.com/znsd/courses/uploads/6aad840023d733b6e5e1c8406d695036/pubsub1.png)

- 当有新消息通过 PUBLISH 命令发送给频道 channel1 时， 这个消息就会被发送给订阅它的三个客户端：

  ![pubsub2](http://www.znsd.com/znsd/courses/uploads/1f61a26a9fa1c7a719decde751bd55e2/pubsub2.png)



#### 发布订阅命令

| 序号 | 命令及描述                                                   |
| ---- | ------------------------------------------------------------ |
| 1    | PSUBSCRIBE pattern [pattern ...]  订阅一个或多个符合给定模式的频道。 |
| 2    | PUBSUB subcommand [argument [argument ...\]] 查看订阅与发布系统状态。 |
| 3    | `PUBLISH` channel message将信息发送到指定的频道。            |
| 4    | PUNSUBSCRIBE [pattern [pattern ...\]] 退订所有给定模式的频道。 |
| 5    | `SUBSCRIBE` channel [channel ...\]订阅给定的一个或多个频道的信息。 |
| 6    | UNSUBSCRIBE [channel [channel ...\]]指退订给定的频道。       |

#### 实例

1. 可以一次性订阅多个

   ```shell
   SUBSCRIBE c1 c2 c3
   ```

2. 消息发布

   ```shell
   PUBLISH c1 helloredis
   ```

3. 订阅多个可以使用通配符*

   ```shell
   PSUBSCRIBE new*
   ```

4. 接收消息

   ```shell
   PUBLISH new1 redis2018
   PUBLISH new2 redis2018
   ```


### 主从复制

在Redis中，用户可以通过执行SLAVEOF命令或者设置slaveof选项，让一个服务器去复制（replicate）另一个服务器，我们称呼被复制的服务器为主服务器（master），而对主服务器进行复制的服务器则被称为从服务器（slave）。通常用作读写分离，以及数据恢复。

#### 配置主从

##### 认主：

在从库里使用slaveof命令，从库认主后，从库只能做读操作;

当主机挂求后，从机原地待命；

当从机挂求重启后，从机变主机；

当使用redis.conf认主，不使用命令配置认主。

```shell
slaveof host port 认主
```

```shell
info [section] 查看redis信息（带replication参数可直接看主从信息）
```

```shell
SLAVEOF no one 将从库转成主库，并保已有数据
```

#### 哨兵模式

Redis的主从架构，如果master发现故障了，还得手动将slave切换成master继续服务，手动的方式容易造成失误，导致数据丢失，那Redis有没有一种机制可以在master和slave进行监控，并在master发送故障的时候，能自动将slave切换成master呢？有的，那就是哨兵。

##### 哨兵的作用： 

1. 监控redis进行状态，包括master和slave 
2. 当master down机，能自动将slave切换成master

##### 配置哨兵：

新建配置文件，命名为sentinel.conf，输入下面内容

```shell
sentinel monitor mymaster 192.168.137.101 6379 1
#sentinel auth-pass myMaster master123 #配置密码
```

mymaster ：master服务的名称，随便定义 

#####  启动哨兵：

```shell
redis-sentinel sentinel.conf 
```