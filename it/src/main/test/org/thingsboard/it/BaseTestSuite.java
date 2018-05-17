package org.thingsboard.it;

import com.palantir.docker.compose.DockerComposeRule;
import org.junit.ClassRule;
import org.junit.extensions.cpsuite.ClasspathSuite;
import org.junit.runner.RunWith;

import javax.swing.filechooser.FileSystemView;
import java.io.File;


@RunWith(ClasspathSuite.class)
@ClasspathSuite.ClassnameFilters({
        "org.thingsboard.it.*Test"
})
public class BaseTestSuite {

        @ClassRule
        public static DockerComposeRule docker = DockerComposeRule.builder()
                .file(getDockerDirectory())
                .build();

        private static String getDockerDirectory()
        {
                String rootDir = new File(System.getProperty("user.dir")).getParent();
                return rootDir + "/docker/cluster/docker-compose-cluster.yml";
        }

}


