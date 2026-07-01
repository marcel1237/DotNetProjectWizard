#!/usr/bin/env bash

set -euo pipefail

PROJECT_NAME="spring-batch-job"
ROOT="$HOME/java-projects/$PROJECT_NAME"

echo "Creating Spring Batch project..."

mkdir -p "$ROOT/src/main/java/com/example/batch/config"
mkdir -p "$ROOT/src/main/java/com/example/batch/job"
mkdir -p "$ROOT/src/main/java/com/example/batch/step"
mkdir -p "$ROOT/src/main/java/com/example/batch/processor"
mkdir -p "$ROOT/src/main/java/com/example/batch/reader"
mkdir -p "$ROOT/src/main/java/com/example/batch/writer"
mkdir -p "$ROOT/src/main/resources"

########################################
# pom.xml
########################################

cat > "$ROOT/pom.xml" <<'EOF'
<project xmlns="http://maven.apache.org/POM/4.0.0">
    <modelVersion>4.0.0</modelVersion>

    <groupId>com.example</groupId>
    <artifactId>spring-batch-job</artifactId>
    <version>1.0.0</version>

    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-batch</artifactId>
        </dependency>

        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter</artifactId>
        </dependency>
    </dependencies>

    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
        </plugins>
    </build>
</project>
EOF

########################################
# Main config
########################################

cat > "$ROOT/src/main/java/com/example/batch/config/BatchConfig.java" <<'EOF'
package com.example.batch.config;

import org.springframework.context.annotation.Configuration;

@Configuration
public class BatchConfig {
}
EOF

########################################
# Job
########################################

cat > "$ROOT/src/main/java/com/example/batch/job/ImportJob.java" <<'EOF'
package com.example.batch.job;

import org.springframework.batch.core.Job;
import org.springframework.batch.core.configuration.annotation.JobBuilderFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class ImportJob {

    @Bean
    public Job job(JobBuilderFactory jobBuilderFactory) {
        return jobBuilderFactory.get("importJob")
                .start(null)
                .build();
    }
}
EOF

########################################
# Step
########################################

cat > "$ROOT/src/main/java/com/example/batch/step/ImportStep.java" <<'EOF'
package com.example.batch.step;

import org.springframework.context.annotation.Configuration;

@Configuration
public class ImportStep {
}
EOF

########################################
# Processor
########################################

cat > "$ROOT/src/main/java/com/example/batch/processor/ItemProcessor.java" <<'EOF'
package com.example.batch.processor;

public class ItemProcessor {
    public String process(String item) {
        return item.toUpperCase();
    }
}
EOF

########################################
# Reader
########################################

cat > "$ROOT/src/main/java/com/example/batch/reader/FileReader.java" <<'EOF'
package com.example.batch.reader;

public class FileReader {
    public String read() {
        return "data";
    }
}
EOF

########################################
# Writer
########################################

cat > "$ROOT/src/main/java/com/example/batch/writer/FileWriter.java" <<'EOF'
package com.example.batch.writer;

public class FileWriter {
    public void write(String data) {
        System.out.println("Writing: " + data);
    }
}
EOF

########################################
# application.yml
########################################

cat > "$ROOT/src/main/resources/application.yml" <<'EOF'
spring:
  batch:
    job:
      enabled: true
EOF

echo "Spring Batch project created at $ROOT"