## 第二章 Redis 数据类型

### Redis的五大数据类型：

1. string（字符串）
2. hash（哈希，类似java里的Map）
3. list（列表）
4. set（集合）
5. zset(sorted set：有序集合)

### 一、String

String类型是二进制安全的。意思是redis的string可以包含任何数据。比如jpg图片或者序列化的对象 。string类型是Redis最基本的数据类型，一个redis中字符串value最多可以是512M。Strings 数据结构是简单的key-value类型，value其实不仅是String，也可以是数字.    

#### 应用场景：

String是最常用的一种数据类型，普通的key/ value 存储都可以归为此类.即可以完全实现目前 Memcached 的功能，并且效率更高。还可以享受Redis的定时持久化，操作日志及 Replication等功能。

#### 常用命令：

```shell
set key value # 赋值
```

```shell
get key # 取值
```

```shell
del key # 删除(可以多个)
```

```shell
append key # 追加
```

```shell
exists key # 判断某个key是否存在，1表示存在，0表示不存在
```

```shell
strlen key # 返回长度
```

```shell
move key db # 移动索引库，例如：move key1 5   将当前库中的key1移5号库
```

```shell
expire key 秒钟 # 为指定的key设置过期时间
```

```shell
ttl key # 查看还有多少秒过期，-1表示永不过期，-2表示已过期
```

```shell
type key # 查看你的key是什么类型
```

#### 数字值命令：

```shell
incr key # 将key中储存的数字值增一
```

```shell
decr key # 将key中储存的数字值减一
```

```shell
incrby key # 将key所储存的值加上给定的增量值（increment） 
```

```shell
decrby key # 将key所储存的值减去给定的减量值（decrement） 
```

#### 其它命令：

```shell
getrange key startindex endindex # 获取指定区间值(0到-1获取全部)
```

```shell
setrange key startindex endindex # 设置指定区间值
```

```shell
setex key time(秒) # value 将值value关联到key，并将key的过期时间设为seconds(以秒为单位)
```

```shell
setnx key value # 只有在key不存在时设置 key 的值，如果已经存在则不设置值
```

```shell
mset key value [key2 value2 ...] # 同时设置一个或多个键值对
```

```shell
mget key [key2 key3 ...] # 获取所有(一个或多个)给定key的值
```

```shell
msetnx key value [key2 value2 ...]  # 同时设置一个或多个键值对（key不存在时）在设置的过程中只要有一个失败，其他的都不会set成功
```

```shell
getset key value # 获取旧值，设置新值
```

#### Java 实例

```java
import redis.clients.jedis.Jedis;
 
public class RedisStringJava {
    public static void main(String[] args) {
        //连接本地的 Redis 服务
        Jedis jedis = new Jedis("192.168.41.22", 6379);
        System.out.println("连接成功");
        //设置 redis 字符串数据
        jedis.set("znsdkey", "www.znsd.com");
        // 获取存储的数据并输出
        System.out.println("redis 存储的字符串为: "+ jedis.get("znsdkey"));
    }
}
```

编译以上程序。 

```shell
连接成功
redis 存储的字符串为: www.znsd.com
```

### 二、List

Redis 列表是简单的字符串列表，按照插入顺序排序。你可以添加一个元素导列表的头部（左边）或者尾部（右边）。它的底层实际是个链表。

#### 应用场景：

Redis list的应用场景非常多，也是Redis最重要的数据结构之一，比如twitter的关注列表，粉丝列表等都可以用Redis的list结构来实现。Lists 就是链表，相信略有数据结构知识的人都应该能理解其结构。使用Lists结构，我们可以轻松地实现最新消息排行等功能。Lists的另一个应用就是消息队列，

可以利用Lists的PUSH操作，将任务存在Lists中，然后工作线程再用POP操作将任务取出进行执行。Redis还提供了操作Lists中某一段的api，你可以直接查询，删除Lists中某一段的元素。

#### 基本命令：

```shell
lpush key value [value2 ...] # 将一个或多个值插入到列表头部(允许值重复)
```

