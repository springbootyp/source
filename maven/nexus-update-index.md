## Nexus 私服手动更新索引

**1.  下载索引文件**
在http://repo.maven.apache.org/maven2/.index/ 中下载

- nexus-maven-repository-index.gz

- nexus-maven-repository-index.properties

- 然后再下载一个indexer-cli-5.1.0.jar （indexer的下载地址:http://maven.outofmemory.cn/org.apache.maven.indexer/indexer-cli/5.1.0/）

- indexer的Maven

  ```xml
  <dependency>
      <groupId>org.apache.maven.indexer</groupId>
      <artifactId>indexer-cli</artifactId>
      <version>5.1.0</version>
  </dependency>
  ```

**2.   解压缩索引文件**

- 将上面三个文件（.gz & .properties & .jar）放置到同一目录下，运行如下命令

  ```java
  java -jar indexer-cli-5.1.0.jar -u nexus-maven-repository-index.gz -d indexer
  ```

**3.   停止nexus4.   删除原有的索引文件**

- 将{nexus_home}\sonatype-work\nexus\indexer\central-ctx下的文件全部删掉

**5.   拷贝索引至central-ctx目录下**

- 将nexus-maven-repository-index.gz解压后的indexer目录中所有文件，放到sonatype-work\nexus\indexer\central-ctx下面

**6.   启动nexus即自动更新索引**