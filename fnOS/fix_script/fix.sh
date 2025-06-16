#！/bin/bash

#增加相关数据库

# 创建用户（如果不存在）
psql -U postgres -c "DO \$\$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'share') THEN
        CREATE USER share WITH PASSWORD 'VJvBDYpwpInozHz2ah';
    END IF;
END\$\$;"

psql -U postgres -c "DO \$\$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'trim_sac_admin') THEN
        CREATE USER trim_sac_admin WITH PASSWORD '4f2f10ab275c';
    END IF;
END\$\$;"

# 创建数据库并指定所有者
psql -U postgres -c "CREATE DATABASE trim_sharelink OWNER share;" 2>/dev/null || echo "Database trim_sharelink already exists."
psql -U postgres -c "CREATE DATABASE trim_sac OWNER trim_sac_admin;" 2>/dev/null || echo "Database trim_sac already exists."
psql -U postgres -c "CREATE DATABASE ai_manager OWNER postgres;" 2>/dev/null || echo "Database trim_sac already exists."