```shell
rpush key value [value2 ...] # 将一个或多个值插入到列表尾部(允许值重复)
```

```shell
lrange key startindex endindex # 获取列表指定范围内的元素(0到-1获取全部)
```

```shell
lindex key index # 通过索引获取列表中的元素
```

```shell
llen key # 获取指定key值的个数
```

```shell
lpop key # 移出并获取列表的第一个元素
```

```shell
rpop key # 移除并获取列表最后一个元素
```

#### 其他命令：

```shell
lrem key count value # 删除count个value
```

```shell
ltrim key start end # 截取指定范围的值后再赋值给key（让列表只保留指定区间内的元素，不在指定区间之内的元素都将被删除）
```

```shell
lset key index value # 通过索引设置列表元素的值
```

```shell
linsert key BEFORE|AFTER pivot value # 在列表指定的元素前或者后插入元素
```

#### Java 实例

```java
import java.util.List;
import redis.clients.jedis.Jedis;
 
public class RedisListJava {
    public static void main(String[] args) {
        //连接本地的 Redis 服务
        Jedis jedis = new Jedis("localhost");
        System.out.println("连接成功");
        //存储数据到列表中
        jedis.lpush("site-list", "znsd");
        jedis.lpush("site-list", "Google");
        jedis.lpush("site-list", "Taobao");
        // 获取存储的数据并输出
        List<String> list = jedis.lrange("site-list", 0 ,2);
        for(int i=0; i<list.size(); i++) {
            System.out.println("列表项为: "+list.get(i));
        }
    }
}
```

编译以上程序。 

```shell
连接成功
列表项为: Taobao
列表项为: Google
列表项为: znsd
```

#### 性能总结

- 它是一个字符串链表，left、right都可以插入和添加
- 如果键不存在，创建新的链表，如果键已经存在，新增内容，如果值全部移除，对应的键也消失了
- 链表的操作无论是对头和尾效率都极高，但假如是对中间元素进行操作，效率就很惨淡了

### 四、Set

Set是string类型的无序集合。它是通过HashTable实现实现的。

#### 应用场景：

Redis set对外提供的功能与list类似是一个列表的功能，特殊之处在于set是可以自动排重的，当你需要存储一个列表数据，又不希望出现重复数据时，set是一个很好的选择，并且set提供了判断某个成员是否在一个set集合内的重要接口，这个也是list所不能提供的。Sets 集合的概念就是一堆不重复值的组合。利用Redis提供的Sets数据结构，可以存储一些集合性的数据，比如在微博应用中，可以将一个用户所有的关注人存在一个集合中，将其所有粉丝存在一个集合。Redis还为集合提供了求交集、并集、差集等操作，可以非常方便的实现如共同关注、共同喜好、二度好友等功能，对上面的所有集合操作，你还可以使用不同的命令选择将结果返回给客户端还是存集到一个新的集合中。

#### 基本命令：

```shell
sadd key value [value2 ...] # 向集合添加一个或多个成员
```

```shell
smembers key # 返回集合中的所有成员
```

```shell
sismember key member # 判断 member 元素是否是集合 key 的成员
```

```shell
scard key # 获取集合里面的元素个数
```

```shell
srem key value # 删除集合中指定元素
```

```shell
spop key [count] # 移除集合中一个随机元素并返这个元素（可选择删除数量）
```

```shell
srandmember key [coutn] # 随机返回集合中一个或多个值
```

```shell
smove key1 key2 # 将key1里的某个值赋给key2
```

#### 其他命令：

```shell
sdiff key1 [key2] # 返回给定所有集合的差集
```

```shell
sinter key1 [key2] # 返回给定所有集合的交集
```

```shell
sunion key1 [key2] 返回所有给定集合的并集
```

### 三、Hash

Redis hash 是一个键值对集合。hash是一个string类型的field和value的映射表，hash特别适合用于存储对象。类似Java里面的Map<String,Object>。

#### 应用场景：

在Memcached中，我们经常将一些结构化的信息打包成HashMap，在客户端序列化后存储为一个字符串的值，比如用户的昵称、年龄、性别、积分等，这时候在需要修改其中某一项时，通常需要将所有值取出反序列化后，修改某一项的值，再序列化存储回去。**这样不仅增大了开销，也不适用于一些可能并发操作的场合**（比如两个并发的操作都需要修改积分）。而Redis的Hash结构可以使你像在数据库中Update一个属性一样只修改某一项属性值。 

#### 基本命令：   

```shell
hset key field value # 以hash方式存储
```

```shell
hget key field # 以hash方式获取
```

```shell
hmset key field value # [field value ...] 以hash方式存储一个或者多个
```

```shell
hmget key field # [field ...] 以hash方式获取一个或者多个
```

```shell
hgetall key # 获取在哈希表中指定key的所有字段和值
```

```shell
hdel key field [field ...] # 删除一个或多个哈希表字段
```

```shell
hkeys key # 获取所有哈希表中的字段
```

```shell
hvals key # 获取哈希表中所有值
```

#### 其他命令：

```shell
hlen key # 获取哈希表中字段的数量
```

```shell
hexists key # 查看哈希表key中，指定的字段是否存在
```

```shell
hincrby key field value # 为哈希表key中的指定字段的整数值加上增量value(必须为数字)
```

```shell
hincrbyfloat key field value # 为哈希表key中的指定字段的浮点数值加上增量value 
```

#### Java 实例

```java
import java.util.Iterator;
import java.util.Set;
import redis.clients.jedis.Jedis;
 
public class RedisKeyJava {
    public static void main(String[] args) {
        //连接本地的 Redis 服务
        Jedis jedis = new Jedis("localhost");
        System.out.println("连接成功");
 
        // 获取数据并输出
        Set<String> keys = jedis.keys("*"); 
        Iterator<String> it=keys.iterator() ;   
        while(it.hasNext()){   
            String key = it.next();   
            System.out.println(key);   
        }
    }
}
```

编译以上程序。 

```shell
连接成功
znsdkey
site-list
```

### 五、Zset

zset 和 set 一样也是string类型元素的集合,且不允许重复的成员。不同的是每个元素都会关联一个double类型的分数。redis正是通过分数来为集合中的成员进行从小到大的排序。zset的成员是唯一的,但分数(score)却可以重复。

#### 应用场景：

Redis sorted set的使用场景与set类似，区别是set不是自动有序的，而sorted set可以通过用户额外提供一个优先级(score)的参数来为成员排序，并且是插入有序的，即自动排序。当你需要一个有序的并且不重复的集合列表，那么可以选择sorted set数据结构，比如twitter 的public timeline可以以发表时间作为score来存储，这样获取时就是自动按时间排好序的。还可以用Sorted Sets来做带权重的队列，比如普通消息的score为1，重要消息的score为2，然后工作线程可以选择按score的倒序来获取工作任务。让重要的任务优先执行。

#### 基本命令：

```shell
zadd key score1 member1 [score2 member2] 向有序集合添加一个或多个成员，或者更新已存在成员的分数
```

```shell
zrange key startindex endindex [WITHSCORES] 通过索引区间返回有序集合成指定区间内的成员(WITHSCORES带出分数)
```

```shell
zscore key member 返回有序集中，成员的分数值
```

```shell
zrangebyscore key min max [WITHSCORES] [LIMIT] 通过分数返回有序集合指定区间内的成员
```

```shell
zrem key member [member ...] 删除一个或多个元素
```

```shell
zcard key 获取有序集合的成员数
```

#### 其他命令：

```shell
zcount key min max 计算在有序集合中指定区间分数的成员数
```

```shell
zrank key member 返回有序集合中指定成员的索引
```

```shell
zrevrank key member 返回有序集合中指定成员的排名，有序集成员按分数值递减(从大到小)排序
```

```shell
zrevrange key startindex endindex [WITHSCORES] 返回有序集中指定区间内的成员，通过索引，分数从高到底
```

```shell
zrevrangebyscore key max min [WITHSCORES] 返回有序集中指定分数区间内的成员，分数从高到低排序
```

### 